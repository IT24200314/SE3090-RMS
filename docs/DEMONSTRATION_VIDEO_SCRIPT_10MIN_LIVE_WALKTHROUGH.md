# RMS — Upamada Ekanayake ඉදිරිපත් කරන මිනිත්තු 10ක live walkthrough script

**Group:** SEF_KDY_AI_04  
**Presenter:** Upamada Ekanayake — IT24200314  
**Institution / specialization:** Group Four, SLIIT Kandy Uni, Artificial Intelligence  
**මුළු recording කාලය:** 00:00–10:00, හරියටම මිනිත්තු 10.  
**කියන වචන:** English. **කරන්න ඕන දේ සහ recording උපදෙස්:** සිංහල.  
**භාවිතය:** Upamada Ekanayake පමණක් කතා කරමින් group project එකේ සැබෑ application එක භාවිත කරන හැටි record කිරීම. Folder tour එකට වැඩියෙන් වෙලාව වැය නොකරන්න; source files කෙටියෙන් පෙන්වා නැවත working interface එකට යන්න.

**Voice recording:** සියලුම spoken lines Upamada කියන්න. වෙනත් presenter කෙනෙකුට handover එකක් නැහැ. පහත member table එක team contribution credits සඳහායි; ඒක speakers බෙදාගැනීමක් නෙවෙයි. කලින් තිබෙන අනෙක් membersගේ voice-clip files මේ solo version එකට අවශ්‍ය නැහැ.

## Recording කිරීමට පෙර වැදගත් කරුණ

මෙය **සම්පූර්ණ workflow එක record කරන්න ලියපු script එකක්**. Script එක තිබීමෙන් feature එක වැඩ කරන බව තහවුරු වෙන්නේ නැහැ. පහත සාර්ථක-result වචන කියන්න කලින් ඒ ප්‍රතිඵලය screen එකේ ඇත්තටම පෙන්වන්න පුළුවන් වෙන්න ඕනේ.

දැනට project review එකේ හමු වූ recording blockers: Android login; currency selector API wiring; camera image server upload; සාමාන්‍ය ticket/application request එක Python graph එකට සම්බන්ධ වීම; durable workflow state; authorized approval/resume; database එකේ save වන contractor dispatch සහ mobile refresh. මේවා rehearsal එකේ තහවුරු නොවුණොත් ඒ කොටස “completed” කියලා කියන්න එපා. Sample telemetry සහ local UI success toast එකක් සැබෑ execution/persistence ලෙස පෙන්වන්න එපා.

**වෙනස් නොකළ යුතු තොරතුරු:** current backend target .NET 10; Python burst/flood plumbing estimate LKR 65,000; approval threshold **>= LKR 50,000**. පෙර verified test counts backend 25 සහ mobile 9; recording දවසේ terminal එකේ ලැබෙන actual counts භාවිත කරන්න.

## 1. Presenter සහ team contribution credits

**මුළු 00:00–10:00 presentation එකම Upamada Ekanayake ඉදිරිපත් කරයි.** Group membersගේ contribution credits පහත පරිදි පවත්වාගන්න; project එකේ සියලු වැඩ තනිව කළා කියලා ඉදිරිපත් කරන්න එපා.

| Member | Student ID | ප්‍රධාන කොටස් |
|---|---|---|
| Upamada Ekanayake | IT24200314 | Intro, API, properties/leases, currency, architecture/planning, closing |
| Nethmi Seya (Widumini) | IT24101176 | Tenant onboarding, document capture, screening, testing/contribution evidence |
| Hashini Wickramathilaka | IT24100427 | Maintenance, GPS, repair triage, approval, cross-platform update |

## 2. මුලින් open කරලා තියාගන්න දේවල්

### VS Code workspace

**File → Open Folder** ගිහින් මේ folder එක open කරන්න:

`C:\Users\AI WORKPLACE\Documents\RENTAL MANEGEMENT SYSTEM`

පහත files VS Code tabs ලෙස කලින් open කරලා තියාගන්න. Recording අතරතුර folders හොයන්න වෙලාව ගන්න එපා.

