// =================================================================================================
// File: ITenantScreeningService.cs
// Module: Component B: Tenant Screening & Onboarding Management
// Student Contributor: Nethmi Seya (IT24200314 Group Member)
// Architecture: Core Layer - Interface contract for tenant screening & risk assessment
// Purpose: Declares contracts for tenant onboarding, identity verification document attachments,
//          and executing deterministic financial risk scoring algorithms (0-100 risk score).
// =================================================================================================

using RMS.Core.DTOs;
using RMS.Core.Entities;

namespace RMS.Core.Interfaces;

/// <summary>
/// Service interface handling Tenant Screening, KYC, and Automated Risk Evaluation.
/// </summary>
public interface ITenantScreeningService
{
    /// <summary>
    /// Submits a new tenant application for an available property.
    /// </summary>
    /// <param name="dto">Tenant application submission payload.</param>
    /// <returns>Application details with initial Pending status.</returns>
    Task<ApplicationResponseDto> SubmitApplicationAsync(SubmitApplicationDto dto);

    /// <summary>
    /// Retrieves tenant application details by unique identifier.
    /// </summary>
    /// <param name="applicationId">Unique application GUID.</param>
    /// <returns>Application details DTO.</returns>
    Task<ApplicationResponseDto> GetApplicationByIdAsync(Guid applicationId);

    /// <summary>
    /// Retrieves all tenant applications, optionally filtered by screening status.
    /// </summary>
    /// <param name="status">Optional screening status filter.</param>
    /// <returns>Collection of matching applications.</returns>
    Task<IEnumerable<ApplicationResponseDto>> GetApplicationsByStatusAsync(ScreeningStatus? status);

    /// <summary>
    /// Verifies and updates identity/KYC documentation for a tenant application.
    /// </summary>
    /// <param name="applicationId">Unique application GUID.</param>
    /// <param name="dto">Verification details with document URL.</param>
    /// <returns>Updated application details DTO.</returns>
    Task<ApplicationResponseDto> VerifyIdentityDocumentAsync(Guid applicationId, VerifyDocumentDto dto);
    
    /// <summary>
    /// Non-Trivial Business-Specific Operation: Evaluates rent-to-income debt ratio, calculates 0-100 deterministic AI risk score, and flags for manager approval if borderline.
    /// </summary>
    /// <param name="applicationId">Unique application GUID.</param>
    /// <returns>Detailed evaluation result with risk score and approval requirement.</returns>
    Task<ScreeningEvaluationResultDto> EvaluateApplicationRiskAsync(Guid applicationId);
}
