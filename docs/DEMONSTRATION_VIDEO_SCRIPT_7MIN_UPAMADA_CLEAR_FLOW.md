# RMS — Upamada Ekanayakeගේ මිනිත්තු 7ක පැහැදිලි demonstration script

**Group:** Group Four, SLIIT Kandy Uni  
**Specialization:** Artificial Intelligence  
**Presenter:** Upamada Ekanayake — IT24200314  
**Topic:** Rental Management System (RMS)  
**Total duration:** 07:00  
**Language:** කියන කොටස English; screen actions සිංහල උපදෙස් ලෙස දී ඇත.

## Video එකේ එකම story එක

මෙම recording එකේ flow එක මෙහෙම තියාගන්න:

Architecture → API/database health → real API request/response → Manager web portal → Upamada's property/lease website → mobile client → Nethmi's tenant screening website → Hashini's maintenance website → all three members' AI contributions → tests and conclusion

**Recording continuation:** 00:00–04:25 දක්වා දැනට record කළ video එක තියාගන්න. Upamadaගේ Properties & Leases website component එක 02:45–03:35දී පෙන්වා තිබෙනවා. Flutter පස්සේ 04:25දී Nethmiගේ Tenant Screening website component එකත්, ඊළඟට Hashiniගේ Maintenance website component එකත් පෙන්වන්න. ඉන්පසු agents තුන explain කරන්න. සියලු narration Upamada විසින් කියන්න; අනෙක් membersගේ contributions නමින් credit කරන්න. පහත timings editing targets වේ; අවසන් video duration එක narration සහ actual recordings අනුව verify කරන්න.

Folders අතර අදාළ නැති විදිහට යන්න එපා. Source code එක කෙටියෙන් පෙන්වන්නේ ඒ screen එකේ පෙන්වන feature එකට සම්බන්ධ file එකක් පමණයි.

## Recording කිරීමට කලින් open කරලා තියාගන්න

### Browser tabs

1. Architecture slide: docs/scene1_title_slide.html හෝ නිවැරදි .NET 10 label සහිත slide එක.
2. Health: https://rms-backend-api-yons.onrender.com/health
3. Swagger: https://rms-backend-api-yons.onrender.com/swagger/index.html
4. React manager portal: https://rms-frontend-jet-rho.vercel.app/
5. GitHub Actions: https://github.com/IT24200314/SE3090-RMS/actions

Browser tabs කලින් open කරලා services warm කරගන්න. .env, database password, JWT token සහ connection string screen එකේ පෙන්වන්න එපා.

### VS Code tabs

| File | පෙන්වන්නේ |
|---|---|
| backend/RMS.API/RMS.API.csproj | Current backend target .NET 10 |
| backend/RMS.Infrastructure/Data/AppDbContext.cs | PostgreSQL DbSets සහ relationship mapping |
| frontend/src/components/properties/PropertyList.jsx | React property list/filter UI |
| frontend/src/components/properties/LeaseModal.jsx | Lease form සහ Generate Legal Contract button |
| frontend/src/components/tenants/TenantReviewPortal.jsx | Nethmiගේ tenant application review website |
| frontend/src/components/tenants/IdentityVerificationModal.jsx | Demo document inspection UI |
| frontend/src/components/maintenance/MaintenanceBoard.jsx | Maintenance board, triage සහ approval UI |
| backend/RMS.Infrastructure/Services/MaintenanceService.cs | Persisted ticket triage සහ business rules |
| ai-agent/agents/planner.py | Upamadaගේ Planning Agent |
| ai-agent/agents/tenant_agent.py | Nethmiගේ Tenant Risk Scoring Agent |
| ai-agent/agents/maintenance_agent.py | Hashiniගේ Maintenance Triage Agent |
| ai-agent/workflow.py | Planner, domain agent සහ validator graph |
| ai-agent/tools/allowlisted_tools.py | Financial ratio, repair estimate සහ contractor lookup tools |
| ai-agent/agents/validator.py | LKR 50,000 approval threshold |
| .github/workflows/ci.yml | CI build and test commands |

