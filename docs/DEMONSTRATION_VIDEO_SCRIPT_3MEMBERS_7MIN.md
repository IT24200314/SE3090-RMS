# SE3090 — Integrated Full-Stack & Agentic AI Application Development
## Official 3-Member Video Demonstration Script & Screen-Action Guide
### Rental Management System (RMS) | Group: `SEF_KDY_AI_04` (SLIIT Kandy Uni)

> **Target Spoken Duration**: ~7 minutes (~750 spoken words).  
> **Actual Screen Duration (with clicks, typing, and transitions)**: **9 to 10 Minutes**.  
> **Rule of Thumb**: Speak calmly, clearly, and let the screen action finish before jumping to the next sentence.

---

## 👥 Speaker Allocation & Responsibilities

| Speaker | Member Name | Student ID | Academic Component & Presentation Scope |
| :--- | :--- | :--- | :--- |
| **Speaker 1 (Leader)** | **Upamada Ekanayake** | `IT24200314` | **Intro & Architecture**, **Component A** (Properties, Multi-Currency, Leases), **Planning Agent**, & **Summary** |
| **Speaker 2** | **Nethmi Seya (Widumini)** | `IT24101176` | **Component B** (Tenant Screening & Onboarding, **Camera KYC**, **Risk Scoring Agent**) |
| **Speaker 3** | **Hashini Wickramathilaka** | `IT24100427` | **Component C** (Maintenance, **GPS Tagging**, **Triage Agent**, **LKR 50K HITL Pause & Approval**, Tests/CI) |

---

# 🎬 Scene-by-Scene Step Guide

---

### ⏱️ SCENE 1: Project Overview, Architecture & Swagger API
- **Speaker**: **Speaker 1 — Upamada Ekanayake (Leader)**
- **Planned Talk Time**: 0:00 – 1:15 (~115 words)
- **Primary Screen**: Title Slide / Slide Deck & Live Swagger UI (`/swagger`)

#### 🖥️ WHAT TO DO ON SCREEN (Action):
1. **[0:00 - 0:25]**: Display the Title Slide / Architecture Diagram showing:
   - *Project*: Rental Management System (RMS)
   - *Group*: `SEF_KDY_AI_04` | Specialization: Artificial Intelligence
   - *Members*: E.M.U.I.B. Ekanayake, D.G.N.S. Widumini, H.A. Wickramathilaka.
   - Point your mouse cursor over the 4-tier diagram: **React 19** + **Flutter Mobile** $\to$ **ASP.NET Core 8 Web API** $\to$ **PostgreSQL 16 (Neon)** $\to$ **Internal LangGraph AI**.
2. **[0:25 - 1:15]**: Switch browser tab to the deployed backend Swagger UI:  
   `https://rms-backend-api-yons.onrender.com/swagger/index.html`  
   - Quickly scroll down to highlight the structured controllers: `/api/auth`, `/api/properties`, `/api/leases`, `/api/tenantscreening`, `/api/maintenance`, `/api/aiworkflow`, and `/api/external`.
   - Expand the `GET /health` endpoint, click **Try it out** $\to$ **Execute**, showing `{"status":"Healthy"}` with 200 OK.

#### 🎙️ WHAT TO SAY (Spoken Words):
> **[Upamada]**:  
> "Good day evaluators. Welcome to the demonstration of our Rental Management System, developed for SE3090 Software Engineering Frameworks by group SEF_KDY_AI_04 from SLIIT Kandy Campus. I am Upamada Ekanayake, the group leader.
> 
> Our system addresses urban rental challenges in Sri Lanka through a production-grade full-stack architecture. As shown in our reference architecture, our React 19 web portal and Flutter mobile app communicate exclusively with a single ASP.NET Core 8 RESTful backend. 
> 
> Our backend enforces JWT authentication, role-based authorization, and connects to PostgreSQL on Neon Cloud via Entity Framework Core. Furthermore, all agentic AI capabilities operate strictly as an internal Python LangGraph microservice. Here on our live deployed Swagger UI, you can see our secure endpoints and our healthy cloud status probe."

---

### ⏱️ SCENE 2: Component A — Property Catalog, Currency Conversion & Lease Lifecycle
- **Speaker**: **Speaker 1 — Upamada Ekanayake**
- **Planned Talk Time**: 1:15 – 2:45 (~140 words)
- **Primary Screen**: React Web Admin Portal (`/properties`)

