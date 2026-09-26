# 📦 SLIIT SE3090 — Assignment 1: Final Submission Checklist & Guide

**Module**: SE3090 — Software Engineering Frameworks  
**Project**: Rental Management System (RMS) with Multi-Agent Agentic AI Orchestration  
**Group ID**: SE3090_G07 (3-Member Approved Team)  
**Academic Year**: 2026 | Year 3, Semester 1  

---

## 👥 Group Identification & Component Ownership

| Student Name | Student ID | Academic Role | Component Ownership | Key Artifacts |
|---|---|---|---|---|
| **Upamada Ekanayake** | IT24200314 | **Group Leader** | **Component A: Property Listing & Lease Lifecycle** + Planning Agent (`planner.py`) | `PropertiesController`, `LeasesController`, `PropertyList.jsx`, `property_list_screen.dart`, Currency Exchange API |
| **Nethmi Seya** | IT24200314-M2 | **Member** | **Component B: Tenant Screening & Onboarding** + Camera KYC + Risk Scoring Agent (`tenant_agent.py`) | `TenantScreeningController`, `TenantReviewPortal.jsx`, `tenant_application_screen.dart` (Native Camera KYC), Debt-to-Income Engine |
| **Hashini Wicramathilake** | IT24200314-M3 | **Member** | **Component C: Maintenance & Operations** + GPS Tagging + Triage Agent (`maintenance_agent.py`) & Validator (`validator.py`) | `MaintenanceController`, `MaintenanceBoard.jsx`, `create_ticket_screen.dart` (Device GPS), Nominatim Geocoding SLA, LKR 50K HITL Ceiling |

---

## 📑 1. Final Submission Deliverables Required

For SLIIT SE3090 Assignment 1, you need to submit the following items on Moodle / Courseweb:

