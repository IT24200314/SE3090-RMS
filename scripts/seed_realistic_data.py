import psycopg2
from psycopg2.extras import execute_values
import uuid
from datetime import datetime, timezone

NEON_CONN = "postgresql://neondb_owner:npg_OGmZB17jWfJh@ep-bitter-union-azwzwv86-pooler.c-3.ap-southeast-1.aws.neon.tech/neondb?sslmode=require"

def seed_database():
    print("Connecting to Neon Cloud Database...")
    conn = psycopg2.connect(NEON_CONN)
    cur = conn.cursor()

    cur.execute("SELECT table_name FROM information_schema.tables WHERE table_schema = 'public';")
    tables = [row[0] for row in cur.fetchall()]
    print(f"Found tables in Neon: {tables}")

    now = datetime.now(timezone.utc)

    # 1. Properties
    properties = [
        (
            'e1a3b8c4-5d6e-7f8a-9b0c-1d2e3f4a5b6c',
            'Oceanfront Luxury Suite',
            'Modern 3-bedroom apartment with panoramic views of the Indian Ocean, infinity pool access, and designer Italian fittings.',
            '142 Marine Drive, Colombo 03',
            220000.0,
            440000.0,
            0, # Available
            '11111111-1111-1111-1111-111111111111',
            now,
            now
        ),
        (
            'f2b4c9d5-6e7f-8a9b-0c1d-2e3f4a5b6c7d',
            'Cinnamon Gardens Townhouse',
            'Colonial style refurbished 4-bedroom villa with private landscaped courtyard, solar power array, and maid quarters.',
            '28 Flower Road, Colombo 07',
            350000.0,
            700000.0,
            1, # Occupied
            '11111111-1111-1111-1111-111111111111',
            now,
            now
        ),
        (
            'a3c5d0e6-7f8a-9b0c-1d2e-3f4a5b6c7d8e',
            'Havelock City Studio Apartment',
            'High-rise 1-bedroom executive studio on the 18th floor with clubhouse amenities, squash courts, and 24/7 security.',
            '324 Havelock Road, Colombo 05',
            110000.0,
            220000.0,
            0, # Available
            '11111111-1111-1111-1111-111111111111',
            now,
            now
        ),
        (
            'b4d6e1f7-8a9b-0c1d-2e3f-4a5b6c7d8e9f',
            'Rajagiriya Lakeview Condo',
            'Spacious 2-bedroom luxury unit overlooking the Diyawanna sanctuary with premium timber flooring and modular kitchen.',
            '88 Lake Drive, Rajagiriya',
            165000.0,
            330000.0,
            2, # UnderMaintenance
            '11111111-1111-1111-1111-111111111111',
            now,
            now
        ),
        (
            'c5e7f2a8-9b0c-1d2e-3f4a-5b6c7d8e9f0a',
            'Kandy Royal Hills Sanctuary',
            'Scenic 3-bedroom hillside villa overlooking the Mahaweli river valley with private terrace garden and temperate climate.',
            '45 Rajapihilla Mawatha, Kandy',
            140000.0,
            280000.0,
            0, # Available
            '11111111-1111-1111-1111-111111111111',
            now,
            now
        ),
        (
            'd6f8a3b9-0c1d-2e3f-4a5b-6c7d8e9f0a1b',
            'Galle Fort Dutch Colonial Suite',
            'Historic restored 2-bedroom suite within the UNESCO World Heritage Galle Fort, featuring 18-foot ceilings and terracotta verandas.',
            '18 Lighthouse Street, Galle Fort',
            210000.0,
            420000.0,
            0, # Available
            '11111111-1111-1111-1111-111111111111',
            now,
            now
        ),
        (
            'e7a9b4c0-1d2e-3f4a-5b6c-7d8e9f0a1b2c',
            'Mount Lavinia Sunset Penthouse',
            'Exclusive top-floor beachfront duplex with 360-degree ocean views, private jacuzzi on balcony, and direct beach trail.',
            '12 Hotel Road, Mount Lavinia',
            195000.0,
            390000.0,
            1, # Occupied
            '11111111-1111-1111-1111-111111111111',
            now,
            now
        ),
        (
            'f8b0c5d1-2e3f-4a5b-6c7d-8e9f0a1b2c3d',
            'Nuwara Eliya Pine Valley Cottage',
            'Cozy 3-bedroom Tudor-style country residence featuring brick fireplaces, landscaped English rose garden, and lake proximity.',
            '05 Upper Lake Road, Nuwara Eliya',
            135000.0,
            270000.0,
            0, # Available
            '11111111-1111-1111-1111-111111111111',
            now,
            now
        )
    ]

    print("Upserting Properties...")
    execute_values(cur, """
        INSERT INTO "Properties" ("Id", "Title", "Description", "Address", "MonthlyRent", "SecurityDeposit", "Status", "LandlordId", "CreatedAtUtc", "UpdatedAtUtc")
        VALUES %s
        ON CONFLICT ("Id") DO UPDATE SET
            "Title" = EXCLUDED."Title",
            "Description" = EXCLUDED."Description",
            "Address" = EXCLUDED."Address",
            "MonthlyRent" = EXCLUDED."MonthlyRent",
            "SecurityDeposit" = EXCLUDED."SecurityDeposit",
            "Status" = EXCLUDED."Status",
            "UpdatedAtUtc" = EXCLUDED."UpdatedAtUtc";
    """, properties)

    # 2. Maintenance Tickets
    tickets = [
        (
            'b1a2b3c4-d5e6-7f8a-9b0c-1d2e3f4a5b6c',
            'e1a3b8c4-5d6e-7f8a-9b0c-1d2e3f4a5b6c',
            '22222222-2222-2222-2222-222222222222',
            'Emergency: High-pressure burst pipe in master bathroom creating localized flooding across teak floors.',
            'https://images.unsplash.com/photo-1585704032915-c3400ca199e7?auto=format&fit=crop&w=800&q=80',
            3, # Emergency
            2, # PendingManagerApproval (Exceeds LKR 50K -> HITL Pause)
            65000.0,
            "Classified under 'Plumbing Services'. Estimated budget: LKR 65,000.00. [FLAGGED] Exceeds LKR 50K ceiling. Paused at PendingManagerApproval node for human authorization.",
            None,
            now,
            now
        ),
        (
            'b2b3c4d5-e6f7-8a9b-0c1d-2e3f4a5b6c7d',
            'f2b4c9d5-6e7f-8a9b-0c1d-2e3f4a5b6c7d',
            '22222222-2222-2222-2222-222222222222',
            'Main distribution electrical panel sparking intermittently under heavy AC load. Potential short circuit.',
            'https://images.unsplash.com/photo-1621905251189-08b45d6a269e?auto=format&fit=crop&w=800&q=80',
            2, # High
            0, # Open
            28000.0,
            "Classified under 'Electrical Engineering'. Estimated budget: LKR 28,000.00. [APPROVED] Within autonomous limit (< LKR 50,000). Ready for contractor dispatch.",
            None,
            now,
            now
        ),
        (
            'b3c4d5e6-f7a8-9b0c-1d2e-3f4a5b6c7d8e',
            'a3c5d0e6-7f8a-9b0c-1d2e-3f4a5b6c7d8e',
            '22222222-2222-2222-2222-222222222222',
            'Master bedroom inverter air conditioning unit leaking condensed water onto drywall and rattling loudly.',
            'https://images.unsplash.com/photo-1581092160607-ee22621dd758?auto=format&fit=crop&w=800&q=80',
            1, # Medium
            1, # Assigned
            32000.0,
            "Classified under 'HVAC Services'. Auto-triage assigned to Lanka Cool Air Services. Contractor notified via SMS gateway.",
            '33333333-3333-3333-3333-333333333333',
            now,
            now
        ),
        (
            'b4d5e6f7-8a9b-0c1d-2e3f-4a5b6c7d8e9f',
            'b4d6e1f7-8a9b-0c1d-2e3f-4a5b6c7d8e9f',
            '22222222-2222-2222-2222-222222222222',
            'Front entrance biometric RFID digital lock battery depleted and keypad failed to engage deadlock mechanism.',
            'https://images.unsplash.com/photo-1558002038-1055907df827?auto=format&fit=crop&w=800&q=80',
            0, # Low
            4, # Resolved
            12000.0,
            "Smart Home Security repair. Replaced backup lithium cells and calibrated mortise bolt. Tenant signed completion receipt.",
            '33333333-3333-3333-3333-333333333333',
            now,
            now
        ),
        (
            'b5e7f2a8-9b0c-1d2e-3f4a-5b6c7d8e9f0a',
            'c5e7f2a8-9b0c-1d2e-3f4a-5b6c7d8e9f0a',
            '22222222-2222-2222-2222-222222222222',
            'Rooftop solar water heater heating element calcified, resulting in inadequate hot water pressure during mornings.',
            'https://images.unsplash.com/photo-1509391365360-2e959784a276?auto=format&fit=crop&w=800&q=80',
            1, # Medium
            3, # InProgress
            42000.0,
            "Solar Thermal plumbing maintenance. Replacement copper elements dispatched with contractor on-site.",
            '33333333-3333-3333-3333-333333333333',
            now,
            now
        )
    ]

    print("Upserting Maintenance Tickets...")
    execute_values(cur, """
        INSERT INTO "MaintenanceTickets" ("Id", "PropertyId", "TenantId", "IssueDescription", "PhotoUrl", "Priority", "Status", "EstimatedCost", "AiTriageSummary", "AssignedContractorId", "CreatedAtUtc", "UpdatedAtUtc")
        VALUES %s
        ON CONFLICT ("Id") DO UPDATE SET
            "PropertyId" = EXCLUDED."PropertyId",
            "TenantId" = EXCLUDED."TenantId",
            "IssueDescription" = EXCLUDED."IssueDescription",
            "PhotoUrl" = EXCLUDED."PhotoUrl",
            "Priority" = EXCLUDED."Priority",
            "Status" = EXCLUDED."Status",
            "EstimatedCost" = EXCLUDED."EstimatedCost",
            "AiTriageSummary" = EXCLUDED."AiTriageSummary",
            "AssignedContractorId" = EXCLUDED."AssignedContractorId",
            "UpdatedAtUtc" = EXCLUDED."UpdatedAtUtc";
    """, tickets)

    # 3. Tenant Applications
    apps = [
        (
            'c1d2e3f4-a5b6-7c8d-9e0f-1a2b3c4d5e6f',
            '22222222-2222-2222-2222-222222222222',
            'e1a3b8c4-5d6e-7f8a-9b0c-1d2e3f4a5b6c',
            650000.0,
            'https://images.unsplash.com/photo-1633265486064-086b219458ec?auto=format&fit=crop&w=600&q=80',
            1, # Approved
            92,
            'Low risk profile: Monthly income LKR 650,000 securely covers rent of LKR 220,000 (33.8% rent-to-income ratio). Identity verified against National Registry.',
            now,
            now
        ),
        (
            'd2e3f4a5-b6c7-8d9e-0f1a-2b3c4d5e6f7a',
            '22222222-2222-2222-2222-222222222222',
            'f2b4c9d5-6e7f-8a9b-0c1d-2e3f4a5b6c7d',
            750000.0,
            'https://images.unsplash.com/photo-1633265486064-086b219458ec?auto=format&fit=crop&w=600&q=80',
            3, # ReviewRequired
            68,
            'Moderate risk profile: Rent of LKR 350,000 accounts for 46.7% of gross income (exceeds 40% optimal threshold). Paused for Human-in-the-Loop review.',
            now,
            now
        ),
        (
            'e3f4a5b6-c7d8-9e0f-1a2b-3c4d5e6f7a8b',
            '22222222-2222-2222-2222-222222222222',
            'a3c5d0e6-7f8a-9b0c-1d2e-3f4a5b6c7d8e',
            175000.0,
            'https://images.unsplash.com/photo-1633265486064-086b219458ec?auto=format&fit=crop&w=600&q=80',
            0, # Pending
            54,
            'Debt-to-income ratio at 62.8% (> 50% high threshold). Requires secondary guarantor or risk bond prior to lease execution.',
            now,
            now
        )
    ]

    print("Upserting Tenant Applications...")
    execute_values(cur, """
        INSERT INTO "TenantApplications" ("Id", "TenantId", "PropertyId", "MonthlyIncome", "IdentityDocUrl", "Status", "AiRiskScore", "AiScreeningNotes", "CreatedAtUtc", "UpdatedAtUtc")
        VALUES %s
        ON CONFLICT ("Id") DO UPDATE SET
            "TenantId" = EXCLUDED."TenantId",
            "PropertyId" = EXCLUDED."PropertyId",
            "MonthlyIncome" = EXCLUDED."MonthlyIncome",
            "IdentityDocUrl" = EXCLUDED."IdentityDocUrl",
            "Status" = EXCLUDED."Status",
            "AiRiskScore" = EXCLUDED."AiRiskScore",
            "AiScreeningNotes" = EXCLUDED."AiScreeningNotes",
            "UpdatedAtUtc" = EXCLUDED."UpdatedAtUtc";
    """, apps)

    conn.commit()
    cur.close()
    conn.close()
    print("Database seeding completed successfully with 8 luxury properties, 5 realistic maintenance tickets, and 3 KYC tenant applications!")

if __name__ == '__main__':
    seed_database()