| Tab | Folder එක තුළ open කරන file එක | පෙන්වන හේතුව |
|---|---|---|
| V1 | `backend/RMS.API/RMS.API.csproj` | Current `net10.0` target |
| V2 | `backend/RMS.API/Controllers/PropertiesController.cs` | API/controller entry point |
| V3 | `backend/RMS.Infrastructure/Services/PropertyLeaseService.cs` | Lease rules සහ property status update |
| V4 | `backend/RMS.Infrastructure/Data/AppDbContext.cs` | EF Core DbSets, indexes සහ lease relationship |
| V5 | `frontend/src/components/properties/PropertyList.jsx` | React property search/filter screen |
| V6 | `mobile/lib/screens/onboarding/tenant_application_screen.dart` | `_captureWithCamera`, image picker සහ submission |
| V7 | `ai-agent/agents/tenant_agent.py` | Tenant agent input සහ scoring/tool use |
| V8 | `mobile/lib/screens/tenant/tenant_maintenance_screen.dart` | GPS, camera සහ maintenance submission |
| V9 | `ai-agent/workflow.py` | Graph nodes සහ conditional routing |
| V10 | `ai-agent/tools/allowlisted_tools.py` | Controlled tools සහ actual repair estimate |
| V11 | `ai-agent/agents/validator.py` | `HIGH_COST_THRESHOLD = 50000.0` |
| V12 | `.github/workflows/ci.yml` | CI jobs සහ ඇත්තටම execute කරන commands |

Related folders වන `backend/RMS.Tests`, `mobile/test`, සහ `ai-agent/tests` Explorer එකේ expand කරලා තියාගන්න. හැම file එකක්ම video එකේ open කරන්න අවශ්‍ය නැහැ.

### Browser tabs

| Tab | Open කරන URL/page එක |
|---|---|
| B1 — React | https://rms-frontend-jet-rho.vercel.app/ |
| B2 — Swagger | https://rms-backend-api-yons.onrender.com/swagger/index.html |
| B3 — API health | https://rms-backend-api-yons.onrender.com/health |
| B4 — CI | https://github.com/IT24200314/SE3090-RMS/actions — recording දවසේ relevant successful run එක open කරන්න |
| B5 — Git evidence | https://github.com/IT24200314/SE3090-RMS — actual commits/PR evidence පෙර තෝරාගන්න |
| B6 — Database | තමන්ගේ Neon console එකේ **SQL Editor**; login කරලා project/database එක තෝරාගෙන ඉන්න |

Record කරන්න කලින් browser එකෙන් URLs open කර services warm කරගන්න. Final recording එකට external AI chat හෝ copilot panel අවශ්‍ය නැහැ. `.env`, connection strings සහ token values screen එකේ තියාගන්න එපා.

**CI rehearsal check:** වත්මන් local `.github/workflows/ci.yml` .NET `8.0.x` SDK එක සකස් කරන නමුත් backend current target `net10.0`. Final build එකට SDK version එක ගැළපෙන CI run එකක් අවශ්‍යයි. පරණ වෙනත් commit එකේ green run එක current revision එකේ proof ලෙස නොපෙන්වන්න.

### Phone

Android phone එකේ RMS app එක open කර tenant dashboard එකට කලින්ම login වෙනවාද පරීක්ෂා කරන්න. Camera සහ location permissions rehearsal එකේ සකස් කරන්න. Phone recording එක වෙනම capture කර desktop footage එකට cut කරන්න පුළුවන්; gestures සහ resulting screens පැහැදිලිව පෙනෙන්න ඕනේ.

**Demo accounts:** manager `manager@rms.lk`, tenant `tenant@rms.lk`, contractor `contractor@rms.lk`. Supplied demo password `Password123!`. භාවිත කරන build එකේ මෙම accounts වල actual roles සහ access controls rehearsal එකේ තහවුරු කරන්න.

### Terminals

VS Code එකේ **Terminal → New Terminal** භාවිත කර මේ තුන කලින් සූදානම් කරන්න:

| Terminal | Working directory | Recording command |
|---|---|---|
| T1 — Backend | Workspace root | `dotnet test backend/RMS.Backend.sln --no-restore --verbosity minimal` |
| T2 — Mobile | `mobile` | `flutter test --no-pub` |
| T3 — Agents | `ai-agent` | `python -m pytest -v` |

මෙම commands recording environment එකේ පෙර run කරලා dependencies සහ SDKs වැඩ කරනවාද බලන්න. `python` සඳහා AI dependencies තියෙන environment එක activate කරන්න. `pytest` වැඩ නොකරන්නේ නම් එය local pass එකක් කියන්න එපා; actual GitHub AI-job output එක පෙන්වන්න. `flutter` PATH එකේ නැත්නම් PowerShell තුළ `& 'C:\Users\AI WORKPLACE\flutter\bin\flutter.bat' test --no-pub` භාවිත කරන්න.

### පෙර සූදානම් demo data

