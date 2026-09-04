# =================================================================================================
# File: validator.py
# Module: Agentic AI Subsystem - Deterministic Validator & Human-in-the-Loop Node
# Student Contributor: Hashini Wicramathilake (IT24200314 Group Member)
# Architecture: AI Layer - Guardrail & Safety Node enforcing policy ceilings and approval state pauses
# Purpose: Applies non-hallucinatory deterministic rule assertions (e.g. repair cost >= LKR 50,000,
#          risk score <= 65) to halt workflow progression at PENDING_APPROVAL for human manager review.
# =================================================================================================

import time
from models.state import WorkflowState, AgentStep

HIGH_COST_THRESHOLD = 50000.0  # Policy ceiling LKR 50,000
MODERATE_RISK_THRESHOLD = 65

def deterministic_validator_node(state: WorkflowState) -> WorkflowState:
    """
    Deterministic Validation & Human-in-the-Loop Node:
    Validates output bounds against strict system safety policies without LLM hallucinations.
    Pauses execution at PENDING_APPROVAL when safety thresholds are triggered.
    """
    start_time = time.time()
    
    requires_approval = False
    reasons = []
    
    # 1. Maintenance High-Cost Policy Check
    if state.estimated_cost is not None and state.estimated_cost >= HIGH_COST_THRESHOLD:
        requires_approval = True
        reasons.append(f"Estimated repair cost (LKR {state.estimated_cost:,.2f}) exceeds LKR {HIGH_COST_THRESHOLD:,.2f} policy threshold.")
        
    # 2. Tenant Screening Risk Policy Check
    if state.screening_score is not None and state.screening_score <= MODERATE_RISK_THRESHOLD:
        requires_approval = True
        reasons.append(f"Tenant screening risk score ({state.screening_score}/100) requires manager manual risk evaluation.")

    state.validation_passed = True
    state.requires_human_approval = requires_approval
    
    if requires_approval:
        state.final_status = "PENDING_APPROVAL"
        state.approval_reason = " | ".join(reasons)
        step_status = "HITL_PAUSED"
        summary = f"[HITL PAUSED] State graph paused at PendingManagerApproval. Reason: {state.approval_reason}"
    else:
        state.final_status = "COMPLETED"
        state.approval_reason = None
        step_status = "SUCCESS"
        summary = "[APPROVED] All deterministic validation rules passed. Auto-approved without manager intervention."

    execution_ms = round((time.time() - start_time) * 1000, 2)
    state.agent_trace.append(
        AgentStep(
            agent_name="Deterministic Validation & Policy Node",
            action="Schema, Boundary & Human-in-the-Loop Policy Audit",
            status=step_status,
            output_summary=summary,
            execution_time_ms=execution_ms
        )
    )
    return state
