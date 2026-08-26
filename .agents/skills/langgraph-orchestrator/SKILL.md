---
name: langgraph-orchestrator
description: LangGraph & Agent Orchestration for Python, StateGraph definitions, multi-step planners, tool calling, deterministic validation rules, and human-in-the-loop pause nodes.
---

# LangGraph & Agent Orchestration Skill

## Core Principles
1. **State & Graph Topology**:
   - Define strict Pydantic/TypedDict state definitions for all agent nodes.
   - Use deterministic conditional edges for validation and routing.

2. **Specialized RMS Agents**:
   - **Planning Agent (Upamada)**: Property listing analysis, lease generation schedule, renewal planner.
   - **Risk Scoring Agent (Nethmi)**: Tenant background verification, credit score parsing, debt-to-income analysis.
   - **Triage & Validation Agent (Hashini)**: Maintenance ticket classification, contractor quote assessment, urgency escalation.

3. **Human-in-the-Loop (HITL) Checkpoints**:
   - Interrupt/pause graph execution at `PendingManagerApproval` before executing high-risk operations (e.g. lease signing, contractor payments, eviction warnings).
   - Require human feedback/resumption payload.

4. **Integration with .NET Backend**:
   - Communicate with ASP.NET Core 8 Web API via authenticated REST webhooks or message queues.
   - Persist state checkpoints in PostgreSQL or Redis.