| Data | Value / භාවිතය |
|---|---|
| Recording අතරතුර create කරන property | `SE3090 Demo Lease Unit` |
| Sample address | `Demo Unit, Colombo 03` — මෙය demo address එකක් |
| Rent / deposit | LKR 45,000 / LKR 90,000 |
| Tenant onboarding සඳහා පෙර සකස් කළ available property | `SE3090 Demo Onboarding Unit`, rent LKR 45,000 |
| Applicant monthly income | LKR 180,000 — ratio 45,000 ÷ 180,000 = 25% |
| Lease tenant ID | Backend එකේ තිබෙන **actual demo tenant GUID**; modal default GUID එක අන්ධ ලෙස භාවිත නොකරන්න |
| Lease dates | Recording දවසට වලංගු start date එක සහ මාස 12කට පසු end date එක |
| Document | `DEMO ONLY` ලියපු sample card එක; actual NIC එකක් අවශ්‍ය නැහැ |
| Maintenance description | `SE3090-DEMO: Severe burst main pipe in bathroom causing flooding. Water heater cracked.` |
| Maintenance property | Actual demo tenantට අදාළ test property ID; current screen hardcoded/වෙනත් property ID එකක් submit කරනවා නම් එය මුලින් නිවැරදි කරන්න |
| Contractor | Database එකේ ඇත්තටම තිබෙන demo contractor ID/name |

New property create කිරීම හෝ approval කිරීම real tenant data මත නොකරන්න. මෙහි workflow එක disposable demo records වලට පමණක් අදාළ කරගන්න.

## 3. හරියටම මිනිත්තු 10ක timeline

| කාලය | Duration | Screen / ප්‍රධාන action | Presenter |
|---|---:|---|---|
| 00:00–00:35 | 35 s | Intro සහ architecture | Upamada |
| 00:35–01:20 | 45 s | API health, Swagger, role-based login | Upamada |
| 01:20–02:30 | 70 s | Property create/search සහ lease operation | Upamada |
| 02:30–03:10 | 40 s | Actual currency API request | Upamada |
| 03:10–04:55 | 105 s | Flutter document capture, tenant application, React review | Upamada |
| 04:55–06:05 | 70 s | Flutter maintenance, GPS සහ defect photo | Upamada |
| 06:05–07:15 | 70 s | Actual agent execution, tool result සහ validator | Upamada |
| 07:15–08:30 | 75 s | Authorized approval, database proof සහ mobile update | Upamada |
| 08:30–09:35 | 65 s | Tests, CI සහ contribution evidence | Upamada |
| 09:35–10:00 | 25 s | Team conclusion | Upamada |
| **Total** | **600 s** | **10:00** | |

**Timing උපදෙස:** speech එක සාමාන්‍ය වේගයෙන් කියන්න. ඉතිරි තත්පර clicks, typing, responses සහ evidence inspect කිරීමට භාවිත කරන්න. Loading time එකට වඩා වැඩි වුණොත් වෙනත් rehearsal take එකක් ගන්න; time හදාගන්න fabricated response එකක් දාන්න එපා. Source files සඳහා 5–8 seconds බැගින් සෑහේ.

## 4. Full spoken script සහ screen actions

### 00:00–00:35 — Intro / Upamada

**Open:** කෙටි title/architecture slide එකක්. Project එකේ `docs/scene1_title_slide.html` භාවිත කරන්නේ නම් stack label එක recording පෙර .NET 10ට නිවැරදි කරන්න; අද script එක එම HTML file එක වෙනස් කරලා නැහැ.

**කරන්න:**

- 00:00–00:12: project name, group ID සහ members තුන්දෙනාගේ නම්/IDs පෙන්වන්න.
- 00:12–00:25: diagram එකේ React + Flutter → ASP.NET Core → PostgreSQL සහ backend හරහා Python agent service connection එක පෙන්වන්න.
- 00:25–00:35: VS Code V1 එකේ `TargetFramework` කෙටියෙන් පෙන්වා B3 health tab එකට මාරු වෙන්න.

**Say:**

> Good day, everyone. We are Group Four from SLIIT Kandy Uni, specializing in Artificial Intelligence. Our project topic is the Rental Management System, developed for SE3090. I am Upamada Ekanayake, and today I am going to present our group project. I will demonstrate the web and mobile applications, backend and database integration, and our agentic AI workflow. Our system combines React, Flutter, ASP.NET Core targeting dot NET 10, PostgreSQL, and Python LangGraph.

### 00:35–01:20 — API, roles සහ access / Upamada

**Open:** B3 health → B2 Swagger → B1 React.

