# ADR-004: Relational PostgreSQL Schema & Entity Framework Core Migration Strategy

## Status
**Accepted**

## Context
The system requires ACID-compliant relational data modeling for property listings, leases, tenant applications, maintenance work orders, and contractors with foreign key constraints, indexes, and audit timestamps.

## Decision
We adopted **PostgreSQL 16 with Entity Framework Core (EF Core 10 / Npgsql)** following Clean Architecture:
1. **Normalized Tables**:
   - `Properties`: Landlord foreign keys, unit status enum, indexing on `Title` and `Address`.
   - `Leases`: Foreign keys to `Properties` and `Tenants`, `StartDate`, `EndDate`, `AgreedRent`, `AiDraftedClauses`.
   - `TenantApplications`: `MonthlyIncome`, `IdentityDocUrl`, `AiRiskScore`, `ScreeningStatus`.
   - `MaintenanceTickets`: Foreign keys to `Properties`, `Tenants`, `Contractors`, `IssueDescription`, `EstimatedCost`, `Priority`, `Status`, `AiTriageSummary`.
   - `Contractors`: Trade classification, contact info, ratings.
2. **Audit Tracking**: All domain entities inherit `BaseEntity` with `CreatedAtUtc` and `UpdatedAtUtc`.
3. **Resilient Provider Configuration**: Configured with automated fallback to `UseInMemoryDatabase("RMS_InMemory")` when a live PostgreSQL instance is not connected during development, testing, or CI.

## Consequences
### Positive:
- **Data Integrity**: Enforced foreign key cascades and non-null constraints.
- **Developer Experience**: Seamless unit testing without requiring an external PostgreSQL Docker container.
- **Production Readiness**: Pre-configured for PostgreSQL connection strings with standard migration commands.