### Demo accounts and safe data

- Manager: manager@rms.lk / Password123!
- Tenant: tenant@rms.lk / Password123!
- Use disposable demo properties and a DEMO ONLY document/photo. Do not record a real NIC.
- Before recording, verify that deployed labels and local source are the same.

## Exact 7-minute timing

| Time | Duration | Screen | Purpose |
|---|---:|---|---|
| 00:00–00:40 | 40 s | Architecture | Explain project and layers |
| 00:40–01:05 | 25 s | Health | Show API and PostgreSQL health |
| 01:05–01:55 | 50 s | Swagger | Show a real request and response |
| 01:55–02:45 | 50 s | React login | Login as manager and explain role |
| 02:45–03:35 | 50 s | React properties | Search, filter and lease entry |
| 03:35–04:25 | 50 s | Flutter | Show tenant/mobile workflow |
| 04:25–04:50 | 25 s | Nethmi's React tenant screening | Applications, income/rent and document inspection |
| 04:50–05:20 | 30 s | Hashini's React maintenance | Work orders, triage and financial review |
| 05:20–05:40 | 20 s | Planning Agent | Upamada: plan and conditional routing |
| 05:40–06:05 | 25 s | Tenant Risk Agent | Nethmi: financial assessment and score |
| 06:05–06:35 | 30 s | Maintenance Agent + Validator | Hashini: estimate, contractor recommendation and guardrail |
| 06:35–06:50 | 15 s | Tests/CI | Show actual test and CI evidence |
| 06:50–07:00 | 10 s | Closing | Credit all members and finish |
| **Total** | **420 s** | | |

## Full script and screen actions

### 00:00–00:40 — Project and architecture / Upamada

**Open:** Architecture slide.

**කරන්න:** Project title, Group Four, SLIIT Kandy Uni, Artificial Intelligence specialization, presenter name සහ membersගේ contribution credits පෙන්වන්න. Diagram එකේ React + Flutter → ASP.NET Core / .NET 10 → PostgreSQL සහ Python FastAPI + LangGraph arrows පෙන්වන්න.

**Say:**

> Good day, everyone. We are Group Four from SLIIT Kandy Uni, specializing in Artificial Intelligence. Our project topic is the Rental Management System, developed for SE3090. I am Upamada Ekanayake, and today I am going to present our project. This system manages rental properties, leases, tenant applications, maintenance requests, and governed Agentic AI decisions. At the top layer we have a React manager portal and a Flutter mobile application. Both clients communicate with our ASP.NET Core Web API, which uses PostgreSQL for persistent data and connects to our internal Python LangGraph service for agentic workflows.

### 00:40–01:05 — Deployed API and database health / Upamada

**Open:** https://rms-backend-api-yons.onrender.com/health

**කරන්න:** Refresh කරන්න. status Healthy, database PostgreSQL (Neon Cloud Connected), timestamp, service සහ version fields පෙන්වන්න.

**Say:**

> The deployed health endpoint confirms that the ASP.NET Core API is running and that the PostgreSQL database connection is available. This is the first operational check before we use the application. The response also gives the service and version information, so the following screens are connected to the deployed system rather than only a local mock interface.

### 01:05–01:55 — Swagger request and response / Upamada

**Open:** Swagger UI.

**කරන්න:**

1. Properties section එක expand කරන්න.
2. GET /api/Properties open කරන්න.
3. Try it out → Execute click කරන්න.
4. HTTP 200 සහ property array එකේ ID, title, monthly rent සහ status පෙන්වන්න.
5. Leases, Tenants, Maintenance, External සහ AI sections කෙටියෙන් scroll කරන්න.

**Say:**