**කරන්න:**

- 00:35–00:43: health response එකේ actual status සහ database connection field එක පෙන්වන්න.
- 00:43–00:53: Swagger එකේ Auth, Properties, Leases, tenants, maintenance සහ AI routes කෙටියෙන් scroll කර පෙන්වන්න. API screen එකේ endpoint names භාවිත කරන්න.
- 00:53–01:08: B1 තුළ Manager preset හෝ manager credentials භාවිත කර **Sign In to RMS Portal** click කරන්න. Role indicator සහ manager navigation පෙන්වන්න.
- 01:08–01:20: පෙර rehearsal කළ manager-only operation එක tenant token එකෙන් ඉල්ලූ විට ලැබෙන actual denial response එක පෙන්වන්න. No token request එකකට සාමාන්‍යයෙන් 401; authenticated tenantට manager permission නැතිවිට 403. Token field එක recording එකේ පෙන්වන්න අවශ්‍ය නැහැ.

**Say:**

> First, the health response shows the deployed API and its database connection. Swagger documents our request and response contracts. I am signing in as the property manager, while the mobile client will use the tenant account. The authorization check shown here demonstrates whether a restricted operation is actually blocked for the wrong role. We check the server response rather than relying only on hidden navigation buttons.

**Rehearsal gate:** current business controllers වල authorization gaps හමු වී තිබෙන නිසා 401/403 ලැබෙන බව කලින් තහවුරු කරන්න. Actual result 200 නම් “blocked” කියන්න එපා; ඒක fix කරන්න අවශ්‍ය security failure එකක්.

### 01:20–02:30 — Property create, filters සහ lease / Upamada

**Open:** B1 → sidebar **Properties & Leases**. V3 `PropertyLeaseService.cs` සහ B6 SQL Editor කලින් ready කරගන්න.

**කරන්න:**

- 01:20–01:32: **Add Property** click කරන්න. Empty form එක submit කිරීමට උත්සාහ කර required-field validation එක කෙටියෙන් පෙන්වන්න.
- 01:32–01:48: title `SE3090 Demo Lease Unit`, demo address, rent `45000`, deposit `90000`, description `Disposable demonstration property` දමා form එකේ create/submit button එක click කරන්න. Actual successful response එක බලන්න.
- 01:48–02:00: search box එකට `SE3090 Demo Lease Unit` type කරන්න. **Available** filter එක click කරන්න. Page refresh කර saved record එක නැවත පෙන්වන්න.
- 02:00–02:15: property card එකේ **Draft Lease Agreement** click කරන්න. Actual tenant GUID, start/end dates සහ rent පරීක්ෂා කර **Next Step** හරහා ගිහින් **Generate Legal Contract** click කරන්න.
- 02:15–02:23: property status සහ lease response එක පෙන්වන්න. Current service එක lease එක **PendingSignature** ලෙස create කර property එක **Occupied** කරයි; මෙය completed digital signing එකක් ලෙස කියන්න එපා.
- 02:23–02:30: B6 තුළ SQL file එකේ property/lease query run කර same property ID, lease row සහ statuses පෙන්වන්න. V3 function එක පෙර tab එකේ open කර ඇති බව පෙන්වීම rehearsal/extra source take එකකට තබන්න; DB proofට ප්‍රමුඛතාව දෙන්න.

**Say:**

> Component A manages property listings and lease operations. I first show form validation, then create a disposable demo property with a monthly rent of forty five thousand rupees. Search and availability filters help locate the saved unit. After refreshing, the record remains visible. The lease form uses the actual tenant identifier and valid dates. In the current implementation, generating the contract creates a pending-signature lease and marks the property occupied. The database rows confirm the saved relationship and status changes.

**Note:** current create/read සහ lease business operation පෙන්වීමෙන් සම්පූර්ණ CRUD එකක් තහවුරු වෙන්නේ නැහැ. Edit/delete capability නැත්නම් එය implementation gap එකක්; නොපවතින buttons script එකේ invent කරලා නැහැ.

### 02:30–03:10 — Third-party currency integration / Upamada

**Open:** B2 Swagger → `POST /api/external/currency/convert`.

**කරන්න:**

- 02:30–02:40: **Try it out** click කර request body එක paste කරන්න:

```json
{
  "amountLkr": 45000,
  "targetCurrency": "USD"
}
```

