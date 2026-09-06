# ADR-001: React 19 Client State Management & Micro-UI Architecture

## Status
**Accepted**

## Context
The Rental Management System (RMS) requires a responsive, low-latency, Tier-1 SaaS administrative and staff operations web dashboard. Key operations include listing exploration, active lease contract lifecycle management, KYC document review, Human-in-the-Loop (HITL) financial expenditure authorization, and live Multi-Agent LangGraph telemetry observability.

## Decision
We adopted **React 19 Functional Components with Hooks (`useState`, `useEffect`, `useCallback`, `useContext`)** alongside **Axios with centralized API Interceptors**, **Tailwind CSS v4 with Zinc-950 Design Tokens**, and **Custom Context Providers (`ToastContext`)**. Redux / Zustand was evaluated but rejected due to the localized component boundaries of our 3-member architecture:
1. **Component A (Upamada - Property/Lease)**: Localized filter and debounced search state with optimistic lease status transitions.
2. **Component B (Nethmi - Tenant Screening)**: Tabbed table filtering, document preview modal state, and deterministic risk score badge components.
3. **Component C (Hashini - Maintenance & Dispatch)**: 3-column Kanban dispatch state, live SLA badges, and dedicated HITL approval queue overlay.
4. **Agentic AI Telemetry**: Local timer-driven StateGraph execution step visualizer.

## Consequences
### Positive:
- **Zero Overhead**: Minimal bundle size (~305 kB production JS) with instantaneous (<200ms) Vite compilation.
- **Strict Isolation**: Clear separation of state ownership preventing cross-component race conditions.
- **Fail-Safe Offline Resilience**: Built-in fallback to mock client data when backend is starting or offline.

### Negative / Trade-offs:
- Cross-tab state synchronization requires either Context lifting or explicit HTTP refetching upon tab activation.
