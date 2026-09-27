#!/usr/bin/env python3
"""
=================================================================================================
Script: generate_report_diagrams.py
Purpose: Generates high-resolution academic figures and charts for the SE3090 Consolidated Report:
         1. System Architecture Diagram
         2. Database Entity Relationship Diagram (ERD)
         3. Human-in-the-Loop (HITL) Workflow Sequence Diagram
         4. LangGraph Multi-Agent StateGraph Diagram
         5. Performance Latency & Concurrency Benchmark Chart
         6. Test Pyramid & Coverage Distribution Chart
=================================================================================================
"""

import os
import matplotlib.pyplot as plt
import matplotlib.patches as patches

os.makedirs("docs/figures", exist_ok=True)

# Set global styles
plt.rcParams['font.family'] = 'sans-serif'
plt.rcParams['font.sans-serif'] = ['DejaVu Sans', 'Arial', 'Helvetica']

# =============================================================================================
# 1. System Architecture Diagram
# =============================================================================================
def generate_system_architecture():
    fig, ax = plt.subplots(figsize=(11, 7), dpi=300)
    ax.set_xlim(0, 11)
    ax.set_ylim(0, 7)
    ax.axis('off')

    # Title
    ax.text(5.5, 6.7, "Rental Management System (RMS) - Integrated System Architecture",
            ha='center', va='center', fontsize=14, fontweight='bold', color='#0F172A')

    # Layer 1: Client Tier
    rect_client = patches.FancyBboxPatch((0.5, 4.8), 10, 1.5, boxstyle="round,pad=0.2",
                                         facecolor='#EFF6FF', edgecolor='#3B82F6', linewidth=1.5)
    ax.add_patch(rect_client)
    ax.text(0.8, 6.0, "CLIENT LAYER (Dual Multi-Platform Interfaces)", fontsize=10, fontweight='bold', color='#1E40AF')

    # React App Box
    rect_react = patches.FancyBboxPatch((1.2, 5.0), 3.8, 0.9, boxstyle="round,pad=0.1",
                                        facecolor='#FFFFFF', edgecolor='#2563EB', linewidth=1.2)
    ax.add_patch(rect_react)
    ax.text(3.1, 5.55, "React 19 Admin Dashboard (Vercel Live)", ha='center', va='center', fontsize=9, fontweight='bold', color='#1E293B')
    ax.text(3.1, 5.25, "Property & Lease Governance | HITL Review Cards", ha='center', va='center', fontsize=7.5, color='#475569')

    # Flutter App Box
    rect_flutter = patches.FancyBboxPatch((6.0, 5.0), 3.8, 0.9, boxstyle="round,pad=0.1",
                                          facecolor='#FFFFFF', edgecolor='#0284C7', linewidth=1.2)
    ax.add_patch(rect_flutter)
    ax.text(7.9, 5.55, "Flutter 3.24+ Mobile App (Android APK)", ha='center', va='center', fontsize=9, fontweight='bold', color='#1E293B')
    ax.text(7.9, 5.25, "Camera KYC Capture | GPS Geolocation Tagging", ha='center', va='center', fontsize=7.5, color='#475569')

    # Arrow Down from Clients to API
    ax.annotate("", xy=(5.5, 4.1), xytext=(5.5, 4.8),
                arrowprops=dict(arrowstyle="->", color="#1E293B", lw=2, mutation_scale=15))
    ax.text(5.5, 4.45, "HTTPS / JSON Payload (JWT Bearer Token)", ha='center', va='center',
            fontsize=8, fontweight='bold', color='#1E293B', backgroundcolor='#FFFFFF')

    # Layer 2: Backend Core API
    rect_api = patches.FancyBboxPatch((0.5, 2.3), 10, 1.7, boxstyle="round,pad=0.2",
                                      facecolor='#F8FAFC', edgecolor='#475569', linewidth=1.5)
    ax.add_patch(rect_api)
    ax.text(0.8, 3.75, "BACKEND CORE: ASP.NET Core 10 Web API (Render Cloud Live)", fontsize=10, fontweight='bold', color='#0F172A')

    # API Internal Components
    boxes_api = [
        (0.9, "Controllers & DTOs", "Auth, Properties, Leases,\nTenants, Maintenance, Audit"),
        (4.0, "Application Services", "Clean Architecture Core,\nDomain Validation, RBAC"),
        (7.2, "EF Core 10 / Npgsql", "Database Context, Transactions,\nConnection URI Parser")
    ]
    for x, title, sub in boxes_api:
        r = patches.FancyBboxPatch((x, 2.5), 2.9, 1.0, boxstyle="round,pad=0.1",
                                   facecolor='#FFFFFF', edgecolor='#64748B', linewidth=1.0)
        ax.add_patch(r)
        ax.text(x + 1.45, 3.15, title, ha='center', va='center', fontsize=8.5, fontweight='bold', color='#1E293B')
        ax.text(x + 1.45, 2.75, sub, ha='center', va='center', fontsize=7, color='#64748B')

    # Arrows to DB and AI
    ax.annotate("", xy=(2.8, 1.5), xytext=(2.8, 2.3),
                arrowprops=dict(arrowstyle="->", color="#1E293B", lw=2, mutation_scale=15))
    ax.text(2.8, 1.9, "Npgsql / SSL Connection", ha='center', va='center', fontsize=7.5, fontweight='bold', color='#047857', backgroundcolor='#FFFFFF')

    ax.annotate("", xy=(8.2, 1.5), xytext=(8.2, 2.3),
                arrowprops=dict(arrowstyle="->", color="#1E293B", lw=2, mutation_scale=15))
    ax.text(8.2, 1.9, "Internal HTTP Microservice Call", ha='center', va='center', fontsize=7.5, fontweight='bold', color='#B45309', backgroundcolor='#FFFFFF')

    # Layer 3 Left: Database
    rect_db = patches.FancyBboxPatch((0.5, 0.3), 4.6, 1.1, boxstyle="round,pad=0.15",
                                     facecolor='#ECFDF5', edgecolor='#10B981', linewidth=1.5)
    ax.add_patch(rect_db)
    ax.text(2.8, 1.05, "PostgreSQL 16 Engine (Neon Cloud Serverless)", ha='center', va='center', fontsize=9, fontweight='bold', color='#065F46')
    ax.text(2.8, 0.65, "Users, Properties, Leases, TenantApplications, Tickets, AuditLogs\nAutomated Connection Pooling & EF Core Migrations", ha='center', va='center', fontsize=7.5, color='#047857')

    # Layer 3 Right: Agentic AI
    rect_ai = patches.FancyBboxPatch((5.9, 0.3), 4.6, 1.1, boxstyle="round,pad=0.15",
                                     facecolor='#FFFBEB', edgecolor='#F59E0B', linewidth=1.5)
    ax.add_patch(rect_ai)
    ax.text(8.2, 1.05, "LangGraph Multi-Agent Orchestrator (FastAPI)", ha='center', va='center', fontsize=9, fontweight='bold', color='#92400E')
    ax.text(8.2, 0.65, "Planning Node | Risk Scoring | Maintenance Triage\nDeterministic Validator & LKR 50K Financial Guardrail", ha='center', va='center', fontsize=7.5, color='#B45309')

    plt.tight_layout()
    plt.savefig("docs/figures/system_architecture.png", dpi=300)
    plt.close()
    print("Generated: docs/figures/system_architecture.png")