- 02:40–02:55: **Execute** click කරන්න. Returned `convertedAmount`, `exchangeRate`, `provider` සහ `isFallbackRate` බලන්න. Exact USD value කලින් script එකේ දාලා නැහැ; recording response එකෙන් කියන්න.
- 02:55–03:03: amount `0` දාලා execute කර validation failure/status code එක පෙන්වන්න.
- 03:03–03:10: ඔබම phone footage එකට මාරු වී tenant onboarding section එක ආරම්භ කරන්න.

**Say:**

> Our currency integration lets international tenants compare rent in another currency. This request passes through ASP.NET Core, and the response identifies the rate and provider. The fallback flag distinguishes a live provider response from a fallback calculation. An invalid amount is also rejected. The frontend selector needs its own working API wiring; this segment demonstrates the actual backend integration. Next, I will demonstrate tenant onboarding through our Flutter application.

**Optional after UI fix:** Swagger take එක වෙනුවට React LKR/USD/EUR buttons සහ real network response පෙන්වන්න පුළුවන්. UI selector fix නොකර dropdown clicks පමණක් live conversion ලෙස පෙන්වන්න එපා.

### 03:10–04:55 — Flutter onboarding, camera සහ screening / Upamada

**Open:** Android RMS tenant dashboard → **Explore Homes**. Browser B1 → **Tenant Screening & KYC** කලින් ready කරගන්න. V6 සහ V7 source tabs supporting references ලෙස තියාගන්න.

**කරන්න:**

- 03:10–03:25: app එකේ tenant role සහ pre-created available `SE3090 Demo Onboarding Unit` card එක පෙන්වා **Apply (KYC)** tap කරන්න.
- 03:25–03:40: income `180000` දාන්න. Recording build එකේ ඇති actual fields පමණක් පුරවන්න; employment field එක නොතිබුණොත් එය invent කරන්න එපා.
- 03:40–04:00: **Capture Document** tap කරන්න. Native camera එකෙන් `DEMO ONLY` card එක capture කර confirmation දී app එකට ආපසු එන්න. Captured image preview පෙන්වන්න.
- 04:00–04:15: **Submit & Run AI Screening** tap කරන්න. Real application ID සහ actual result පෙන්වන්න. Server upload වෙනවාද, image එක managerගේ වෙනම client එකෙන් open වෙනවාද rehearsal එකේ තහවුරු කරන්න.
- 04:15–04:35: B1 **Tenant Screening & KYC** refresh කර same application ID/tenant/property එක හොයන්න. Actual scoring notes/ratio පෙන්වන්න. Rent 45,000 සහ income 180,000 වන record එකට ratio 25% බව පෙන්වන්න.
- 04:35–04:45: V7 tenant agent code එකේ input/tool call කෙටියෙන් පෙන්වන්න. Source explanation එක සහ app request එක සැබෑ ලෙස Python එකට ගිය evidence එක වෙන්කර තේරුම්ගන්න.
- 04:45–04:55: review status සහ request outcome එක පෙන්වා ඔබම maintenance section එකට මාරු වෙන්න. මෙම record එක තවම review අවශ්‍ය නම් manager decision demo එක ලෙස නිරූපණය කළ හැක; sample “KYC Verified” badge එකක් identity authenticity proof එකක් නෙවෙයි.

**Say:**

> I will now show Component B: tenant onboarding and risk assessment. The tenant selects an available property and enters the requested application information. Here I use the Android camera to photograph a clearly marked demonstration document and review the captured image. I then submit the application and follow its identifier to the manager portal. With rent of forty five thousand and income of one hundred and eighty thousand, the rent-to-income ratio is twenty five percent. The scoring rules assess the financial inputs; collecting a photograph does not itself prove identity or verified income. The manager reviews the actual submitted record and its result. Next, I will demonstrate maintenance reporting.

**Successful-result lines — use only if the evidence is on screen:**

> The document shown here was uploaded to server storage and opened from the manager's separate client. This application response is linked to the actual tenant-agent execution.

**If blocked, say instead:**

> Document capture is available in the client, but server upload or agent integration is not yet verified. We will report that limitation rather than treat the interface badge as completed verification.

### 04:55–06:05 — Maintenance, GPS සහ photo / Upamada

**Open:** Android RMS → bottom navigation **Maintenance**. Current tenant screen title **Report Maintenance Defect**.

**කරන්න:**

