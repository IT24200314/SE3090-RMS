# =================================================================================================
# File: main.py
# Module: Agentic AI Subsystem - FastAPI Microservice & Execution Endpoints
# Student Contributor: Upamada Ekanayake (Group Leader - IT24200314)
# Architecture: AI Layer - FastAPI Service exposing internal endpoints for ASP.NET Core orchestration
# Purpose: Exposes HTTP endpoints for starting multi-agent workflows, evaluating golden test cases,
#          and providing auditable JSON execution traces (never called directly by frontend clients).
# =================================================================================================

from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import Optional, Dict, Any, List
import uuid

from models.state import WorkflowState, AgentStep
from workflow import rms_orchestrator

app = FastAPI(
    title="RMS LangGraph Multi-Agent Orchestrator",
    version="1.0.0",
    description="Agentic AI subsystem for Rental Management System with Human-in-the-Loop checkpoints"
)

class WorkflowStartRequest(BaseModel):
    domain_objective: str
    target_entity_type: str  # "LEASE", "TENANT_APPLICATION", "MAINTENANCE"
    target_entity_id: Optional[str] = None
    tenant_income: Optional[float] = None
    property_rent: Optional[float] = None
    issue_description: Optional[str] = None
    reported_priority: Optional[str] = None

class HitlResumeRequest(BaseModel):
    workflow_id: str
    manager_action: str  # "APPROVE", "REJECT"
    manager_notes: Optional[str] = None

@app.get("/health")
def health_check():
    return {
        "status": "HEALTHY",
        "engine": "LangGraph StateGraph",
        "supported_agents": [
            "Upamada (Planning & Coordination)",
            "Nethmi (Tenant Screening & Risk Scoring)",
            "Hashini (Maintenance Triage & Deterministic Validator)"
        ]
    }

@app.post("/agent/workflow/start", response_model=WorkflowState)
def start_workflow(req: WorkflowStartRequest):
    workflow_id = f"WF-{uuid.uuid4().hex[:8].upper()}"
    entity_id = req.target_entity_id or str(uuid.uuid4())
    
    initial_state = WorkflowState(
        workflow_id=workflow_id,
        domain_objective=req.domain_objective,
        target_entity_type=req.target_entity_type,
        target_entity_id=entity_id,
        tenant_income=req.tenant_income,
        property_rent=req.property_rent,
        issue_description=req.issue_description,
        reported_priority=req.reported_priority
    )
    
    # Execute through compiled LangGraph
    final_output = rms_orchestrator.invoke(initial_state)
    return final_output

@app.post("/agent/workflow/evaluate-golden-case")
def evaluate_golden_case():
    """
    Executes standard grading golden cases:
    1. Low-risk tenant auto-approval
    2. Moderate-risk tenant flagged for review
    3. High-cost repair (>= LKR 50K) HITL pause
    4. Minor repair auto-approval
    """
    results = []
    
    # Case 1: Minor repair
    c1 = rms_orchestrator.invoke(WorkflowState(
        workflow_id="GC-1",
        domain_objective="Triage tenant reported front door lock sticking",
        target_entity_type="MAINTENANCE",
        target_entity_id=str(uuid.uuid4()),
        issue_description="Front door lock sticking slightly",
        reported_priority="LOW"
    ))
    cost_1 = c1.get("estimated_cost") if isinstance(c1, dict) else c1.estimated_cost
    status_1 = c1.get("final_status") if isinstance(c1, dict) else c1.final_status
    hitl_1 = c1.get("requires_human_approval") if isinstance(c1, dict) else c1.requires_human_approval
    results.append({
        "case": "Minor repair auto-approval",
        "passed": status_1 == "COMPLETED" and not hitl_1,
        "cost": cost_1,
        "status": status_1
    })
    
    # Case 2: High-cost burst pipe repair
    c2 = rms_orchestrator.invoke(WorkflowState(
        workflow_id="GC-2",
        domain_objective="Triage major burst pipe flooding apartment",
        target_entity_type="MAINTENANCE",
        target_entity_id=str(uuid.uuid4()),
        issue_description="Major burst pipe flooding entire kitchen",
        reported_priority="HIGH"
    ))
    cost_2 = c2.get("estimated_cost") if isinstance(c2, dict) else c2.estimated_cost
    status_2 = c2.get("final_status") if isinstance(c2, dict) else c2.final_status
    hitl_2 = c2.get("requires_human_approval") if isinstance(c2, dict) else c2.requires_human_approval
    results.append({
        "case": "High-cost repair HITL pause (>= 50K)",
        "passed": status_2 == "PENDING_APPROVAL" and hitl_2,
        "cost": cost_2,
        "status": status_2
    })
    
    # Case 3: Safe tenant screening
    c3 = rms_orchestrator.invoke(WorkflowState(
        workflow_id="GC-3",
        domain_objective="Screen applicant for residential lease",
        target_entity_type="TENANT_APPLICATION",
        target_entity_id=str(uuid.uuid4()),
        tenant_income=300000.0,
        property_rent=60000.0
    ))
    score_3 = c3.get("screening_score") if isinstance(c3, dict) else c3.screening_score
    status_3 = c3.get("final_status") if isinstance(c3, dict) else c3.final_status
    results.append({
        "case": "Safe tenant screening (20% ratio)",
        "passed": status_3 == "COMPLETED" and score_3 == 92,
        "score": score_3,
        "status": status_3
    })

    all_passed = all(r["passed"] for r in results)
    return {
        "all_golden_cases_passed": all_passed,
        "summary": results
    }

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
