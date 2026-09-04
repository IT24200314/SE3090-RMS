# =================================================================================================
# File: maintenance_agent.py
# Module: Agentic AI Subsystem - Maintenance Triage & Dispatch Agent Node
# Student Contributor: Hashini Wicramathilake (IT24200314 Group Member)
# Architecture: AI Layer - LangGraph Node for trade categorization and repair cost modeling
# Purpose: Employs heuristic keyword classifiers to match defects to trade categories (Plumbing,
#          Electrical, Structural), invokes cost modeling tools, and looks up contractor availability.
# =================================================================================================

import time
from models.state import WorkflowState, AgentStep
from tools.allowlisted_tools import estimate_repair_budget_tool, check_contractor_availability_tool

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
    
    execution_ms = round((time.time() - start_time) * 1000, 2)
    state.agent_trace.append(
        AgentStep(
            agent_name="Hashini (Triage & Validation Agent)",
            action="Cost Estimation & Contractor Dispatch Tool Call",
            status="SUCCESS",
            output_summary=summary,
            execution_time_ms=execution_ms
        )
    )
    return state
