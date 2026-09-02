// =================================================================================================
// File: TenantProfile.cs
// Module: Component B: Tenant Screening & Onboarding Management
// Student Contributor: Nethmi Seya (IT24200314 Group Member)
// Architecture: Core Domain Layer - Tenant Onboarding & Screening Application Entities
// Purpose: Models tenant applications, KYC document references, and AI risk scoring fields,
//          supporting deterministic financial viability calculations and status workflows.
// =================================================================================================

namespace RMS.Core.Entities;

/// <summary>
/// Represents the evaluation and onboarding lifecycle state of a tenant rental application.
/// </summary>
public enum ScreeningStatus
{
    /// <summary>Application freshly submitted, awaiting identity verification and risk evaluation.</summary>
    Pending,
    /// <summary>Application successfully passed all financial and KYC criteria (Low Risk).</summary>
    Approved,
    /// <summary>Application failed financial ratios or background validation (High Risk / Rent > 50% Income).</summary>
    Rejected,
    /// <summary>Application requires human manager review due to borderline risk metrics (35% - 50% Income).</summary>
    ReviewRequired
}

/// <summary>
/// Domain entity representing a tenant's formal application to lease a specific property.
/// </summary>
public class TenantApplication : BaseEntity
{
    /// <summary>Unique identifier of the prospective tenant applicant.</summary>
    public Guid TenantId { get; set; }

    /// <summary>Unique identifier of the property being applied for.</summary>
    public Guid PropertyId { get; set; }

    /// <summary>Verified monthly gross income in LKR reported by the tenant.</summary>
    public decimal MonthlyIncome { get; set; }

    /// <summary>Secure URL / path to the uploaded National Identity Card (NIC) or Passport document.</summary>
    public string IdentityDocUrl { get; set; } = string.Empty;

    /// <summary>Current screening decision state of this application.</summary>
    public ScreeningStatus Status { get; set; } = ScreeningStatus.Pending;

    /// <summary>Deterministic AI-calculated credit/risk score between 0 (extreme risk) and 100 (prime credit).</summary>
    public int AiRiskScore { get; set; }

    /// <summary>Contextual reasoning and audit notes generated during deterministic risk evaluation.</summary>
    public string? AiScreeningNotes { get; set; }
}
