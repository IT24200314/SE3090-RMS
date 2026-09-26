# =================================================================================================
# File: test_agent_golden_dataset.py
# Module: Agentic AI Subsystem - Golden Case Acceptance Benchmark Suite
# Student Contributors: Upamada Ekanayake, Nethmi Seya, Hashini Wicramathilake
# Architecture: AI Layer - Pytest Golden Dataset Evaluation & Benchmark
# Purpose: Validates the 5 canonical golden evaluation test cases against deterministic business
#          rules, multi-step planning, tool outputs, and Human-in-the-Loop policy thresholds.
# =================================================================================================

import pytest
from models.state import WorkflowState
from workflow import rms_orchestrator

class TestGoldenCaseBenchmark:
    """
    Evaluates system behavior against strict golden ground-truth specifications.
    """

    def test_golden_case_1_prime_applicant_auto_approved(self):
        """
        Golden Case 1: High income, low rent-to-income ratio (20%).
        Expected: Score > 85, no human approval needed, final status COMPLETED.
        """
        state = WorkflowState(
            workflow_id="GOLDEN-01-PRIME-TENANT",
            domain_objective="Screen applicant for luxury sea view flat",
            target_entity_type="TENANT_APPLICATION",
            target_entity_id="app-golden-01",
            tenant_income=350000.0,
            property_rent=70000.0
        )
        result = rms_orchestrator.invoke(state)

        assert result["final_status"] == "COMPLETED"
        assert result["validation_passed"] is True
        assert result["requires_human_approval"] is False
        assert result["screening_score"] >= 85
        assert result["rent_to_income_ratio"] == 20.0
        assert any(step.agent_name == "Nethmi (Risk Scoring Agent)" for step in result["agent_trace"])

    def test_golden_case_2_borderline_applicant_triggers_hitl(self):
        """
        Golden Case 2: Debt-to-income ratio exceeds 35% safe threshold.
        Expected: Requires manager approval, final status PENDING_APPROVAL.
        """
        state = WorkflowState(
            workflow_id="GOLDEN-02-MODERATE-RISK",
            domain_objective="Screen tenant application with high debt-to-income",
            target_entity_type="TENANT_APPLICATION",
            target_entity_id="app-golden-02",
            tenant_income=180000.0,
            property_rent=80000.0  # 44.4% ratio
        )
        result = rms_orchestrator.invoke(state)

        assert result["final_status"] == "PENDING_APPROVAL"
        assert result["requires_human_approval"] is True
        assert result["rent_to_income_ratio"] > 35.0
        assert "risk score" in result["approval_reason"].lower() or "screening" in result["approval_reason"].lower()

    def test_golden_case_3_high_cost_emergency_violates_50k_ceiling(self):
        """
        Golden Case 3: Emergency burst pipe repair costing LKR 65,000 (> LKR 50,000 policy ceiling).
        Expected: Paused at PENDING_APPROVAL for manager financial signoff.
        """
        state = WorkflowState(
            workflow_id="GOLDEN-03-BURST-PIPE",
            domain_objective="Triage major water leakage in kitchen ceiling",
            target_entity_type="MAINTENANCE",
            target_entity_id="maint-golden-03",
            issue_description="Burst water pipe spraying high pressure water across apartment floor",
            reported_priority="EMERGENCY"
        )
        result = rms_orchestrator.invoke(state)

        assert result["final_status"] == "PENDING_APPROVAL"
        assert result["requires_human_approval"] is True
        assert result["trade_category"] == "Plumbing Services"
        assert result["estimated_cost"] >= 50000.0
        assert "exceeds" in result["approval_reason"].lower()

    def test_golden_case_4_minor_handyman_job_auto_dispatched(self):
        """
        Golden Case 4: Routine low-cost maintenance (LKR 12,000 < LKR 50,000).
        Expected: Auto-approved without manager intervention, status COMPLETED.
        """
        state = WorkflowState(
            workflow_id="GOLDEN-04-MINOR-REPAIR",
            domain_objective="Triage squeaky bedroom door hinges",
            target_entity_type="MAINTENANCE",
            target_entity_id="maint-golden-04",
            issue_description="Door hinges squeaking and latch sticks",
            reported_priority="LOW"
        )
        result = rms_orchestrator.invoke(state)

        assert result["final_status"] == "COMPLETED"
        assert result["requires_human_approval"] is False
        assert result["estimated_cost"] < 50000.0
        assert result["trade_category"] == "General Handyman"

    def test_golden_case_5_multi_step_planning_decomposition(self):
        """
        Golden Case 5: Verify Planning Agent decomposes complex lease/onboarding goal.
        Expected: Generates structured sequential plan with distinct agent delegations.
        """
        state = WorkflowState(
            workflow_id="GOLDEN-05-PLANNING",
            domain_objective="Onboard verified tenant to Marine Drive luxury residence",
            target_entity_type="TENANT_APPLICATION",
            target_entity_id="app-golden-05",
            tenant_income=400000.0,
            property_rent=80000.0
        )
        result = rms_orchestrator.invoke(state)

        assert len(result["plan_steps"]) >= 3
        # Ensure planning trace contains execution latency
        planner_trace = next((s for s in result["agent_trace"] if "Planning" in s.agent_name), None)
        assert planner_trace is not None
        assert planner_trace.status == "SUCCESS"
        assert planner_trace.execution_time_ms > 0
