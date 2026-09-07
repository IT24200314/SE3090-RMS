# =================================================================================================
# File: test_agent_workflow.py
# Module: Agentic AI Subsystem - Automated Graph Node & Flow Test Suite
# Student Contributors: Upamada Ekanayake, Nethmi Seya, Hashini Wicramathilake
# Architecture: AI Layer - Pytest suite testing planning, screening, maintenance, and HITL nodes
# Purpose: Verifies multi-agent state transformations, tool integrations, deterministic thresholds,
#          and human-in-the-loop pause states across all 3 team member contributions.
# =================================================================================================

import pytest
from models.state import WorkflowState
from workflow import rms_orchestrator

def test_planning_agent_objective_decomposition():
    state = WorkflowState(
        workflow_id="TEST-PLAN-01",
        domain_objective="Screen new tenant applicant for Havelock property",
        target_entity_type="TENANT_APPLICATION",
        target_entity_id="t-001",
        tenant_income=250000.0,
        property_rent=50000.0
    )
    result = rms_orchestrator.invoke(state)
    
    assert len(result["plan_steps"]) > 0
    assert result["agent_trace"][0].agent_name == "Upamada (Planning Agent)"
    assert result["agent_trace"][0].status == "SUCCESS"

def test_tenant_screening_low_risk_auto_approval():
    state = WorkflowState(
        workflow_id="TEST-SCREEN-01",
        domain_objective="Evaluate rental application financial viability",
        target_entity_type="TENANT_APPLICATION",
        target_entity_id="t-002",
        tenant_income=300000.0,
        property_rent=60000.0  # 20% ratio (<= 35%)
    )
    result = rms_orchestrator.invoke(state)
    
    assert result["screening_score"] == 92
    assert result["rent_to_income_ratio"] == 20.0
    assert result["validation_passed"] is True
    assert result["requires_human_approval"] is False
    assert result["final_status"] == "COMPLETED"

def test_tenant_screening_moderate_risk_hitl_pause():
    state = WorkflowState(
        workflow_id="TEST-SCREEN-02",
        domain_objective="Evaluate application for moderate income applicant",
        target_entity_type="TENANT_APPLICATION",
        target_entity_id="t-003",
        tenant_income=200000.0,
        property_rent=80000.0  # 40% ratio (> 35% and <= 50%)
    )
    result = rms_orchestrator.invoke(state)
    
    assert result["screening_score"] == 65
    assert result["requires_human_approval"] is True
    assert result["final_status"] == "PENDING_APPROVAL"

def test_maintenance_burst_pipe_exceeds_50k_hitl_pause():
    state = WorkflowState(
        workflow_id="TEST-MAINT-01",
        domain_objective="Triage emergency burst pipe in apartment",
        target_entity_type="MAINTENANCE",
        target_entity_id="m-001",
        issue_description="Burst pipe causing severe flood in kitchen",
        reported_priority="HIGH"
    )
    result = rms_orchestrator.invoke(state)
    
    assert result["trade_category"] == "Plumbing Services"
    assert result["estimated_cost"] == 65000.0
    assert result["requires_human_approval"] is True
    assert result["final_status"] == "PENDING_APPROVAL"
    assert "exceeds" in result["approval_reason"].lower()

def test_maintenance_minor_repair_auto_approved():
    state = WorkflowState(
        workflow_id="TEST-MAINT-02",
        domain_objective="Triage sticking door lock",
        target_entity_type="MAINTENANCE",
        target_entity_id="m-002",
        issue_description="Front door lock sticking occasionally",
        reported_priority="LOW"
    )
    result = rms_orchestrator.invoke(state)
    
    assert result["trade_category"] == "General Handyman"
    assert result["estimated_cost"] == 12000.0
    assert result["requires_human_approval"] is False
    assert result["final_status"] == "COMPLETED"
