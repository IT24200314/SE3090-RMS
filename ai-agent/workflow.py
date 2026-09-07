# =================================================================================================
# File: workflow.py
# Module: Agentic AI Subsystem - LangGraph Multi-Agent StateGraph Definition
# Student Contributor: Upamada Ekanayake (Group Leader - IT24200314)
# Architecture: AI Layer - LangGraph Orchestration & Dynamic Conditional Edge Routing
# Purpose: Compiles the multi-agent StateGraph connecting the Planning Agent (Upamada),
#          Screening Agent (Nethmi), Maintenance Agent (Hashini), and Deterministic Validator.
# =================================================================================================

from langgraph.graph import StateGraph, START, END
from models.state import WorkflowState
from agents.planner import planning_agent_node
from agents.tenant_agent import tenant_screening_agent_node
from agents.maintenance_agent import maintenance_triage_agent_node
from agents.validator import deterministic_validator_node

def route_next_agent(state: WorkflowState) -> str:
    """
    Conditional edge router directing flow to the correct specialized domain agent.
    """
    if state.target_entity_type == "TENANT_APPLICATION":
        return "tenant_agent"
    elif state.target_entity_type == "MAINTENANCE":
        return "maintenance_agent"
    return "validator"

def build_rms_state_graph():
    """
    Builds and compiles the multi-agent StateGraph for Rental Management System.
    """
    workflow = StateGraph(WorkflowState)
    
    # 1. Register Graph Nodes
    workflow.add_node("planner", planning_agent_node)
    workflow.add_node("tenant_agent", tenant_screening_agent_node)
    workflow.add_node("maintenance_agent", maintenance_triage_agent_node)
    workflow.add_node("validator", deterministic_validator_node)
    
    # 2. Add Graph Edges
    workflow.add_edge(START, "planner")
    
    # Dynamic routing after planner node
    workflow.add_conditional_edges(
        "planner",
        route_next_agent,
        {
            "tenant_agent": "tenant_agent",
            "maintenance_agent": "maintenance_agent",
            "validator": "validator"
        }
    )
    
    workflow.add_edge("tenant_agent", "validator")
    workflow.add_edge("maintenance_agent", "validator")
    workflow.add_edge("validator", END)
    
    return workflow.compile()

# Pre-compiled workflow graph singleton
rms_orchestrator = build_rms_state_graph()