- 04:55–05:10: description එකට `SE3090-DEMO: Severe burst main pipe in bathroom causing flooding. Water heater cracked.` type/paste කරන්න. **Emergency** priority select කරන්න. Rehearsal එකේ input clipboard ready තියාගන්න.
- 05:10–05:25: **GPS Location Tagging (Native Geolocation)** card එකේ location icon tap කරන්න. Device fix එක පෙනෙනකම් ඉඳලා actual coordinates පෙන්වන්න. Fallback values native GPS fix ලෙස නොපෙන්වන්න.
- 05:25–05:40: **Camera Capture** tap කර sample defect photo එක capture කරන්න. Camera app එකෙන් ආපසු එන හැටි සහ attached evidence පෙන්වන්න.
- 05:40–05:55: **Submit Ticket to AI Triage** tap කරන්න. Actual ticket ID සහ returned status පෙන්වා ඒ ID එක note කරගන්න.
- 05:55–06:05: B1 **Maintenance & Dispatch** refresh කර same ticket ID/description හොයන්න. එය නොපෙනුණොත් dummy card එකක් replacement ලෙස නොභාවිත කරන්න.

**Say:**

> Now I will show Component C: maintenance operations. I am reporting a sample burst-pipe emergency from the Flutter client. The location action requests a device GPS fix, and the camera collects a demonstration defect photograph. GPS coordinates describe the phone's location; an address match needs a separate check. After submitting, I use the returned ticket identifier to locate the same report in the manager portal. This keeps the demonstration tied to one real request rather than an unrelated sample card.

**Rehearsal gate:** current mobile GPS screen can substitute fixed Colombo coordinates when GPS fails; current backend ticket entity has no dedicated latitude/longitude fields. Native fix සහ durable location storage දෙකම වෙන වෙනම තහවුරු කරන්න. Screen එකේ coordinates තිබීමෙන් database persistence ඔප්පු වෙන්නේ නැහැ.

### 06:05–07:15 — Planner, triage සහ validator / Upamada

**Open:** V9 `ai-agent/workflow.py` → live workflow result screen/API response → V10/V11.

**කරන්න:**

- 06:05–06:15: Upamada V9 තුළ planner, tenant/maintenance routing සහ validator nodes පෙන්වන්න. Python එකේ independent domain paths දෙකම එක request එකේ execute වෙන්න ඕනේ කියලා කියන්න එපා.
- 06:15–06:25: Submitted ticket එකට සම්බන්ධ actual workflow ID සහ multi-step plan පෙන්වන්න. React **Agentic AI Telemetry** screen එක live result එකෙන් populate වන build එකක් නම් එය භාවිත කරන්න; current sample traces genuine evidence ලෙස නොපෙන්වන්න.
- 06:25–06:40: ඔබම actual agent/tool result එකේ issue classification සහ estimate පෙන්වන්න. Python burst/flood case එකට expected estimate `65000`; gateway fallback result එකක් නම් එය Python graph run එකක් කියලා නිරූපණය නොකරන්න.
- 06:40–06:50: V10 තුළ relevant tool function එක පෙන්වන්න. V11 `HIGH_COST_THRESHOLD = 50000.0` සහ `>=` comparison එක පෙන්වන්න.
- 06:50–07:05: Actual `requires_human_approval`, approval reason සහ final status පෙන්වන්න. Python result label `PENDING_APPROVAL`; backend entity label `PendingManagerApproval` විය හැක. ඒවා එකම database-backed workflow එකට සම්බන්ධ වන evidence පෙන්වන්න.
- 07:05–07:15: Stored workflow ID/state සහ audit details පෙන්වා approval screen එකට මාරු වෙන්න. State model file එකක් පෙන්වීම durable storage proof එකක් නොවේ.

**Upamada says:**

> The planner creates a structured plan and routes the objective to the appropriate domain agent. This maintenance request should follow the maintenance path and then the deterministic validator. We will inspect the actual execution result for the ticket we just created.

**Upamada continues:**

> The repair tool returns an estimated cost of sixty five thousand rupees for this burst-pipe example. The validator compares it against the fifty-thousand-rupee threshold. At or above that amount, the request requires a manager decision. The execution result should identify the plan, participating agent, tool output, validation, and approval reason. A pending-approval label must be backed by stored state before we can claim a resumable human-review workflow.

**Standalone AI diagnostic — rehearsal/backup only:** shared ticket integration නැත්නම් B2 හි `POST /api/v1/ai/workflow/start` පහත request එකෙන් actual Python response පරීක්ෂා කළ හැක. මෙය existing ticket එකට automatically persist/link වන බව ඔප්පු නොකරයි; complete client workflow එකට replacement එකක් නොවේ.