> Swagger shows the contracts exposed by our backend. I am now executing a read request for the property catalog. The API returns HTTP 200 and structured property data, including the identifier, title, rent, and availability status. This request is served by ASP.NET Core and reads the persisted application data. The other sections expose lease, tenant, maintenance, third-party, and AI operations. I use a read request first so that the API contract is visible without changing the database.

**Optional:** POST /api/external/currency/convert එකේ amountLkr 45000 සහ targetCurrency USD දමා actual response එක පෙන්වන්න. Exact returned amount එක screen එකෙන් කියන්න.

### 01:55–02:45 — Manager login and dashboard / Upamada

**Open:** React portal.

**කරන්න:**

1. manager@rms.lk සහ demo password එක fill කරන්න.
2. Sign In to RMS Portal click කරන්න.
3. Dashboard load වෙනකම් ඉන්න.
4. Manager role indicator පෙන්වන්න.
5. Properties & Leases, Tenant Screening & KYC, Maintenance & Dispatch සහ Agentic AI Telemetry sections පෙන්වන්න.

**Say:**

> I will now move to the React manager portal and sign in with the manager role. After authentication, the dashboard provides access to property and lease management, tenant screening, maintenance dispatch, and Agentic AI telemetry. The role indicator confirms the current user context. I will now use the property module to demonstrate a business operation rather than only showing navigation.

**Note:** actual 401/403 response එක rehearsal එකේ ලැබෙනවා නම් පමණක් wrong-role authorization test එක පෙන්වන්න. Response එක 200 නම් protected operation එක blocked කියලා කියන්න එපා.

### 02:45–03:35 — Properties, filters and lease operation / Upamada

**Open:** React sidebar → Properties & Leases.

**කරන්න:** Property cards පෙන්වන්න. Search field එකේ Colombo හෝ Lotus type කරන්න. Available filter එක click කරන්න. Disposable available property එකක Draft Lease Agreement click කරන්න. Actual tenant GUID, dates සහ rent check කර Next Step → Generate Legal Contract click කරන්න. Property status සහ lease response පෙන්වන්න.

**Say:**

> This is Component A, the property and lease module. The manager can search the property catalog and filter units by availability. I am now opening a disposable demo property and entering the actual tenant identifier and valid lease dates. The lease action applies the business rule that the property must be available. In the current implementation, generating the legal contract creates a pending-signature lease and changes the property status to occupied. The saved result should be verified with a refresh or a read-only database or API response.

### 03:35–04:25 — Flutter mobile client / Upamada

**Open:** Android RMS app with the tenant account.

**කරන්න:** Tenant role සහ dashboard පෙන්වන්න. Available property එකක Apply (KYC) screen එක open කර income 180000 දමන්න. DEMO ONLY card එක native camera එකෙන් capture කර preview එක පෙන්වන්න. Maintenance screen එක open කර GPS card එක පෙන්වන්න. GPS fix එක actual නම් coordinates පෙන්වන්න; fallback නම් fallback කියලා කියන්න.

**Say:**

> The same system also has a Flutter mobile client for tenants. Here the tenant can apply to a property, enter financial information, and capture a demonstration document through the native camera. A photograph is document collection and does not by itself prove identity. The maintenance screen also requests native device location and supports a defect photo. Coordinates describe the phone location; they still need a server-side property comparison and persistence check before they can be described as verified property evidence.

**If phone login/camera/GPS fails, say:**

> The mobile interface is implemented, but this device take does not complete the native capture step. I will show the source implementation and report the integration status accurately.

### 04:25–04:50 — Nethmi's tenant screening website / Upamada

**Open:** React manager portal → **Tenant Screening & KYC**.

**කරන්න:**

