# Rental Management System (RMS) - Relational Database Schema & ERD

## 1. Entity-Relationship Diagram (ERD)

```mermaid
erDiagram
    PROPERTIES ||--o{ LEASES : "has"
    PROPERTIES ||--o{ MAINTENANCE_TICKETS : "generates"
    PROPERTIES ||--o{ TENANT_APPLICATIONS : "receives"
    CONTRACTORS ||--o{ MAINTENANCE_TICKETS : "assigned_to"

    PROPERTIES {
        UUID id PK
        VARCHAR(200) title "INDEX"
        TEXT description
        VARCHAR(300) address "INDEX"
        DECIMAL(18_2) monthly_rent
        DECIMAL(18_2) security_deposit
        INT status "0:Available, 1:Occupied, 2:UnderMaintenance"
        UUID landlord_id "FK"
        TIMESTAMPTZ created_at_utc
        TIMESTAMPTZ updated_at_utc
    }

    LEASES {
        UUID id PK
        UUID property_id FK "REFERENCES PROPERTIES(id)"
        UUID tenant_id FK
        TIMESTAMPTZ start_date
        TIMESTAMPTZ end_date
        DECIMAL(18_2) agreed_rent
        INT status "0:PendingSignature, 1:Active, 2:Terminated, 3:Expired"
        TEXT ai_drafted_clauses
        TIMESTAMPTZ created_at_utc
        TIMESTAMPTZ updated_at_utc
    }

    TENANT_APPLICATIONS {
        UUID id PK
        UUID tenant_id FK
        UUID property_id FK "REFERENCES PROPERTIES(id)"
        DECIMAL(18_2) monthly_income
        VARCHAR(500) identity_doc_url
        INT status "0:Pending, 1:Approved, 2:Rejected, 3:ReviewRequired"
        INT ai_risk_score "0 to 100"
        TEXT ai_screening_notes
        TIMESTAMPTZ created_at_utc
        TIMESTAMPTZ updated_at_utc
    }

    MAINTENANCE_TICKETS {
        UUID id PK
        UUID property_id FK "REFERENCES PROPERTIES(id)"
        UUID tenant_id FK
        TEXT issue_description
        VARCHAR(500) photo_url
        INT priority "0:Low, 1:Medium, 2:High, 3:Emergency"
        INT status "0:Open, 1:Assigned, 2:PendingManagerApproval, 3:InProgress, 4:Resolved"
        DECIMAL(18_2) estimated_cost
        TEXT ai_triage_summary
        UUID assigned_contractor_id FK "REFERENCES CONTRACTORS(id) (Nullable)"
        TIMESTAMPTZ created_at_utc
        TIMESTAMPTZ updated_at_utc
    }

    CONTRACTORS {
        UUID id PK
        VARCHAR(150) company_name
        VARCHAR(100) trade_category "Plumbing, Electrical, General, Structural"
        VARCHAR(50) contact_phone
        DECIMAL(3_2) rating "e.g. 4.90"
        BOOLEAN is_available
        TIMESTAMPTZ created_at_utc
        TIMESTAMPTZ updated_at_utc
    }
```

---

## 2. Table Schemas, Constraints & Indexes

### A. `Properties` Table
- **Primary Key**: `id` (UUID, Default `gen_random_uuid()`)
- **Indexes**:
  - `idx_properties_status` on `status` (B-Tree)
  - `idx_properties_title` on `title` (Trigram / B-Tree for search)
  - `idx_properties_address` on `address` (B-Tree)
- **Audit Columns**: `created_at_utc` (NOT NULL), `updated_at_utc` (NULL)

### B. `Leases` Table
- **Primary Key**: `id` (UUID)
- **Foreign Keys**:
  - `property_id` $\rightarrow$ `Properties(id)` ON DELETE RESTRICT
- **Check Constraints**: `CHECK (end_date > start_date)`, `CHECK (agreed_rent > 0)`
- **Indexes**: `idx_leases_property_id`, `idx_leases_status`

### C. `TenantApplications` Table
- **Primary Key**: `id` (UUID)
- **Foreign Keys**: `property_id` $\rightarrow$ `Properties(id)` ON DELETE CASCADE
- **Check Constraints**: `CHECK (monthly_income >= 0)`, `CHECK (ai_risk_score BETWEEN 0 AND 100)`
- **Indexes**: `idx_applications_status`, `idx_applications_risk_score`

### D. `MaintenanceTickets` Table
- **Primary Key**: `id` (UUID)
- **Foreign Keys**:
  - `property_id` $\rightarrow$ `Properties(id)` ON DELETE CASCADE
  - `assigned_contractor_id` $\rightarrow$ `Contractors(id)` ON DELETE SET NULL
- **Check Constraints**: `CHECK (estimated_cost >= 0)`
- **Business Safeguard**: Any row with `estimated_cost >= 50000.00` is paused at `status = 2 (PendingManagerApproval)`.
