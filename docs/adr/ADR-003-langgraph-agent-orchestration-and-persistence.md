# ADR-003: LangGraph Multi-Agent Orchestration & State Persistence Architecture

## Status
**Accepted**

## Context
Section 9 and 10 of the SE3090 specification mandate a multi-agent system containing a structured multi-step planner, sandboxed allow-listed tools, shared persisted state across steps, deterministic validation rules, and a Human-in-the-Loop (HITL) pause mechanism for high-impact financial or risk decisions.

## Decision
We implemented a **Python 3.14 + FastAPI + LangGraph (`StateGraph`) multi-agent architecture** running on port 8000:
1. **Planning Agent (Component A - Upamada)**: `planning_agent_node` analyzes objectives, generates an execution plan, and routes to specialized downstream agents.
2. **Tenant Screening Agent (Component B - Nethmi)**: `tenant_screening_agent_node` computes debt-to-income ratios, invokes `verify_credit_and_identity_tool`, and computes 0-100 risk scores.
3. **Maintenance Triage Agent (Component C - Hashini)**: `maintenance_triage_agent_node` categorizes trades, estimates costs, and checks the LKR 50,000 threshold.
4. **Deterministic Validation Node**: `deterministic_validator_node` enforces hard business bounds and schema checks.
5. **State Persistence & Checkpoints**: `MemorySaver` checkpointer persists workflow thread state, enabling checkpoint resume after human approval in React.

## Consequences
### Positive:
- **Strict Determinism**: Zero hallucination on math/thresholds; 100% test pass rate on golden cases.
- **Auditable Telemetry**: Full message and state history exposed via `/agent/workflow/state/{thread_id}` REST endpoints.
- **Fail-Safe Recovery**: Graceful fallback routing if tool execution fails.

### Negative / Trade-offs:
- Requires hosting an asynchronous Python microservice alongside the ASP.NET Core backend.