```json
{
  "domain_objective": "Triage the SE3090 demo burst-pipe repair and require manager review when the estimate reaches the policy threshold",
  "target_entity_type": "MAINTENANCE",
  "target_entity_id": "REPLACE_WITH_ACTUAL_TICKET_GUID",
  "issue_description": "SE3090-DEMO: Severe burst main pipe in bathroom causing flooding. Water heater cracked.",
  "reported_priority": "EMERGENCY"
}
```

### 07:15–08:30 — Authorized approval, persisted result සහ mobile refresh / Upamada

**Open:** B1 **Maintenance & Dispatch** → same ticket; B6 SQL Editor; Android client; B2 ticket GET.

**කරන්න:**

- 07:15–07:30: Same ticket ID, cost සහ manager role පෙන්වන්න. High-cost card එකේ **Authorize LKR 65,000 Repair** වැනි actual amount එක සහිත button එක පෙන්වන්න.
- 07:30–07:45: Authorized demo manager විසින් approval දෙන්න. Contractor selection සඳහා **Dispatch** button/modal එක භාවිත කර actual demo contractor තෝරන්න. **Dispatch Contractor to Property** click කරන්න.
- 07:45–08:00: Browser refresh කරන්න. Same ticket එක assigned/dispatched state එකේ සහ same contractor සමඟ පවතිනවාද පෙන්වන්න. Backend enum `Assigned` UI එකේ `Dispatched` ලෙස පෙන්විය හැක; “status 1” වැනි numeric value එකට mapping අවශ්‍ය නම් කෙටියෙන් පැහැදිලි කරන්න.
- 08:00–08:12: B6 SQL file එකේ maintenance query run කර ticket ID, `EstimatedCost`, `Status`, `AssignedContractorId` පෙන්වන්න. Actual workflow-state/approval audit storage එකේ record එකත් පෙන්වන්න; නොපවතින workflow table එකක් පෙන්වන්න එපා.
- 08:12–08:22: Android app එකෙන් relevant ticket detail/status screen එක නැවත open/refresh කරන්න. Current build එකේ ticket-history screen නැත්නම් එය මුලින් implement කරන්න; submission popup එක updated-status proof ලෙස නොපෙන්වන්න.
- 08:22–08:30: Same ticket ID දෙපැත්තේ compare කරන්න. B2 `GET /api/maintenance/tickets/{id}` response එක supporting check ලෙස තියාගන්න.

**Before approval, say:**

> The estimate needs a manager decision before contractor assignment. I am reviewing the same ticket as the authorized demo manager. We will approve the request, select the test contractor, and then verify the saved result rather than relying on a success notification.

**After actual refresh/database/mobile proof succeeds, say:**

> After reloading, the assignment remains visible. PostgreSQL contains the same ticket identifier, approved estimate, status, and contractor identifier. The tenant's mobile client now reads the updated state for that ticket. This completes the workflow from Flutter, through our backend, database and agent processing, to React review and back to the initiating tenant.

**If that proof fails, say:**

> The interface changed, but the refreshed API or mobile record does not yet confirm the same saved result. The approval integration remains incomplete, so we cannot claim that the cross-platform workflow is complete.

**Current implementation gate:** UI approval/dispatch handlers can update local state; the Python resume endpoint and durable graph approval mechanism were absent in the reviewed build. An ASP.NET fallback “COMPLETED” response alone is not proof that the agent resumed or the database updated. Recording මෙම successful ending එක සඳහා integration fixes සහ actual evidence අවශ්‍යයි.

### 08:30–09:35 — Tests, CI සහ contribution evidence / Upamada

**Open:** T1/T2/T3 prepared terminals → B4 successful CI run → B5 actual contribution evidence.

**කරන්න:**

- 08:30–08:45: Upamada T1 හි backend command execute කර final passed/failed summary පෙන්වන්න. Run time වැඩි නම් අවශ්‍ය command recording පෙර execute කර ඇති actual terminal output පෙන්වා “previously executed run” ලෙස හඳුන්වන්න.
- 08:45–09:00: ඔබම T2 හි mobile tests result පෙන්වන්න. Test folder එකේ model/widget සහ login regression test names කෙටියෙන් පෙන්වන්න.
- 09:00–09:15: ඔබම T3 හි actual AI pytest output පෙන්වන්න. Local environment unavailable නම් B4 AI job → **Run Agentic Pytest Suite** step output පෙන්වා remote run බව කියන්න. Actual test count සහ run date භාවිත කරන්න.
- 09:15–09:25: B4 successful run එකේ backend, AI සහ frontend jobs පෙන්වන්න. `.github/workflows/ci.yml` supporting tab එකේ commands බලන්න. Job title “Build & Lint” වුණත් current workflow separate lint command එකක් run නොකරන නිසා lint pass වුණා කියන්න එපා.
- 09:25–09:35: B5 තුළ member තුන්දෙනාගේ actual commits/PR examples කෙටියෙන් පෙන්වන්න. ඔබ එක් එක් memberගේ actual file/change එකක් සඳහන් කරන්න. Ownership සනාථ කරන්න ලේසි PR/commit pages පෙර තෝරාගන්න.