# =============================================================================================
# 2. Database Entity Relationship Diagram (ERD)
# =============================================================================================
def generate_database_erd():
    fig, ax = plt.subplots(figsize=(11, 7.5), dpi=300)
    ax.set_xlim(0, 11)
    ax.set_ylim(0, 7.5)
    ax.axis('off')

    ax.text(5.5, 7.2, "Rental Management System (RMS) - Relational Database ERD (3NF)",
            ha='center', va='center', fontsize=14, fontweight='bold', color='#0F172A')

    tables = [
        # (x, y, w, h, name, fields)
        (0.6, 4.2, 3.0, 2.6, "Users (Core Identity)",
         ["Id : UUID (PK)", "FullName : VARCHAR(100)", "Email : VARCHAR(150) (UQ)", "PasswordHash : TEXT (PBKDF2)",
          "PhoneNumber : VARCHAR(20)", "Role : INT (Enum: 0,1,2)", "CreatedAtUtc : TIMESTAMPTZ"]),
        
        (4.0, 4.2, 3.1, 2.6, "Properties (Real Estate)",
         ["Id : UUID (PK)", "LandlordId : UUID (FK -> Users)", "Title : VARCHAR(200) (IX)", "Description : TEXT",
          "Address : VARCHAR(300)", "MonthlyRent : DECIMAL(18,2)", "SecurityDeposit : DECIMAL(18,2)",
          "Status : INT (Available, Occupied)"]),
        
        (7.4, 4.2, 3.0, 2.6, "Leases (Legal Contracts)",
         ["Id : UUID (PK)", "PropertyId : UUID (FK -> Properties)", "TenantId : UUID (FK -> Users)",
          "StartDate : TIMESTAMPTZ", "EndDate : TIMESTAMPTZ", "MonthlyRent : DECIMAL(18,2)",
          "IsActive : BOOLEAN", "TerminatedAtUtc : TIMESTAMPTZ"]),
        
        (0.6, 0.8, 3.0, 2.8, "TenantApplications (KYC)",
         ["Id : UUID (PK)", "PropertyId : UUID (FK -> Properties)", "ApplicantName : VARCHAR(100)",
          "ApplicantEmail : VARCHAR(150)", "MonthlyIncome : DECIMAL(18,2)", "CreditScore : INT",
          "RiskScore : DECIMAL(5,2)", "IdDocumentUrl : TEXT (Camera KYC)", "Status : INT (IX)"]),
        
        (4.0, 0.8, 3.1, 2.8, "MaintenanceTickets (Work Orders)",
         ["Id : UUID (PK)", "PropertyId : UUID (FK -> Properties)", "TenantId : UUID (FK -> Users)",
          "ContractorId : UUID (FK, Nullable)", "IssueDescription : TEXT", "Priority : INT (Low..Critical)",
          "EstimatedCost : DECIMAL(18,2)", "Latitude/Longitude : DECIMAL (GPS)", "Status : INT (PendingApproval..)"]),
        
        (7.4, 0.8, 3.0, 2.8, "AuditLogs (Governance & Trail)",
         ["Id : UUID (PK)", "EntityName : VARCHAR(100)", "EntityId : VARCHAR(100)",
          "Action : VARCHAR(50)", "PerformedBy : VARCHAR(100)", "TimestampUtc : TIMESTAMPTZ",
          "Details : TEXT (JSON AI Metadata)", "IPAddress : VARCHAR(45)"])
    ]

    for x, y, w, h, title, fields in tables:
        # Outer box
        rect = patches.FancyBboxPatch((x, y), w, h, boxstyle="round,pad=0.05",
                                      facecolor='#FFFFFF', edgecolor='#1E3A8A', linewidth=1.5)
        ax.add_patch(rect)
        # Header bar
        rect_hdr = patches.FancyBboxPatch((x, y + h - 0.45), w, 0.45, boxstyle="round,pad=0.05",
                                          facecolor='#1E3A8A', edgecolor='#1E3A8A', linewidth=1.0)
        ax.add_patch(rect_hdr)
        ax.text(x + w/2, y + h - 0.22, title, ha='center', va='center', fontsize=8.5, fontweight='bold', color='#FFFFFF')
        
        # Fields
        for idx, fld in enumerate(fields):
            fld_y = y + h - 0.65 - (idx * 0.24)
            color = '#1D4ED8' if '(PK' in fld else ('#B45309' if '(FK' in fld else '#334155')
            weight = 'bold' if ('(PK' in fld or '(FK' in fld) else 'normal'
            ax.text(x + 0.12, fld_y, fld, fontsize=7.2, fontweight=weight, color=color)

    # Relationships Connectors
    # Users -> Properties
    ax.annotate("", xy=(4.0, 5.5), xytext=(3.6, 5.5), arrowprops=dict(arrowstyle="->", color="#2563EB", lw=1.5))
    ax.text(3.8, 5.65, "1 : N", fontsize=7, fontweight='bold', color='#2563EB')

    # Properties -> Leases
    ax.annotate("", xy=(7.4, 5.5), xytext=(7.1, 5.5), arrowprops=dict(arrowstyle="->", color="#2563EB", lw=1.5))
    ax.text(7.25, 5.65, "1 : N", fontsize=7, fontweight='bold', color='#2563EB')

    # Properties -> TenantApplications
    ax.annotate("", xy=(2.1, 3.6), xytext=(4.5, 4.2), arrowprops=dict(arrowstyle="->", color="#2563EB", lw=1.5))
    ax.text(3.2, 3.9, "1 : N", fontsize=7, fontweight='bold', color='#2563EB')

    # Properties -> MaintenanceTickets
    ax.annotate("", xy=(5.55, 3.6), xytext=(5.55, 4.2), arrowprops=dict(arrowstyle="->", color="#2563EB", lw=1.5))
    ax.text(5.65, 3.9, "1 : N", fontsize=7, fontweight='bold', color='#2563EB')

    plt.tight_layout()
    plt.savefig("docs/figures/database_erd.png", dpi=300)
    plt.close()
    print("Generated: docs/figures/database_erd.png")

