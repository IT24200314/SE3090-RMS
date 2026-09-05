# =================================================================================================
# File: test_api_endpoints.py
# Module: Agentic AI Subsystem - FastAPI TestClient HTTP Endpoint Suite
# Student Contributors: Upamada Ekanayake, Nethmi Seya, Hashini Wicramathilake
# Architecture: AI Layer - Integration testing for FastAPI microservice routes
# Purpose: Tests /health, /agent/workflow/start, and /agent/workflow/evaluate-golden-case endpoints
#          to guarantee internal interoperability with ASP.NET Core Web API orchestrator calls.
# =================================================================================================

from fastapi.testclient import TestClient
from main import app

client = TestClient(app)

def test_health_endpoint():
    response = client.get("/health")
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "HEALTHY"
    assert len(data["supported_agents"]) == 3

def test_workflow_start_endpoint_maintenance():
    payload = {
        "domain_objective": "Triage burst pipe in bathroom",
        "target_entity_type": "MAINTENANCE",
        "issue_description": "Burst pipe flooding bathroom floor",
        "reported_priority": "HIGH"
    }
    response = client.post("/agent/workflow/start", json=payload)
    assert response.status_code == 200
    data = response.json()
    assert data["trade_category"] == "Plumbing Services"
    assert data["estimated_cost"] == 65000.0
    assert data["requires_human_approval"] is True
    assert data["final_status"] == "PENDING_APPROVAL"

def test_golden_cases_rubric_endpoint():
    response = client.post("/agent/workflow/evaluate-golden-case")
    assert response.status_code == 200
    data = response.json()
    assert data["all_golden_cases_passed"] is True
    assert len(data["summary"]) == 3