**Upamada says:**

> These are the actual backend test results. The previous verified run passed twenty five tests, and we use the count shown in this recording. CI also builds the backend and runs its tests.

**Upamada continues — mobile tests:**

> The mobile tests cover the models, validation, widgets, and navigation regression. We show the executed results and a real contribution record for each member. Passing tests support the behavior they cover; they do not replace the cross-platform evidence we just checked.

**Upamada continues — agent tests and CI:**

> The agent tests exercise workflow rules, high-cost review, and security cases. This CI run shows the actual test output and the frontend production build. We report the results produced by those steps rather than assuming a job label means extra checks ran.

### 09:35–10:00 — Closing / Upamada

**Open:** team contribution credits සහිත closing slide එක, හෝ Upamadaගේ camera view එක. Solo presentation එකේ closing එකත් Upamadaම කියන්න.

**කරන්න:**

- 09:35–09:45: Member names, IDs සහ component ownership පෙන්වන්න.
- 09:45–10:00: පහත closing එක කියන්න. Final frame එක 10:00දී නවත්වන්න.

**Say — if the workflow succeeded:**

> Our demonstration connected property management, tenant onboarding, maintenance reporting, and a governed approval workflow across the web and mobile clients. We have shown the actual results and contribution evidence. Each member is prepared to explain, test, modify, and debug their work during the viva. Thank you for your time.

**Say — if a workflow remains incomplete:**

> We have demonstrated the working parts of property management, onboarding, and maintenance, and clearly identified the integration steps that remain incomplete. Each member is prepared to explain the implementation, evidence, and remaining issues during the viva. Thank you for your time.

## 5. Final rehearsal check — එකම record එක අනුගමනය කරන්න

1. Recording එකේ title/group/student IDs නිවැරදිද?
2. Intro .NET target එක current build එකට ගැළපෙනවාද?
3. Lease සඳහා actual tenant GUID සහ property ID භාවිත කරනවාද?
4. Phone login, native camera සහ සැබෑ GPS fix වැඩ කරනවාද?
5. Document/photo server upload එක වෙනම client එකෙන් තහවුරු වෙනවාද?
6. Flutter එකෙන් create කළ actual ticket එක React සහ database එකේ එකම ID එකෙන් පෙනෙනවාද?
7. UI sample telemetry වෙනුවට actual agent execution තියෙනවාද?
8. Cost >= 50,000 approval requirement සහ authorized decision සැබෑ ලෙස enforce වෙනවාද?
9. Approval/assignment refresh එකකට පසුවත් database සහ mobile තුළ පවතිනවාද?
10. Terminal/CI output ඇත්තටම run කළ results ද? Contribution pages සැබෑද?

Rehearsal එකට screen recordings දෙකක් කළ හැක: desktop සහ Android. එක් workflow එකේ ID සහ sequence පවත්වාගෙන ඒවා edit කරන්න. Short cuts සහ typing pauses trim කළ හැකි නමුත් failures මකා දමා unrelated success record එකක් ඒ request එකේ ප්‍රතිඵලය ලෙස පෙන්වන්න එපා.

Final video link එක login/access request නැතිව evaluatorට view කළ හැකි ලෙස share කරන්න. Published specification එකේ live evaluation සඳහා මිනිත්තු 10ක demonstration එකක් සහ මිනිත්තු 20ක viva එකක් දක්වා තිබේ; members සියලුදෙනා ඒ සඳහා සූදානම් විය යුතුය.

## 6. මේ guide එකේ source references

Timing සහ evidence coverage සකස් කළේ supplied assignment specification හි Sections 10, 15, 16.1 සහ 17.1 අනුව. File paths/button labels වත්මන් local source එකෙන් පරීක්ෂා කර ඇත. Deployed build එක local code එකට වඩා පරණ නම් rehearsal එකේ actual labels සහ behavior සටහන් කර script එක ඒ අනුව යාවත්කාලීන කරන්න.

මේ script එක සෑදීමේදී deployed records වෙනස් කර නැත, workflow submit කර නැත, database write එකක් කර නැත, සහ app functionality fixes හෝ deployment එකක් කර නැත.