# =============================================================================================
# 3. Human-in-the-Loop Sequence Diagram
# =============================================================================================
def generate_hitl_sequence():
    fig, ax = plt.subplots(figsize=(11, 7), dpi=300)
    ax.set_xlim(0, 11)
    ax.set_ylim(0, 7)
    ax.axis('off')

    ax.text(5.5, 6.7, "Cross-Platform Human-in-the-Loop (HITL) Workflow Sequence",
            ha='center', va='center', fontsize=14, fontweight='bold', color='#0F172A')

    actors = [
        (1.2, "Tenant\n(Flutter)"),
        (3.5, "ASP.NET Core\n(Web API)"),
        (5.8, "Neon DB\n(PostgreSQL)"),
        (8.0, "LangGraph AI\n(FastAPI)"),
        (10.0, "Manager\n(React 19)")
    ]

    # Draw lifelines
    for x, label in actors:
        r = patches.FancyBboxPatch((x - 0.7, 5.8), 1.4, 0.7, boxstyle="round,pad=0.1",
                                   facecolor='#1E293B', edgecolor='#1E293B')
        ax.add_patch(r)
        ax.text(x, 6.15, label, ha='center', va='center', fontsize=8, fontweight='bold', color='#FFFFFF')
        ax.plot([x, x], [0.6, 5.8], color='#CBD5E1', linestyle='--', lw=1.2)

    # Sequence steps (y, x_from, x_to, text, color)
    steps = [
        (5.3, 1.2, 3.5, "1. POST /maintenance/tickets (GPS + Photo)", "#2563EB"),
        (4.8, 3.5, 5.8, "2. INSERT Ticket (Status: Open)", "#059669"),
        (4.3, 3.5, 8.0, "3. Invoke Triage Workflow", "#D97706"),
        (3.8, 8.0, 8.0, "4. Estimate: LKR 65,000 >= 50K Limit (HITL Trigger)", "#DC2626"),
        (3.3, 8.0, 3.5, "5. Return PENDING_APPROVAL State", "#D97706"),
        (2.8, 3.5, 5.8, "6. UPDATE Status: PendingManagerApproval", "#059669"),
        (2.3, 10.0, 3.5, "7. GET /maintenance/pending (React UI)", "#2563EB"),
        (1.7, 10.0, 3.5, "8. POST /maintenance/{id}/assign (Authorize Repair)", "#7C3AED"),
        (1.2, 3.5, 5.8, "9. UPDATE Status: Assigned (Contractor Id Bound)", "#059669"),
        (0.8, 3.5, 1.2, "10. Push Status Update to Mobile Client", "#2563EB")
    ]

    for y, x1, x2, msg, col in steps:
        if x1 == x2: # Self call
            ax.annotate("", xy=(x1 + 0.1, y - 0.15), xytext=(x1, y),
                        arrowprops=dict(arrowstyle="->", color=col, lw=1.5, connectionstyle="arc3,rad=-0.4"))
            ax.text(x1 + 0.2, y - 0.05, msg, fontsize=7.5, fontweight='bold', color=col)
        else:
            ax.annotate("", xy=(x2, y), xytext=(x1, y),
                        arrowprops=dict(arrowstyle="->", color=col, lw=1.5, mutation_scale=12))
            mid_x = (x1 + x2) / 2
            ax.text(mid_x, y + 0.12, msg, ha='center', va='center', fontsize=7.5, fontweight='bold', color=col, backgroundcolor='#FFFFFF')

    plt.tight_layout()
    plt.savefig("docs/figures/hitl_sequence_diagram.png", dpi=300)
    plt.close()
    print("Generated: docs/figures/hitl_sequence_diagram.png")