#### 🖥️ WHAT TO DO ON SCREEN (Action):
1. **[1:15 - 1:40]**: Navigate to the deployed React Admin Portal: `https://rms-frontend-jet-rho.vercel.app/`
   - Log in as Manager: `manager@rms.lk` (Password: `Password123!`).
   - Navigate to the **Properties** catalog.
   - Type in the search box: *"Colombo"* or *"Lotus"* to show live instant debounced filtering.
   - Click the status filter button to switch between **All**, **Available**, and **Occupied**.
2. **[1:40 - 2:10]**: On a property card (e.g. *Colombo Luxury Penthouse*):
   - Click the **Currency Converter** dropdown (Third-Party Integration via Backend Gateway).
   - Switch from **LKR** to **USD** and **EUR** — show that the rent automatically recalculates via the backend exchange service.
3. **[2:10 - 2:45]**: Click **"Create Lease"** on an available property.
   - Select a tenant (`tenant@rms.lk`), select a 1-year duration, and view the auto-calculated security deposit.
   - Click **"Sign & Finalize Lease"**.
   - Show that the property status badge instantly changes from green `Available` to purple `Occupied`.

#### 🎙️ WHAT TO SAY (Spoken Words):
> **[Upamada]**:  
> "I took ownership of Component A: Property Listing and Lease Lifecycle Management. 
> 
> On our React 19 dashboard, property managers can filter properties by availability, price range, and location with responsive debounced search. 
> 
> To fulfill Section 11's third-party integration requirement, we integrated a real-time currency exchange gateway routed securely through our ASP.NET Core backend. This allows international expats and diaspora tenants to view monthly rents converted from Sri Lankan Rupees to US Dollars or Euros. 
> 
> Next, I will demonstrate a complete lease creation. When I create a lease for this property and submit the contract, our backend executes a transactional database update. Notice how the property status immediately transitions from 'Available' to 'Occupied', preventing any double-leasing conflicts.
> 
> Now, I hand over to Nethmi Seya to demonstrate Component B."

---

### ⏱️ SCENE 3: Component B — Tenant Onboarding, Mobile Camera KYC & Risk Scoring Agent
- **Speaker**: **Speaker 2 — Nethmi Seya (Widumini)**
- **Planned Talk Time**: 2:45 – 4:30 (~165 words)
- **Primary Screen**: Flutter Mobile App (Camera KYC) $\to$ React Admin Portal (Review)

#### 🖥️ WHAT TO DO ON SCREEN (Action):
1. **[2:45 - 3:30]**: Switch to the **Flutter Mobile Application** (running on phone or Android emulator).
   - Log in as Tenant: `tenant@rms.lk` / `Password123!`.
   - Tap on **"Apply for Rental"** / **"Tenant KYC Onboarding"**.
   - Fill in Monthly Income: `180,000 LKR` and Employment: `Senior Software Engineer`.
   - Tap the **Camera / Upload NIC** button (demonstrating the native hardware device feature).
   - Capture/select the photo of the National Identity Card.
   - Tap **"Submit Application"** — view the success confirmation.
2. **[3:30 - 4:30]**: Switch screen back to the **React Admin Portal**:
   - Navigate to the **"Tenant Screening & Applications"** page.
   - Show the newly submitted application in the table.
   - Point out the **Risk Score Badge**:
     - *Income-to-Rent Ratio*: Computed deterministically (~25% $\to$ Low Risk).
     - *Credit Score Weight*: > 700.
     - *Status Badge*: Displays green `Low Risk` pill badge.
   - Click **"View ID Verification"** to show the uploaded NIC document preview.
   - Click **"Approve Tenant"**.

#### 🎙️ WHAT TO SAY (Spoken Words):
> **[Nethmi]**:  
> "Thank you, Upamada. I am Nethmi Seya, and I am responsible for Component B: Tenant Screening, Application Onboarding, and Risk Evaluation.
> 
> Prospective tenants apply directly through our Flutter mobile app. Here, you see our native hardware integration: the Camera KYC document scanner. Applicants capture a live photo of their National Identity Card or Passport alongside their verified monthly income and employment credentials.
> 
> When submitted, our ASP.NET Core API triggers our internal LangGraph Tenant Risk Agent. The agent applies deterministic financial rules: it calculates the rent-to-income ratio against our strict 35% safe threshold and evaluates credit history without LLM hallucination.
> 
> Back on the React Admin portal, the property manager sees the incoming application with an auditable risk score, KYC document verification preview, and recommended deposit. With a single click, the manager can approve the verified tenant.
> 
> I now invite Hashini to demonstrate Component C and our Human-in-the-Loop workflow."

