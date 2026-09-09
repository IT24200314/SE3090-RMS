# =================================================================================================
# File: maintenance_agent.py
# Module: Agentic AI Subsystem - Maintenance Triage & Dispatch Agent Node
# Student Contributor: Hashini Wicramathilake (IT24200314 Group Member)
# Architecture: AI Layer - LangGraph Node for trade categorization and repair cost modeling
# Purpose: Employs heuristic keyword classifiers to match defects to trade categories (Plumbing,
#          Electrical, Structural), invokes cost modeling tools, and looks up contractor availability.
# =================================================================================================

import time
import os
from pathlib import Path
from dotenv import dotenv_values
from models.state import WorkflowState, AgentStep
from tools.allowlisted_tools import estimate_repair_budget_tool, check_contractor_availability_tool

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

def maintenance_triage_agent_node(state: WorkflowState) -> WorkflowState:
    """
    Hashini (Maintenance Triage Node):
    Classifies trade category, executes cost modeling tools, and looks up contractor SLA dispatch.
    """
    start_time = time.time()
    
    desc = state.issue_description or "General inspection requested"
    priority = state.reported_priority or "MEDIUM"
    
    # 1. Cost & Trade Estimation Tool
    estimate_result = estimate_repair_budget_tool(desc, priority)
    state.trade_category = estimate_result["trade_category"]
    state.estimated_cost = estimate_result["estimated_cost"]
    
    # 2. Certified Contractor Lookup Tool
    contractor_result = check_contractor_availability_tool(state.trade_category)
    state.recommended_contractor = contractor_result["selected_contractor"]
    
    summary = (
        f"Triaged issue: Classified as '{state.trade_category}'. "
        f"Estimated cost LKR {state.estimated_cost:,.2f}. "
        f"Matched certified contractor '{state.recommended_contractor}'."
    )
    
    # Generate brief contractor diagnosis notes using Gemini LLM if connected
    client = get_gemini_client()
    if client:
        try:
            llm_prompt = (
                f"You are a property maintenance engineer for Rental Management System.\n"
                f"Defect: '{desc}' | Trade: {state.trade_category} | Cost: LKR {state.estimated_cost:,.2f}.\n"
                f"Write a 1-sentence technical instruction for contractor {state.recommended_contractor}."
            )
            res = client.models.generate_content(
                model="gemini-flash-latest",
                contents=llm_prompt
            )
            if res.text:
                summary += f" | Gemini AI Brief: {res.text.strip()}"
        except Exception:
            pass
            
    execution_ms = round((time.time() - start_time) * 1000, 2)
    state.agent_trace.append(
        AgentStep(
            agent_name="Hashini (Triage & Validation Agent)",
            action="Cost Modeling & Dispatch via Gemini + Allowlisted Tools",
            status="SUCCESS",
            output_summary=summary,
            execution_time_ms=execution_ms
        )
    )
    return state