# =============================================================================================
# 4. LangGraph Multi-Agent StateGraph
# =============================================================================================
def generate_langgraph_stategraph():
    fig, ax = plt.subplots(figsize=(10, 6.5), dpi=300)
    ax.set_xlim(0, 10)
    ax.set_ylim(0, 6.5)
    ax.axis('off')

    ax.text(5.0, 6.1, "LangGraph Agentic AI StateGraph Orchestration & Guardrails",
            ha='center', va='center', fontsize=14, fontweight='bold', color='#0F172A')

    # StateGraph Nodes
    nodes = [
        (1.2, 4.8, 2.2, 0.8, "START NODE\nState Initialization", "#F1F5F9", "#475569"),
        (4.5, 4.8, 2.5, 0.8, "PLANNING AGENT\nDecompose to Sub-tasks", "#EFF6FF", "#2563EB"),
        (7.8, 4.8, 2.0, 0.8, "DELEGATION\nRouting Decision", "#EFF6FF", "#2563EB"),
        (2.0, 2.8, 2.5, 0.8, "RISK SCORING AGENT\nTenant DTI & KYC Audit", "#FEF3C7", "#D97706"),
        (6.0, 2.8, 2.5, 0.8, "MAINTENANCE AGENT\nTriage & Cost Estimation", "#FEF3C7", "#D97706"),
        (4.0, 1.0, 2.8, 0.9, "DETERMINISTIC VALIDATOR\nEnforce LKR 50K Ceiling", "#FEE2E2", "#DC2626"),
        (8.0, 1.0, 1.8, 0.9, "HITL PAUSE\nPending Approval", "#F3E8FF", "#7C3AED")
    ]

    for x, y, w, h, text, bg, border in nodes:
        r = patches.FancyBboxPatch((x - w/2, y - h/2), w, h, boxstyle="round,pad=0.1",
                                   facecolor=bg, edgecolor=border, linewidth=1.5)
        ax.add_patch(r)
        ax.text(x, y, text, ha='center', va='center', fontsize=8, fontweight='bold', color='#0F172A')

    # Connections
    ax.annotate("", xy=(3.25, 4.8), xytext=(2.3, 4.8), arrowprops=dict(arrowstyle="->", lw=1.5, color="#475569"))
    ax.annotate("", xy=(6.8, 4.8), xytext=(5.75, 4.8), arrowprops=dict(arrowstyle="->", lw=1.5, color="#475569"))

    # Branching
    ax.annotate("", xy=(2.0, 3.2), xytext=(7.4, 4.4), arrowprops=dict(arrowstyle="->", lw=1.5, color="#2563EB", connectionstyle="arc3,rad=0.2"))
    ax.text(4.2, 3.9, "Screening Event", fontsize=7.5, color='#2563EB', fontweight='bold')

    ax.annotate("", xy=(6.0, 3.2), xytext=(8.0, 4.4), arrowprops=dict(arrowstyle="->", lw=1.5, color="#2563EB", connectionstyle="arc3,rad=0.2"))
    ax.text(7.4, 3.9, "Maintenance Event", fontsize=7.5, color='#2563EB', fontweight='bold')

    # Converge to Validator
    ax.annotate("", xy=(3.6, 1.45), xytext=(2.0, 2.4), arrowprops=dict(arrowstyle="->", lw=1.5, color="#D97706"))
    ax.annotate("", xy=(4.6, 1.45), xytext=(6.0, 2.4), arrowprops=dict(arrowstyle="->", lw=1.5, color="#D97706"))

    # Validator to HITL or END
    ax.annotate("", xy=(7.1, 1.0), xytext=(5.4, 1.0), arrowprops=dict(arrowstyle="->", lw=2, color="#DC2626"))
    ax.text(6.25, 1.25, "Cost >= 50K", ha='center', va='center', fontsize=7.5, fontweight='bold', color='#DC2626')

    plt.tight_layout()
    plt.savefig("docs/figures/langgraph_stategraph.png", dpi=300)
    plt.close()
    print("Generated: docs/figures/langgraph_stategraph.png")

