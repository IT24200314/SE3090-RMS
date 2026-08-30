# =================================================================================================
# File: allowlisted_tools.py
# Module: Agentic AI Subsystem - Allow-listed Sandboxed Domain Tools
# Student Contributors: Upamada Ekanayake, Nethmi Seya, Hashini Wicramathilake
# Architecture: AI Layer - Pure python deterministic domain tools callable by LangGraph agents
# Purpose: Provides sandboxed, verifiable tools for financial ratio calculations, repair budget
#          estimations, and contractor directory lookups without external network vulnerabilities.
# =================================================================================================

from typing import Dict, Any

def verify_credit_and_identity_tool(tenant_id: str, monthly_income: float, property_rent: float) -> Dict[str, Any]:
    """
    Deterministic tool calculating rent-to-income ratio, KYC check status, and risk scoring.
    """
    if monthly_income <= 0:
        raise ValueError("Monthly income must be greater than zero.")

    ratio = (property_rent / monthly_income) * 100.0
    
    # Financial risk assessment
    if ratio > 50.0:
        risk_score = 35
        recommendation = "REJECT_HIGH_DEBT_RATIO"
        passed_kyc = False
    elif ratio > 35.0:
        risk_score = 65
        recommendation = "REQUIRES_MANAGER_REVIEW"
        passed_kyc = True
    else:
        risk_score = 92
        recommendation = "APPROVED_FINANCIALLY_SOUND"
        passed_kyc = True

    return {
        "tenant_id": tenant_id,
        "rent_to_income_ratio": round(ratio, 2),
        "calculated_risk_score": risk_score,
        "identity_verified": passed_kyc,
        "recommendation": recommendation
    }

def estimate_repair_budget_tool(issue_description: str, priority: str) -> Dict[str, Any]:
    """
    Deterministic cost modeling & trade classification tool for maintenance tickets.
    """
    desc = issue_description.lower()
    
    if any(k in desc for k in ["leak", "pipe", "drain", "plumb"]):
        trade = "Plumbing Services"
        cost = 65000.0 if any(k in desc for k in ["burst", "flood"]) else 18000.0
        calculated_priority = "EMERGENCY" if "burst" in desc else priority or "MEDIUM"
    elif any(k in desc for k in ["spark", "wiring", "power", "electric"]):
        trade = "Electrical Engineering"
        cost = 55000.0 if any(k in desc for k in ["panel", "short"]) else 22000.0
        calculated_priority = "HIGH" if "spark" in desc else priority or "MEDIUM"
    elif any(k in desc for k in ["roof", "wall", "structure", "crack"]):
        trade = "Structural / Masonry"
        cost = 85000.0
        calculated_priority = "HIGH"
    else:
        trade = "General Handyman"
        cost = 12000.0
        calculated_priority = priority or "LOW"

    return {
        "trade_category": trade,
        "estimated_cost": cost,
        "evaluated_priority": calculated_priority,
        "exceeds_hitl_threshold": cost >= 50000.0  # LKR 50K policy threshold
    }

def check_contractor_availability_tool(trade_category: str) -> Dict[str, Any]:
    """
    Retrieves certified available contractor directory based on trade category.
    """
    contractors = {
        "Plumbing Services": "Lanka QuickPlumb Services (Pvt) Ltd",
        "Electrical Engineering": "ElectroMaster Engineering Works",
        "Structural / Masonry": "Metro Build & Masonry Specialists",
        "General Handyman": "All-Fix Handyman Crew"
    }
    return {
        "trade_category": trade_category,
        "selected_contractor": contractors.get(trade_category, "All-Fix Handyman Crew"),
        "status": "AVAILABLE",
        "dispatch_sla_hours": 2
    }