---

### ⏱️ SCENE 4: Component C — Maintenance Request & Mobile GPS Geotagging
- **Speaker**: **Speaker 3 — Hashini Wickramathilaka**
- **Planned Talk Time**: 4:30 – 5:45 (~125 words)
- **Primary Screen**: Flutter Mobile App (Emergency Maintenance + GPS)

#### 🖥️ WHAT TO DO ON SCREEN (Action):
1. **[4:30 - 5:15]**: In the **Flutter Mobile App**:
   - From the bottom navigation bar, tap **"Maintenance"** $\to$ **"Report Defect"**.
   - Select Issue Category: **"Plumbing / Water Damage"**.
   - Description: *"Severe burst main pipe in bathroom causing flooding. Water heater cracked."*
   - Tap **"Capture Current GPS Location"** button:
     - Show the location coordinates resolving (e.g. `Lat: 6.9271, Lon: 79.8612` - Colombo).
     - Point out how this native device feature verifies the tenant is physically at the registered rental unit.
2. **[5:15 - 5:45]**: Attach a defect photo and tap **"Submit Emergency Ticket"**.
   - Show the ticket state set to `Submitted - Awaiting AI Triage`.

#### 🎙️ WHAT TO SAY (Spoken Words):
> **[Hashini]**:  
> "Thank you, Nethmi. I am Hashini Wickramathilaka, owner of Component C: Maintenance Operations, Contractor Dispatch, and Financial Guardrails.
> 
> In urban rental properties, emergency repairs require fast verification. In our Flutter mobile application, tenants report maintenance issues using native GPS Geolocation tagging. By fetching the device's live coordinates, our system verifies that the repair request originates from the actual registered property address.
> 
> As you can see, I am submitting a high-severity plumbing defect: a burst main water pipe. Once submitted, our backend dispatches the ticket to our multi-agent AI subsystem for automated triage, trade classification, and cost estimation."

---

### ⏱️ SCENE 5: The Assessed Agentic AI Workflow & LKR 50K Human-in-the-Loop Guardrail
- **Speaker**: **Speaker 3 — Hashini Wickramathilaka** (Co-narrated with **Upamada**)
- **Planned Talk Time**: 5:45 – 7:15 (~140 words)
- **Primary Screen**: React Web Dashboard (`/maintenance` + Live AI Telemetry Drawer)

#### 🖥️ WHAT TO DO ON SCREEN (Action):
1. **[5:45 - 6:25]**: On the **React Admin Portal**:
   - Navigate to the **Maintenance Board**.
   - Open the **AI Telemetry / Agent Execution Trace** drawer:
     - Show the step-by-step LangGraph StateGraph trace:
       - Node 1: `Planning Agent` creates multi-step plan.
       - Node 2: `Maintenance Triage Agent` calls allow-listed tool `estimate_repair_cost` $\to$ Returns **LKR 75,000.00**.
       - Node 3: `Deterministic Validator Node` checks safety threshold: LKR 75,000 exceeds the **LKR 50,000 policy ceiling**!
       - Node 4: Workflow status pauses at `PENDING_APPROVAL` with reason: *"Repair estimate exceeds LKR 50,000 financial threshold."*
2. **[6:25 - 7:15]**: Close the drawer and look at the **High-Cost Maintenance Approval Card**:
   - Point out the red warning card highlighting the LKR 75,000 estimate.
   - As Manager, select licensed contractor from dropdown: *"QuickFix Plumbing Services (Certified)"*.
   - Click **"Authorize & Dispatch Contractor"**.
   - Show the ticket status immediately update to `Dispatched`.
   - Switch to Flutter mobile app to show the tenant's ticket status has automatically refreshed to `Dispatched`!

#### 🎙️ WHAT TO SAY (Spoken Words):
> **[Hashini]**:  
> "This brings us to our core Agentic AI workflow and Section 9 compliance. Our LangGraph state graph executed three distinct nodes: the Planner, the Maintenance Triage Agent, and our Deterministic Validator.
> 
> The AI estimated this repair at 75,000 Sri Lankan Rupees. However, under our strict governance policy, autonomous agents cannot approve expenditures exceeding LKR 50,000. Our deterministic validator intervened, halting the graph at 'PendingManagerApproval'.
> 
> Now, on the React dashboard, you can see our Human-in-the-Loop review card. The property manager inspects the AI estimate, selects a licensed plumber, and formally authorizes the repair. Once authorized, the state updates in PostgreSQL, and the tenant's mobile client immediately reflects the dispatched contractor."

