---
name: postgresql-database-design
description: PostgreSQL schema normalization, indexing strategies, EF Core migrations, transaction management, seed data, and audit logging.
---

# PostgreSQL & Database Design Skill

## Core Guidelines
1. **Schema Design & Normalization**:
   - 3rd Normal Form (3NF) compliance for transactional integrity.
   - Primary Keys: UUIDv7 or `BIGSERIAL` / `INT IDENTITY`.
   - Foreign Keys: Indexed for performance with explicit cascade/restrict behaviors.

2. **Audit Trails & Soft Deletes**:
   - Common audit columns: `CreatedAtUtc`, `UpdatedAtUtc`, `CreatedBy`, `IsDeleted`, `DeletedAtUtc`.
   - Interceptors in EF Core to automatically populate audit timestamps.

3. **EF Core Migrations & Seed Data**:
   - Clean migration naming (e.g., `AddPropertyAndLeaseTables`).
   - Realistic seed data for development and testing environments (sample properties, tenants, leases, maintenance tickets).

4. **Transaction & Concurrency Management**:
   - Explicit transactions (`BeginTransactionAsync`) for multi-entity operations (e.g. lease generation + deposit allocation).
   - Optimistic concurrency control using timestamp/version tokens (`xmin` or concurrency row version).
