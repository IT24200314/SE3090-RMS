# RMS Project Core Memory & Engineering Rules

## 1. Project Identity & Team Allocation
- **Project**: Rental Management System (RMS)
- **Tech Stack**:
  - **Backend**: ASP.NET Core 8 Web API, Entity Framework Core, PostgreSQL
  - **Frontend**: React (Vite / Next.js), Tailwind CSS, Lucide Icons
  - **Mobile**: Flutter & Dart (Material 3, Camera, GPS)
  - **AI / Automation**: LangGraph & Python Agentic Workflow Orchestration
- **Team Allocation**:
  - **E.M.U.I.B. Ekanayake (Leader - IT24200314)**: Property & Lease Module (Component A), Planning Agent
  - **D.G.N.S. Widumini (Member - IT24101176)**: Tenant Screening & Onboarding Module (Component B), Risk Scoring Agent
  - **H.A. Wickramathilaka (Member - IT24100427)**: Maintenance & Operations Module (Component C), Triage/Validation Agent
  - **Group ID**: `SEF_KDY_AI_04` | SLIIT Kandy Uni | Specialization: AI (Batch 1)

---

## 2. Humanized Code Quality & Comments Standard
- Write authentic, human-readable, production-grade code. Avoid generic bot comments (e.g., `// Initialize variable`).
- Write contextual, professional developer comments:
  - Explain *why* a specific business rule exists (e.g., `// Enforce 30% rent-to-income threshold as per property policy`).
  - Add clean XML documentation tags on all C# controllers, DTOs, interfaces, and services.
  - Implement clean error handling with domain-specific exceptions and global exception middleware.

---

## 3. Premium UI/UX Guidelines
- **React Dashboard**:
  - Modern dashboard layout using Tailwind CSS, subtle glassmorphism/card borders, clean badges for status (Approved, Pending, Rejected).
  - Include responsive data tables with debounce search, column sorting, pagination, and skeleton loading states.
- **Flutter Mobile**:
  - Clean Material 3 design, smooth transitions, bottom navigation, custom elevated cards, error/empty state graphics.
  - Integrate native features: Camera (receipts/ID capture) and GPS location tagging.

---

## 4. Strict Agentic AI & Integration Constraints
- **Architecture Flow**: React & Flutter -> ASP.NET Core 8 Web API -> PostgreSQL -> Internal LangGraph AI.
- **Human-in-the-Loop**: Workflows must pause at `PendingManagerApproval` for high-impact actions (e.g. lease signing, eviction notice, high-cost maintenance approval).
- **No Mock Code**: Never output disconnected mock code; always wire models directly to PostgreSQL and EF Core.