# =============================================================================================
# 5. Performance Benchmark Latency Chart
# =============================================================================================
def generate_performance_chart():
    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(11, 4.8), dpi=300)

    operations = ['DB Read\n(Properties)', 'DB Write\n(Applications)', 'JWT Auth\n(PBKDF2)', 'REST API\nOverall', 'LangGraph AI\nTriage']
    latencies = [18.4, 34.2, 48.6, 32.1, 142.8]
    colors = ['#10B981', '#3B82F6', '#8B5CF6', '#06B6D4', '#F59E0B']

    bars = ax1.bar(operations, latencies, color=colors, width=0.55, edgecolor='#334155', linewidth=0.8)
    ax1.set_ylabel('Mean Latency (Milliseconds)', fontsize=9, fontweight='bold', color='#0F172A')
    ax1.set_title('Endpoint Response Latency (50 Users)', fontsize=10.5, fontweight='bold', color='#0F172A')
    ax1.set_ylim(0, 170)
    ax1.grid(axis='y', linestyle='--', alpha=0.5)

    for bar, val in zip(bars, latencies):
        ax1.text(bar.get_x() + bar.get_width()/2, bar.get_height() + 3, f"{val} ms",
                 ha='center', va='bottom', fontsize=8, fontweight='bold', color='#1E293B')

    # Right: Success vs Failure Donut
    labels = ['Success (100.0%)', 'Failure (0.0%)']
    sizes = [100.0, 0.0]
    colors_donut = ['#10B981', '#EF4444']
    ax2.pie(sizes, labels=labels, colors=colors_donut, startangle=90,
            wedgeprops=dict(width=0.4, edgecolor='#FFFFFF', linewidth=2),
            textprops=dict(fontsize=9, fontweight='bold', color='#0F172A'))
    ax2.set_title('Request Success Rate (220/220 Executed)', fontsize=10.5, fontweight='bold', color='#0F172A')

    plt.tight_layout()
    plt.savefig("docs/figures/performance_benchmarks.png", dpi=300)
    plt.close()
    print("Generated: docs/figures/performance_benchmarks.png")