1. **04:25–04:32:** Mobile screen එකෙන් manager website එකට මාරු වී **Tenant Screening & KYC** click කරන්න. Application cards සහ **Approved / Pending AI** tabs පෙන්වන්න.
2. **04:32–04:40:** Demo application එකක property, monthly income, rent, displayed score සහ status පෙන්වන්න. Screen එකේ actual figures භාවිත කරන්න.
3. **04:40–04:50:** **Inspect KYC Document** click කර demo document preview එක පෙන්වන්න; modal එක close කරන්න. **Run Risk AI** control තිබේ නම් එය පෙන්වා agent explanation එක ඉදිරියේ ඇති බව කියන්න. මේ section එක website workflow සඳහායි.

**Say:**

> We have already demonstrated my property and lease website component. After the mobile client, this is Nethmi Widumini's tenant screening website. The manager can review applications, compare income with rent, inspect a demonstration document, and view screening scores and statuses. I will explain her Python risk agent shortly.

**Recording note:** Displayed scores/statuses සහ documents seeded හෝ client-calculated විය හැකියි; API result එකෙන් තහවුරු කර පමණක් persisted result ලෙස කියන්න. **Approve KYC Verification** handler එක local state update කරනවා; document preview එක automated identity verification සනාථ කරන්නේ නැහැ. Already recorded Upamadaගේ Properties & Leases screen එකට නැවත යාම අවශ්‍ය නැහැ.

### 04:50–05:20 — Hashini's maintenance website / Upamada

**Open:** React manager portal → **Maintenance & Dispatch**. අවශ්‍ය නම් Swagger එකේ maintenance ticket response එක prepared tab එකක තියාගන්න.

**කරන්න:**

1. **04:50–04:57:** Maintenance & Dispatch click කරන්න. **Unassigned (Triage)**, **Dispatched**, **In Progress** සහ **Resolved** columns පෙන්වන්න.
2. **04:57–05:08:** Rehearsal එකේ API එකෙන් තහවුරු කළ disposable demo ticket එක තෝරන්න. Description, priority සහ **AI Triage** button පෙන්වන්න; button එක තිබේ නම් click කර returned estimate/status පෙන්වන්න.
3. **05:08–05:20:** High-cost ticket එකේ **Immediate Financial Review Queue**, estimate සහ **Authorize LKR … Repair** control පෙන්වන්න. Swagger **GET /api/maintenance/tickets/{id}** response එකෙන් එම ticket ID, estimate සහ status verify කරන්න. Saved approval එක කලින් verify කර නැත්නම් මෙහි approval click එක අවශ්‍ය නැහැ.

**Say:**

> Next is Hashini Wickramathilaka's maintenance website component. Work orders are organized by progress, with descriptions, priorities, repair estimates, and financial review controls. Here, the high-cost ticket is marked for manager review. I compare it with its API response to confirm the saved result. With all three website components covered, I will now explain our AI agents.

**Recording note:** Board එකේ seeded tickets සහ API error වෙලාවට local simulation තිබෙනවා. **AI Triage** button එකේ backend path එක C# `MaintenanceService` භාවිත කරනවා; එය පමණක් Python LangGraph execution එකක් සනාථ කරන්නේ නැහැ. Approval handler එක `approveTicket` call කරන නමුත් service එකේ ඒ method එක නැහැ; contractor dispatch/status advances ද local state updates. UI change එකක් පමණක් persisted approval/dispatch ලෙස විස්තර කරන්න එපා.

### 05:20–05:40 — Upamada's Planning and Orchestration Agent / Upamada

**Open:** `ai-agent/agents/planner.py` → `ai-agent/workflow.py` → prepared Swagger **POST /api/v1/ai/workflow/start** response.

**කරන්න:**

1. **05:20–05:26:** `planning_agent_node` සහ `state.plan_steps` පෙන්වන්න.
2. **05:26–05:32:** `workflow.py` තුළ `route_next_agent` පෙන්වන්න: `TENANT_APPLICATION` → `tenant_agent`; `MAINTENANCE` → `maintenance_agent`; දෙකම validator වෙත යනවා.
3. **05:32–05:40:** පහත tenant request එක කලින් prepare කර **Try it out → Execute** කරන්න. Response එකේ actual `workflow_id`, `plan_steps` සහ `agent_trace` පෙන්වන්න. මේ response එක next section එකට open තියාගන්න.

