# =================================================================================================
# File: tenant_agent.py
# Module: Agentic AI Subsystem - Tenant Screening & Risk Agent Node
# Student Contributor: Nethmi Seya (IT24200314 Group Member)
# Architecture: AI Layer - LangGraph Node for financial viability and KYC validation
# Purpose: Invokes allowlisted credit/identity verification tools, checks debt-to-income thresholds,
#          and outputs structured credit risk scores (0-100) with detailed evaluation notes.
# =================================================================================================

import time
from models.state import WorkflowState, AgentStep
from tools.allowlisted_tools import verify_credit_and_identity_tool

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
        status = "SUCCESS"
    except Exception as ex:
        summary = f"Tool execution failed: {str(ex)}"
        status = "FAILED"

    execution_ms = round((time.time() - start_time) * 1000, 2)
    state.agent_trace.append(
        AgentStep(
            agent_name="Nethmi (Risk Scoring Agent)",
            action="Financial Assessment & Identity Verification Tool Call",
            status=status,
            output_summary=summary,
            execution_time_ms=execution_ms
        )
    )
    return state