---

### ⏱️ SCENE 6: Automated Testing, PostgreSQL Cloud Verification, CI/CD & Conclusion
- **Speaker**: **Speaker 1 — Upamada Ekanayake** (with group presence)
- **Planned Talk Time**: 7:15 – 8:30 (~110 words)
- **Primary Screen**: VS Code Terminal (Tests) $\to$ GitHub Actions CI page

#### 🖥️ WHAT TO DO ON SCREEN (Action):
1. **[7:15 - 7:45]**: Open Terminal / VS Code:
   - Run backend tests:
     ```powershell
     dotnet test backend/RMS.Backend.sln
     ```
     - Show: **Passed! - 11 Passed, 0 Failed**.
   - Run AI Pytest suite:
     ```powershell
     pytest ai-agent/tests -v
     ```
     - Show: **8 passed in 0.42s (100% pass rate)**.
2. **[7:45 - 8:15]**: Switch to browser tab showing **GitHub Actions CI/CD**:
   - Show the latest green build workflow on `main` branch with 3 passing jobs:
     - `Backend Build & xUnit Tests` ✅
     - `LangGraph Agent Pytest Suite` ✅
     - `React 19 Frontend Build & Lint` ✅
3. **[8:15 - 8:30]**: Switch to the Closing slide / team webcam:
   - All 3 members present and smiling.

#### 🎙️ WHAT TO SAY (Spoken Words):
> **[Upamada]**:  
> "To guarantee code quality and regression safety, our test suite includes 11 xUnit tests covering backend services, concurrency, and transactions, alongside 8 automated Pytests validating prompt injection defense and our LKR 50,000 guardrail. 
> 
> Every commit is validated by our automated GitHub Actions CI pipeline, building our .NET backend, executing AI tests, and verifying our React production bundle.
> 
> In summary, our team has delivered a fully integrated, production-deployed system uniting ASP.NET Core, PostgreSQL, React, Flutter, and governed Agentic AI. 
> 
> Thank you for your time, and we look forward to the viva examination."

---

## ⏱️ Quick Summary Timing Table

| Segment | Speaker | What is Demonstrated | Spoken Words | Target Talk Time | Total Screen Time |
| :---: | :--- | :--- | :---: | :---: | :---: |
| **Scene 1** | **Upamada (Leader)** | Architecture, Tech Stack, Live Cloud Swagger & Health | ~115 words | 1:15 min | 1:30 min |
| **Scene 2** | **Upamada** | Properties Catalog, Currency Conversion, Lease Creation | ~140 words | 1:30 min | 1:45 min |
| **Scene 3** | **Nethmi** | Flutter Camera KYC, Risk Scoring Agent, React Approval | ~165 words | 1:45 min | 2:00 min |
| **Scene 4** | **Hashini** | Flutter Emergency Ticket, Native GPS Geotagging | ~125 words | 1:15 min | 1:30 min |
| **Scene 5** | **Hashini + Upamada** | LangGraph StateGraph, LKR 50K HITL Pause & Manager Signoff | ~140 words | 1:30 min | 1:45 min |
| **Scene 6** | **Upamada** | xUnit Tests, AI Pytest, GitHub Actions CI Pipeline, Closing | ~110 words | 1:00 min | 1:15 min |
| **TOTAL** | **All 3 Members** | **Full SE3090 Integrated Demonstration** | **~795 words** | **~8:15 min** | **9:45 min** |

---

## 💡 Practical Recording Tips for the Team

1. **Keep Windows Arranged in Advance**:
   - **Tab 1**: Live React Portal (`https://rms-frontend-jet-rho.vercel.app`)
   - **Tab 2**: Live Swagger UI (`https://rms-backend-api-yons.onrender.com/swagger`)
   - **Tab 3**: GitHub Actions CI page
   - **Window 2**: Flutter Mobile App running on Android Emulator or mirrored physical device (scrcpy)
   - **Window 3**: Terminal / VS Code ready to run `dotnet test`
2. **Smooth Hand-Offs**:
   - Notice the handover cues: *"Now, I hand over to Nethmi Seya..."* and *"I now invite Hashini..."*. These make the recording feel like a professional, cohesive team presentation.
3. **No Dead Silence**:
   - While clicking or waiting for a form submission, keep speaking or describing what the system is processing in the background (e.g., *"Our backend is now verifying the decimal rent amount and writing to PostgreSQL..."*).