**Say:**

> My Planning and Orchestration Agent creates execution steps for the objective. The graph routes tenant applications and maintenance requests to their respective agents, followed by the validator. This workflow response shows the generated plan and execution trace.

**Tenant workflow request — paste into Swagger before recording:**

```json
{
  "domain_objective": "Screen a demo tenant for a residential lease",
  "target_entity_type": "TENANT_APPLICATION",
  "tenant_income": 300000,
  "property_rent": 60000
}
```

**Rehearsal:** **GET /api/v1/ai/health** එකේ `CONNECTED` බලන්න. Workflow response එකේ `plan_steps` සහ Python `agent_trace` ඇත්තටම තිබෙනවාද බලන්න. `WF-FALLBACK-…` response එකක් නම් C# fallback එකක් ලෙස හඳුන්වන්න; Python agents run වූ බව කියන්න එපා. Request එක seconds 10ට වැඩි කාලයක් ගත්තොත් gateway fallback විය හැකියි. Recording එකේ wait time කපාගන්න පුළුවන්; request සහ actual result දෙකම පෙන්වන්න.

### 05:40–06:05 — Nethmi's Tenant Screening and Risk Agent / Upamada

**Open:** Previous tenant workflow response → `ai-agent/agents/tenant_agent.py` → `ai-agent/tools/allowlisted_tools.py`.

**කරන්න:**

1. **05:40–05:51:** Response එකේ `rent_to_income_ratio`, `screening_score`, Nethmiගේ `agent_trace` entry සහ `final_status` පෙන්වන්න. මේ inputs සඳහා Python tool එකේ expected ratio **20%**, score **92/100**; actual response එක තහවුරු කර පමණක් කියන්න.
2. **05:51–06:05:** `tenant_screening_agent_node` තුළ `verify_credit_and_identity_tool` call එක සහ tool එකේ ratio/score rules පෙන්වන්න. Model advisory එකක් response එකේ නැත්නම් Gemini advisory generated බව කියන්න එපා.

**Say:**

> Nethmi Widumini developed the Tenant Screening and Risk Agent. It uses the supplied income and rent to calculate affordability and a screening score through an allow-listed tool. This example has a twenty-percent rent-to-income ratio and a score of ninety-two. These are policy-based demo results; the current identity flag is simulated, rather than an external identity verification.

**Evidence note:** Website එකේ **Tenant Screening & KYC → Run Risk AI** screen එක අදාළ business UI ලෙස පෙන්වන්න පුළුවන්. ඒ button එක හෝ displayed score එක පමණක් Python agent run වූ බව සනාථ කරන්නේ නැහැ; මෙහි Python workflow response එක භාවිත කරන්න. Ratios >35%ට score 65, >50%ට score 35; Python validator එක score <=65 සඳහා manager review flag කරනවා. එම Python path එක automatic tenant rejection ලෙස විස්තර කරන්න එපා.

### 06:05–06:35 — Hashini's Maintenance Triage Agent and Validator / Upamada

**Open:** Swagger **POST /api/v1/ai/workflow/start** → `ai-agent/agents/maintenance_agent.py` → `ai-agent/agents/validator.py`.

**කරන්න:**

1. **06:05–06:16:** පහත maintenance request එක execute කරන්න. Actual response එකේ `trade_category`, `estimated_cost`, `recommended_contractor` සහ Hashiniගේ `agent_trace` entry පෙන්වන්න.
2. **06:16–06:24:** `maintenance_agent.py` තුළ `estimate_repair_budget_tool` සහ `check_contractor_availability_tool` calls පෙන්වන්න.
3. **06:24–06:35:** `validator.py` තුළ `HIGH_COST_THRESHOLD = 50000.0`, `>=` condition එක පෙන්වන්න. Response එකේ `requires_human_approval`, `approval_reason`, `final_status` පෙන්වන්න. Python burst-pipe case එකේ expected cost **65000**, status **PENDING_APPROVAL**.