# =============================================================================================
# 6. Test Suite Coverage & Pyramid Chart
# =============================================================================================
def generate_testing_pyramid():
    fig, ax = plt.subplots(figsize=(8, 5), dpi=300)
    
    suites = ['Backend xUnit (.NET 10)', 'LangGraph Agent (Pytest)', 'Mobile Tests (Flutter)', 'Frontend Tests (Playwright)']
    counts = [25, 17, 5, 4]
    colors = ['#2563EB', '#D97706', '#0284C7', '#7C3AED']

    bars = ax.barh(suites, counts, color=colors, height=0.5, edgecolor='#1E293B', linewidth=0.8)
    ax.set_xlabel('Automated Test Cases Count (100% Pass Rate)', fontsize=9.5, fontweight='bold', color='#0F172A')
    ax.set_title('Automated Test Suite Distribution across Tiers', fontsize=11, fontweight='bold', color='#0F172A')
    ax.set_xlim(0, 30)
    ax.grid(axis='x', linestyle='--', alpha=0.5)

    for bar, count in zip(bars, counts):
        ax.text(bar.get_width() + 0.6, bar.get_y() + bar.get_height()/2, f"{count} Passed (100%)",
                ha='left', va='center', fontsize=8.5, fontweight='bold', color='#0F172A')

    plt.tight_layout()
    plt.savefig("docs/figures/testing_pyramid.png", dpi=300)
    plt.close()
    print("Generated: docs/figures/testing_pyramid.png")

if __name__ == '__main__':
    generate_system_architecture()
    generate_database_erd()
    generate_hitl_sequence()
    generate_langgraph_stategraph()
    generate_performance_chart()
    generate_testing_pyramid()
    print("All 6 visual diagram assets successfully generated in docs/figures/!")
