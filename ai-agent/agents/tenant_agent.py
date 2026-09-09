# =================================================================================================
# File: tenant_agent.py
# Module: Agentic AI Subsystem - Tenant Screening & Risk Agent Node
# Student Contributor: Nethmi Seya (IT24200314 Group Member)
# Architecture: AI Layer - LangGraph Node for financial viability and KYC validation
# Purpose: Invokes allowlisted credit/identity verification tools, checks debt-to-income thresholds,
#          and outputs structured credit risk scores (0-100) with detailed evaluation notes.
# =================================================================================================

import time
import os
from pathlib import Path
from dotenv import dotenv_values
from models.state import WorkflowState, AgentStep
from tools.allowlisted_tools import verify_credit_and_identity_tool

def get_gemini_client():
    api_key = os.environ.get("GEMINI_API_KEY")
    if not api_key:
        env_dict = dotenv_values(Path(__file__).parent.parent / ".env")
        api_key = env_dict.get("GEMINI_API_KEY")
    if api_key:
        try:
            from google import genai
            return genai.Client(api_key=api_key)
        except Exception:
            return None
    return None

def tenant_screening_agent_node(state: WorkflowState) -> WorkflowState:
    """
    Nethmi (Tenant Screening Node):
    Executes sandboxed financial ratio tools, credit bounds checks, and calculates 0-100 risk scoring.
    """
    start_time = time.time()
    
    income = state.tenant_income or 250000.0
    rent = state.property_rent or 50000.0
    
    try:
        tool_result = verify_credit_and_identity_tool(
            tenant_id=state.target_entity_id,
            monthly_income=income,
            property_rent=rent
        )
        
        state.screening_score = tool_result["calculated_risk_score"]
        state.rent_to_income_ratio = tool_result["rent_to_income_ratio"]
        state.identity_verified = tool_result["identity_verified"]
        
        summary = (
            f"Screened tenant: Rent-to-income {tool_result['rent_to_income_ratio']}% -> "
            f"Risk Score {tool_result['calculated_risk_score']}/100 ({tool_result['recommendation']})"
        )
        
        # Synthesize professional assessment using Gemini LLM if available
        client = get_gemini_client()
        if client:
            try:
                llm_prompt = (
                    f"You are a tenant screening expert for the Rental Management System.\n"
                    f"Applicant monthly income: LKR {income:,.2f}, Rent: LKR {rent:,.2f}, "
                    f"Rent-to-income ratio: {tool_result['rent_to_income_ratio']}%, Risk Score: {tool_result['calculated_risk_score']}/100.\n"
                    f"Provide a 1-sentence professional landlord advisory note."
                )
                res = client.models.generate_content(
                    model="gemini-flash-latest",
                    contents=llm_prompt
                )
                if res.text:
                    summary += f" | Gemini AI Advisory: {res.text.strip()}"
            except Exception:
                pass
                
        status = "SUCCESS"
    except Exception as ex:
        summary = f"Tool execution failed: {str(ex)}"
        status = "FAILED"

    execution_ms = round((time.time() - start_time) * 1000, 2)
    state.agent_trace.append(
        AgentStep(
            agent_name="Nethmi (Risk Scoring Agent)",
            action="Financial Assessment & Identity Verification via Gemini + Tools",
            status=status,
            output_summary=summary,
            execution_time_ms=execution_ms
        )
    )
    return state
