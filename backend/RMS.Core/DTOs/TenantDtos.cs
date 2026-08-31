// =================================================================================================
// File: TenantDtos.cs
// Module: Component B: Tenant Screening & Onboarding Management
// Student Contributor: Nethmi Seya (IT24200314 Group Member)
// Architecture: Core Layer - Data Transfer Objects (DTOs) for Tenant Applications & Risk Scoring
// Purpose: Encapsulates submission payloads, KYC verification updates, and deterministic AI risk
//          evaluation responses (income-to-rent ratio, risk scores 0-100, approval flags).
// =================================================================================================

using RMS.Core.Entities;

namespace RMS.Core.DTOs;

/// <summary>
/// Data contract for submitting a prospective tenant rental application.
/// </summary>
/// <param name="TenantId">Unique identifier of the applicant.</param>
/// <param name="PropertyId">Target property listing identifier.</param>
/// <param name="MonthlyIncome">Verified gross monthly income in LKR.</param>
/// <param name="IdentityDocUrl">Secure link to uploaded National ID / Passport.</param>
public record SubmitApplicationDto(
    Guid TenantId,
    Guid PropertyId,
    decimal MonthlyIncome,
    string IdentityDocUrl
);

/// <summary>
/// Data contract for verifying tenant identity documents via external KYC provider.
/// </summary>
/// <param name="IdentityDocUrl">Updated verified document URL.</param>
/// <param name="IsVerifiedByProvider">Boolean flag indicating verification status.</param>
public record VerifyDocumentDto(
    string IdentityDocUrl,
    bool IsVerifiedByProvider
);

/// <summary>
/// Data contract representing full tenant application details returned to clients.
/// </summary>
/// <param name="Id">Application GUID.</param>
/// <param name="TenantId">Applicant GUID.</param>
/// <param name="PropertyId">Target Property GUID.</param>
/// <param name="MonthlyIncome">Reported monthly income in LKR.</param>
/// <param name="IdentityDocUrl">Document URL.</param>
/// <param name="Status">Current screening status.</param>
/// <param name="AiRiskScore">Credit/risk score (0-100).</param>
/// <param name="AiScreeningNotes">Screening audit reasoning notes.</param>
/// <param name="CreatedAtUtc">Application submission timestamp.</param>
public record ApplicationResponseDto(
    Guid Id,
    Guid TenantId,
    Guid PropertyId,
    decimal MonthlyIncome,
    string IdentityDocUrl,
    ScreeningStatus Status,
    int AiRiskScore,
    string? AiScreeningNotes,
    DateTime CreatedAtUtc
);

/// <summary>
/// Data contract returned by the non-trivial risk scoring calculation engine.
/// </summary>
/// <param name="ApplicationId">Evaluated application GUID.</param>
/// <param name="Status">Resulting screening status (Approved, ReviewRequired, Rejected).</param>
/// <param name="AiRiskScore">Calculated credit risk score (0-100).</param>
/// <param name="RentToIncomeRatio">Percentage of income consumed by rent.</param>
/// <param name="EvaluationNotes">Detailed rationale explaining score and rule triggers.</param>
/// <param name="RequiresManagerApproval">True if ratio is between 35% and 50%, pausing for HITL review.</param>
public record ScreeningEvaluationResultDto(
    Guid ApplicationId,
    ScreeningStatus Status,
    int AiRiskScore,
    decimal RentToIncomeRatio,
    string EvaluationNotes,
    bool RequiresManagerApproval
);
