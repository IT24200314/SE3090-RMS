# RMS — Upamada Ekanayakeගේ මිනිත්තු 7ක පැහැදිලි demonstration script

**Group:** Group Four, SLIIT Kandy Uni  
**Specialization:** Artificial Intelligence  
**Presenter:** Upamada Ekanayake — IT24200314  
**Topic:** Rental Management System (RMS)  
**Total duration:** 07:00  
**Language:** කියන කොටස English; screen actions සිංහල උපදෙස් ලෙස දී ඇත.

## Video එකේ එකම story එක

මෙම recording එකේ flow එක මෙහෙම තියාගන්න:

Architecture → API/database health → real API request/response → Manager web portal → property/lease feature → mobile client → Agentic AI guardrail → tests and conclusion

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
| ai-agent/workflow.py | Planner, domain agent සහ validator graph |
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
| 04:25–05:35 | 70 s | AI workflow | Plan, tool, validator and guardrail |
| 05:35–06:25 | 50 s | Tests/CI | Show actual test and CI evidence |
| 06:25–07:00 | 35 s | Closing | Summarize and finish |
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

### 04:25–05:35 — Agentic AI workflow and approval guardrail / Upamada

**Open:** VS Code files: ai-agent/workflow.py, ai-agent/tools/allowlisted_tools.py, and ai-agent/agents/validator.py.

Live AI response/telemetry එකක් තිබේ නම් ඒක පෙන්වන්න. Static sample trace එක live execution ලෙස පෙන්වන්න එපා.

**කරන්න:** workflow.py තුළ planner, tenant agent, maintenance agent සහ validator nodes පෙන්වන්න. allowlisted tools file එකේ repair estimate function එක පෙන්වන්න. validator.py තුළ HIGH_COST_THRESHOLD = 50000.0 සහ >= condition එක පෙන්වන්න. Actual workflow response එකේ workflow ID, plan steps, agent trace, estimated cost, validation result සහ approval status පෙන්වන්න.

**Say:**

> Our Agentic AI workflow begins with a planning node and routes the objective to the relevant domain agent. A maintenance request can call an allow-listed repair-estimation tool. The deterministic validator then checks the result against our financial policy. For the burst-pipe test case, the implementation estimate is sixty five thousand Sri Lankan rupees. Because this is at least the fifty-thousand-rupee threshold, the result should require a manager decision. The important evidence is the actual workflow ID, agent trace, tool result, validation decision, and approval status. A source file or a sample telemetry card alone is not proof that a live workflow executed.

Manager approval, workflow resume, database persistence, contractor dispatch සහ mobile refresh පෙන්වන්න පුළුවන් වෙන්නේ ඒවා actual end-to-end test එකකින් තහවුරු කළ පසු පමණයි.

### 05:35–06:25 — Tests, CI and deployment evidence / Upamada

**Open:** Prepared terminal and GitHub Actions page.

**කරන්න:** Actual backend, mobile සහ AI test outputs පෙන්වන්න. Commands:

    dotnet test backend/RMS.Backend.sln --no-restore --verbosity minimal
    cd mobile
    flutter test --no-pub
    cd ..\ai-agent
    python -m pytest -v

GitHub Actions එකේ actual backend test, AI pytest සහ frontend build jobs පෙන්වන්න. Current workflow එක separate lint command එකක් run නොකරනවා නම් lint passed කියන්න එපා.

**Say:**

> Finally, I will show the executed quality checks. The backend test command gives the actual number of passed and failed tests. The mobile and AI results are shown from the environment in which they were actually run. GitHub Actions provides the build and test evidence for the repository. These results support the tested parts of the project, while the live workflow evidence connects the clients, API, database, and Agentic AI behavior.

### 06:25–07:00 — Closing / Upamada

**Open:** Closing slide with member names and contribution credits. Upamadaගේ voice එක පමණක් භාවිත කරන්න.

**Say:**

> To conclude, our Rental Management System brings together a React manager portal, a Flutter tenant application, an ASP.NET Core Web API, PostgreSQL persistence, third-party integration, and a governed Agentic AI workflow. In this demonstration I showed the architecture, deployed health, Swagger request and response, manager portal, business modules, mobile client, AI guardrail, and test evidence. Our team members contributed across these components, and we are prepared to explain, test, modify, and debug our work during the viva. Thank you for watching.

## Final checklist

- Architecture slide එකේ .NET 10 label එක නිවැරදිද?
- Health page එකේ actual Healthy සහ PostgreSQL status පෙනෙනවාද?
- Swagger request එක execute කර actual 200 response එක පෙන්වනවාද?
- Manager login එක dashboard එකට යනවාද?
- Property/lease result එක refresh/API/DB එකෙන් verify කළාද?
- Mobile camera/GPS result එක actual ද, නැත්නම් limitation එක කියනවාද?
- AI trace එක actual execution එකක්ද, static sample එකක්ද?
- Test counts recording දවසේ actual output එකද?
- Video එක 07:00ට අවසන් වෙනවාද?
- Final link එක evaluatorට access request නැතිව open වෙනවාද?
