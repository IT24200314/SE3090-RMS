# =================================================================================================
# File: planner.py
# Module: Agentic AI Subsystem - Planning & Coordination Agent Node
# Student Contributor: Upamada Ekanayake (Group Leader - IT24200314)
# Architecture: AI Layer - LangGraph Node responsible for objective decomposition & multi-step planning
# Purpose: Analyzes high-level user domain intent (e.g. lease onboarding vs. repair triage), constructs
#          a deterministic 4-step execution plan, and routes execution to specialized domain agents.
# =================================================================================================

import time
from models.state import WorkflowState, AgentStep

def planning_agent_node(state: WorkflowState) -> WorkflowState:
    """
    Upamada (Planning & Coordination Node):
    Deconstructs natural language domain objective and builds a structured, deterministic step plan.
    """
    start_time = time.time()
    
    objective = state.domain_objective.lower()
    plan: list[str] = []
    
    if state.target_entity_type == "TENANT_APPLICATION" or "screen" in objective or "tenant" in objective:
        plan = [
            "1. Extract applicant declared monthly income and requested property rent",
            "2. Execute verify_credit_and_identity_tool for financial ratio calculation",
            "3. Audit scoring bounds against 35% standard threshold",
            "4. Route to Deterministic Validation & HITL Node"
        ]
        state.target_entity_type = "TENANT_APPLICATION"
    elif state.target_entity_type == "MAINTENANCE" or "repair" in objective or "maintenance" in objective or "leak" in objective:
        plan = [
            "1. Analyze issue description and classify trade category",
            "2. Execute estimate_repair_budget_tool for repair cost modeling",
            "3. Query check_contractor_availability_tool for certified dispatch match",
            "4. Perform Deterministic LKR 50K Policy check and route to HITL node if needed"
        ]
        state.target_entity_type = "MAINTENANCE"
    else:
        plan = [
            "1. Validate domain parameters",
            "2. Generate execution steps",
            "3. Finalize state verification"
        ]

    execution_ms = round((time.time() - start_time) * 1000, 2)
    
    state.plan_steps = plan
    state.agent_trace.append(
        AgentStep(
            agent_name="Upamada (Planning Agent)",
            action="Objective Decomposition & Execution Plan Generation",
            status="SUCCESS",
            output_summary=f"Created {len(plan)}-step execution plan for {state.target_entity_type}",
            execution_time_ms=execution_ms
        )
    )
    return state
