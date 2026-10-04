-- Read-only PostgreSQL evidence for the RMS 10-minute recording.
-- Open in your Neon SQL Editor after selecting the correct project/database.
-- Run each SELECT separately at the relevant scene.
-- Names match current EF Core DbSets/entities. No data is changed.

-- Scene 01:20-02:30: Created property survives a page refresh.
SELECT "Id", "Title", "MonthlyRent", "SecurityDeposit", "Status", "CreatedAtUtc"
FROM "Properties"
WHERE "Title" = 'SE3090 Demo Lease Unit'
ORDER BY "CreatedAtUtc" DESC;
-- Current property enum: Available=0, Occupied=1, UnderMaintenance=2, Inactive=3.

-- Scene 01:20-02:30: Actual lease row and property relationship.
SELECT l."Id" AS "LeaseId", l."PropertyId", p."Title", l."TenantId",
       l."StartDate", l."EndDate", l."AgreedRent", l."Status" AS "LeaseStatus",
       p."Status" AS "PropertyStatus"
FROM "Leases" AS l
JOIN "Properties" AS p ON p."Id" = l."PropertyId"
WHERE p."Title" = 'SE3090 Demo Lease Unit'
ORDER BY l."CreatedAtUtc" DESC;
-- Current lease enum: Draft=0, PendingSignature=1, Active=2, Terminated=3, Expired=4.

-- Optional scene 03:10-04:55: Persisted application for the onboarding unit.
SELECT a."Id" AS "ApplicationId", a."TenantId", a."PropertyId", p."Title",
       a."MonthlyIncome", a."AiRiskScore", a."Status", a."CreatedAtUtc"
FROM "TenantApplications" AS a
JOIN "Properties" AS p ON p."Id" = a."PropertyId"
WHERE p."Title" = 'SE3090 Demo Onboarding Unit'
ORDER BY a."CreatedAtUtc" DESC;
-- Current screening enum: Pending=0, Approved=1, Rejected=2, ReviewRequired=3.
-- Identity document URLs are omitted from the displayed result.

-- Scene 07:15-08:30: Ticket status and assignment after approval/reload.
SELECT "Id" AS "TicketId", "PropertyId", "TenantId", "IssueDescription",
       "Priority", "EstimatedCost", "Status", "AssignedContractorId",
       "CreatedAtUtc", "UpdatedAtUtc"
FROM "MaintenanceTickets"
WHERE "IssueDescription" LIKE 'SE3090-DEMO:%'
ORDER BY "CreatedAtUtc" DESC;
-- Current maintenance enum: Open=0, Assigned=1, PendingManagerApproval=2,
-- InProgress=3, Resolved=4. UI labels can differ; compare the same ticket ID.

-- The current reviewed schema has no workflow-history/approval-state table
-- and no dedicated maintenance latitude/longitude fields. Do not invent a
-- query or screenshot for them. After implementing durable storage, prepare
-- a separate read-only query using the actual migration/table/column names.
