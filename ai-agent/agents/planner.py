# =================================================================================================
# File: planner.py
# Module: Agentic AI Subsystem - Planning & Coordination Agent Node
# Student Contributor: Upamada Ekanayake (Group Leader - IT24200314)
# Architecture: AI Layer - LangGraph Node responsible for objective decomposition & multi-step planning
# Purpose: Analyzes high-level user domain intent (e.g. lease onboarding vs. repair triage), constructs
#          a deterministic 4-step execution plan, and routes execution to specialized domain agents.
# =================================================================================================

import time
import os
from models.state import WorkflowState, AgentStep

def get_gemini_client():
    api_key = os.environ.get("GEMINI_API_KEY")
    if not api_key:
        from pathlib import Path
        from dotenv import dotenv_values
        env_dict = dotenv_values(Path(__file__).parent.parent / ".env")
        api_key = env_dict.get("GEMINI_API_KEY")
    if api_key:
        try:
            from google import genai
            return genai.Client(api_key=api_key)
        except Exception:
            return None
    return None

def planning_agent_node(state: WorkflowState) -> WorkflowState:
    """
    Upamada (Planning & Coordination Node):
    Deconstructs natural language domain objective and builds a structured step plan using Gemini LLM.
    """
    start_time = time.time()
    
    objective = state.domain_objective.lower()
    plan: list[str] = []
    llm_powered = False
    
    # Try generating plan via real Gemini LLM if connected
    client = get_gemini_client()
    if client:
        try:
            prompt = (
                f"You are the Planning Agent for a Rental Management System (RMS).\n"
                f"Objective: {state.domain_objective}\n"
                f"Entity Type: {state.target_entity_type}\n"
                f"Generate exactly 4 numbered execution steps for the workflow. Keep each step concise under 15 words."
            )
            response = client.models.generate_content(
                model="gemini-flash-latest",
                contents=prompt
            )
            lines = [line.strip() for line in response.text.split("\n") if line.strip() and (line[0].isdigit() or line.startswith("-"))]
            if len(lines) >= 3:
                plan = lines[:4]
                llm_powered = True
        except Exception:
            llm_powered = False

    # Fallback deterministic structured plan if LLM is offline or busy
    if not plan:
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
    model_tag = "Google Gemini 2.5 Flash LLM" if llm_powered else "Deterministic Rule-Engine"
    state.agent_trace.append(
        AgentStep(
            agent_name="Upamada (Planning Agent)",
            action=f"Objective Decomposition via {model_tag}",
            status="SUCCESS",
            output_summary=f"Created {len(plan)}-step execution plan for {state.target_entity_type} ({model_tag})",
            execution_time_ms=execution_ms
        )
    )
    return state