1. **📄 Consolidated Technical Report (PDF)**:
   - Export [`docs/SE3090_CONSOLIDATED_REPORT.md`](file:///c:/Users/AI%20WORKPLACE/Documents/RENTAL%20MANEGEMENT%20SYSTEM/docs/SE3090_CONSOLIDATED_REPORT.md) as a PDF (e.g., `SE3090_Assignment1_Report_G07.pdf`).
   - Contains:
     - **Part I**: Group Technical Report (System Architecture, Sequence Diagrams, REST Catalog, Automated Testing Evidence).
     - **Part II**: Individual Contributions, AI Usage Logs, and Personal Reflections for all 3 members (Upamada, Nethmi, Hashini).
     - **Part III**: Viva Readiness Questions and Answers.
2. **🔗 Repository Link Document (PDF / TXT)**:
   - Public GitHub Repository URL: `https://github.com/IT24200314/SE3090-RMS`
   - Active Git Branches:
     - `main`: Production release
     - `develop`: Integrated staging
     - `feature/prop-lease-upamada`: Upamada's Component A PR
     - `feature/tenant-screening-nethmi`: Nethmi's Component B PR
     - `feature/maintenance-hashini`: Hashini's Component C PR
3. **🎥 Video Demonstration Link (YouTube / Google Drive)**:
   - A 5-7 minute screen recording demonstrating:
     - Mobile phone app live submission (Camera KYC photo capture).
     - React Web Dashboard real-time update and HITL approval.
     - ASP.NET Core API logs showing HTTP 201 responses.
     - Automated test run (`dotnet test` 11/11 pass, `pytest` 8/8 pass).
4. **🗜️ Source Code Archive (.ZIP)**:
   - Clean source code zip (excluding heavy build directories like `bin`, `obj`, `node_modules`, `.venv`, and `build`).

---

## 🛠️ 2. How to Generate Clean Submission ZIP (PowerShell Command)

To avoid uploading hundreds of megabytes of temporary build files (`node_modules`, `.venv`, `bin`, `obj`, `build`), run this script in PowerShell to produce a clean, lightweight zip ready for Moodle submission:

```powershell
# Navigate to project root
cd "c:\Users\AI WORKPLACE\Documents\RENTAL MANEGEMENT SYSTEM"

# Create a clean archive using git archive (guarantees only tracked, clean source files are included)
git archive --format=zip --output="SE3090_Assignment1_SourceCode_G07.zip" HEAD
```

*Note: `git archive` produces a clean ~5MB to ~15MB zip containing all source code, tests, documentation, and assets without any bloat.*

---

## 📋 3. Step-by-Step Viva Presentation Order (3-Minute Live Demo)

During the Viva evaluation, follow this structured demo order to impress the examiners:

### Step 1: Upamada Ekanayake (Architecture & Component A)
1. **Show the System Architecture**:
   - Explain Clean Architecture in .NET 8 (Core, Infrastructure, API, Tests).
   - Point out that React and Flutter talk **only** to ASP.NET Core, and the Python LangGraph AI microservice is strictly an **internal service**.
2. **Demo Property Listing & Currency Conversion (Section 11)**:
   - Open React Dashboard (`http://127.0.0.1:3000/properties`).
   - Show properties in LKR and dynamic converted rates in USD/EUR via Open Exchange Rates API.
   - Run `dotnet test` showing 11 passed tests including `ThirdPartyIntegrationServiceTests`.

### Step 2: Nethmi Seya (Component B & Native Mobile Camera KYC)
1. **Demo Physical Phone KYC Capture**:
   - Hold up your physical Android phone (or display screen via screencap).
   - Tap **[Apply (KYC)]** on Oceanfront Luxury Suite.
   - Tap **[Capture Document]** $\rightarrow$ show that the **real hardware camera sensor** opens, snaps photo, and verifies edge alignment.
2. **Demo AI Risk Scoring & React Review Portal**:
   - Submit the application with LKR 450,000 declared income.
   - Show the instant Risk Score (0-100) calculated by the AI engine.
   - Switch to the React Web Dashboard (`http://127.0.0.1:3000/screening`) to show the applicant card and demonstrate the **Human-in-the-Loop (HITL)** Approve/Reject buttons.

### Step 3: Hashini Wicramathilake (Component C & Native GPS Geotagging)
1. **Demo Maintenance Logging with GPS Hardware**:
   - In Mobile App, go to Maintenance tab $\rightarrow$ Tap `Log Issue`.
   - Show GPS Geolocation coordinates captured from device hardware.
   - Show reverse geocoding to address via OpenStreetMap Nominatim with SLA fallback.
2. **Demo LKR 50,000 High-Cost Policy Ceiling**:
   - Submit a burst pipe repair estimated at LKR 65,000.
   - Show that the LangGraph deterministic validator automatically pauses the ticket at `PENDING_APPROVAL`.
   - On the React Web Dashboard (`http://127.0.0.1:3000/maintenance`), show the **High-Cost Approval Card** and click `Authorize Repair`.

---

## 🔍 4. Verification Check Before Final Submission

- [x] Backend & Database xUnit Tests: **25 Passed (100%)** (`dotnet test backend/RMS.Backend.sln`)
- [x] Agentic AI Benchmark & Security Tests: **17 Passed (100%)** (`pytest ai-agent/tests`)
- [x] Golden Case Evaluation Report: **5/5 Golden Cases Passed** (`docs/AGENT_EVALUATION_REPORT.md`)
- [x] Performance & Concurrency Benchmark: **50 Concurrent Connections, 100% Success** (`docs/PERFORMANCE_TEST_REPORT.md`)
- [x] Frontend Build & Playwright Tests: **0 errors** (`npm --prefix frontend run build` & E2E flows)
- [x] Mobile Tests & Native Hardware: Camera KYC & GPS models, form validations & unit tests (`mobile/test`)
- [x] Section 10 & 12 End-to-End Workflow: Verified Cross-Platform Mobile $\rightarrow$ Web via AI Approval test
- [x] Section 11 Compliance: Currency Exchange & Nominatim Reverse Geocoding with SLA & Fallback
- [x] All developer comments preserved in code
- [x] Technical Report & AI Usage Logs complete in `docs/SE3090_CONSOLIDATED_REPORT.md`
- [x] Full Viva & Sinhala/English guide available in `docs/MASTER_PROJECT_TUTORIAL_SINHALA_ENGLISH.md`