**Say:**

> Hashini's Maintenance Triage Agent classifies the defect, estimates the repair budget, and recommends a contractor from the demo directory. This Python burst-pipe case estimates sixty-five thousand rupees. The deterministic validator applies the fifty-thousand-rupee threshold and returns a pending-approval result. Durable approval, workflow resume, and contractor dispatch need separate evidence.

**Maintenance workflow request — paste into Swagger before recording:**

```json
{
  "domain_objective": "Triage a demo burst-pipe maintenance request",
  "target_entity_type": "MAINTENANCE",
  "issue_description": "Major burst pipe flooding the kitchen",
  "reported_priority": "HIGH"
}
```

**Evidence note:** Contractor lookup එක demo directory එකක්; real contractor booking එකක් ලෙස කියන්න එපා. Python graph එක validator පසු `END` වෙත යනවා; `PENDING_APPROVAL` flag එක තිබීම පමණක් durable paused execution හෝ working resume endpoint එකක් සනාථ කරන්නේ නැහැ. Backend fallback response එකේ burst-pipe cost **85000** සහ `PAUSED_FOR_HUMAN` ලැබිය හැකියි; ඒක Python 65000 result එකට සමාන බව කියන්න එපා. Actual result අනුව narration වෙනස් කරන්න.

### 06:35–06:50 — Tests, CI and deployment evidence / Upamada

**Open:** Prepared terminal and GitHub Actions page.

**කරන්න:** Actual backend, mobile සහ AI test outputs පෙන්වන්න. Commands:

    dotnet test backend/RMS.Backend.sln --no-restore --verbosity minimal
    cd mobile
    flutter test --no-pub
    cd ..\ai-agent
    python -m pytest -v

GitHub Actions එකේ actual backend test, AI pytest සහ frontend build jobs පෙන්වන්න. Current workflow එක separate lint command එකක් run නොකරනවා නම් lint passed කියන්න එපා.

**Say:**

> Finally, these outputs show the backend, mobile, and AI tests that actually ran, together with our build evidence. We also inspected the workflow plans, agent traces, tool results, and validation decisions.

### 06:50–07:00 — Closing / Upamada

**Open:** Closing slide with member names and contribution credits. Upamadaගේ voice එක පමණක් භාවිත කරන්න.

**Say:**

> This completes Group Four's Rental Management System demonstration, covering Upamada's, Nethmi's, and Hashini's website and AI contributions. Thank you for watching.

## Final checklist

- Architecture slide එකේ .NET 10 label එක නිවැරදිද?
- Health page එකේ actual Healthy සහ PostgreSQL status පෙනෙනවාද?
- Swagger request එක execute කර actual 200 response එක පෙන්වනවාද?
- Manager login එක dashboard එකට යනවාද?
- Property/lease result එක refresh/API/DB එකෙන් verify කළාද?
- Mobile camera/GPS result එක actual ද, නැත්නම් limitation එක කියනවාද?
- AI trace එක actual execution එකක්ද, static sample එකක්ද?
- Maintenance ticket එකේ saved state එක API එකෙන් verify කළාද?
- Upamadaගේ Properties & Leases website, Nethmiගේ Tenant Screening website සහ Hashiniගේ Maintenance website තුනම පැහැදිලිව පෙන්වනවාද?
- Planning, Tenant Risk සහ Maintenance Triage agents තුනම වෙන වෙනම credit කර පෙන්වනවාද?
- Tenant සහ maintenance requests දෙකේම actual Python agent traces තිබෙනවාද, නැත්නම් fallback බව කියනවාද?
- Test counts recording දවසේ actual output එකද?
- Video එක 07:00ට අවසන් වෙනවාද?
- Final link එක evaluatorට access request නැතිව open වෙනවාද?
