// =================================================================================================
// File: TenantScreeningService.cs
// Module: Component B: Tenant Screening & Onboarding Management
// Student Contributor: Nethmi Seya (IT24200314 Group Member)
// Architecture: Infrastructure / Service Layer - Tenant Screening & Risk Engine Business Logic
// Purpose: Implements tenant onboarding workflows, KYC document registration, and the non-trivial
//          deterministic income-to-rent debt ratio and 0-100 risk scoring algorithm.
// =================================================================================================

using Microsoft.EntityFrameworkCore;
using RMS.Core.DTOs;
using RMS.Core.Entities;
using RMS.Core.Exceptions;
using RMS.Core.Interfaces;
using RMS.Infrastructure.Data;

namespace RMS.Infrastructure.Services;

/// <summary>
/// Service implementing tenant onboarding, document validation, and risk calculation algorithms.
/// </summary>
public class TenantScreeningService : ITenantScreeningService
{
    private readonly AppDbContext _context;

    public TenantScreeningService(AppDbContext context)
    {
        _context = context;
    }

    /// <inheritdoc/>
    public async Task<ApplicationResponseDto> SubmitApplicationAsync(SubmitApplicationDto dto)
    {
        var property = await _context.Properties.FindAsync(dto.PropertyId)
            ?? throw new NotFoundException($"Property with ID '{dto.PropertyId}' was not found.");

        if (property.Status != PropertyStatus.Available)
        {
            throw new InvalidBusinessOperationException("Cannot apply for a property that is not currently available.");
        }

        var application = new TenantApplication
        {
            TenantId = dto.TenantId,
            PropertyId = dto.PropertyId,
            MonthlyIncome = dto.MonthlyIncome,
            IdentityDocUrl = dto.IdentityDocUrl,
            Status = ScreeningStatus.Pending,
            AiRiskScore = 0
        };

        _context.TenantApplications.Add(application);
        await _context.SaveChangesAsync();

        return MapToDto(application);
    }

    /// <inheritdoc/>
    public async Task<ApplicationResponseDto> GetApplicationByIdAsync(Guid applicationId)
    {
        var app = await _context.TenantApplications.FindAsync(applicationId)
            ?? throw new NotFoundException($"Application with ID '{applicationId}' was not found.");

        return MapToDto(app);
    }

    /// <inheritdoc/>
    public async Task<IEnumerable<ApplicationResponseDto>> GetApplicationsByStatusAsync(ScreeningStatus? status)
    {
        var query = _context.TenantApplications.AsNoTracking();
        if (status.HasValue)
        {
            query = query.Where(a => a.Status == status.Value);
        }

        var apps = await query.OrderByDescending(a => a.CreatedAtUtc).ToListAsync();
        return apps.Select(MapToDto);
    }

    /// <inheritdoc/>
    public async Task<ApplicationResponseDto> VerifyIdentityDocumentAsync(Guid applicationId, VerifyDocumentDto dto)
    {
        var app = await _context.TenantApplications.FindAsync(applicationId)
            ?? throw new NotFoundException($"Application with ID '{applicationId}' was not found.");

        app.IdentityDocUrl = dto.IdentityDocUrl;
        app.UpdatedAtUtc = DateTime.UtcNow;

        await _context.SaveChangesAsync();
        return MapToDto(app);
    }

    /// <inheritdoc/>
    public async Task<ScreeningEvaluationResultDto> EvaluateApplicationRiskAsync(Guid applicationId)
    {
        var app = await _context.TenantApplications.FindAsync(applicationId)
            ?? throw new NotFoundException($"Application with ID '{applicationId}' was not found.");

        var property = await _context.Properties.FindAsync(app.PropertyId)
            ?? throw new NotFoundException($"Associated property '{app.PropertyId}' not found.");

        if (app.MonthlyIncome <= 0)
        {
            throw new InvalidBusinessOperationException("Monthly income must be greater than zero for screening evaluation.");
        }

        // Standard financial rule: Rent should not exceed 35% of gross income
        decimal rentToIncomeRatio = (property.MonthlyRent / app.MonthlyIncome) * 100m;
        int calculatedRiskScore;
        string notes;
        ScreeningStatus resultingStatus;
        bool requiresManagerApproval = false;

        if (rentToIncomeRatio > 50m)
        {
            calculatedRiskScore = 35; // High Risk
            resultingStatus = ScreeningStatus.Rejected;
            notes = $"High risk: Rent accounts for {rentToIncomeRatio:F1}% of tenant's verified monthly income (Exceeds 50% limit).";
        }
        else if (rentToIncomeRatio > 35m)
        {
            calculatedRiskScore = 65; // Moderate Risk - Requires Human-in-the-Loop review
            resultingStatus = ScreeningStatus.ReviewRequired;
            requiresManagerApproval = true;
            notes = $"Moderate risk: Rent accounts for {rentToIncomeRatio:F1}% of monthly income. Flagged for Manager Approval.";
        }
        else
        {
            calculatedRiskScore = 92; // Low Risk / Safe
            resultingStatus = ScreeningStatus.Approved;
            notes = $"Low risk: Tenant income securely covers rent ({rentToIncomeRatio:F1}% ratio). Identity and credit criteria met.";
        }

        app.AiRiskScore = calculatedRiskScore;
        app.Status = resultingStatus;
        app.AiScreeningNotes = notes;
        app.UpdatedAtUtc = DateTime.UtcNow;

        await _context.SaveChangesAsync();

        return new ScreeningEvaluationResultDto(
            app.Id,
            app.Status,
            app.AiRiskScore,
            Math.Round(rentToIncomeRatio, 2),
            notes,
            requiresManagerApproval
        );
    }

    private static ApplicationResponseDto MapToDto(TenantApplication app) =>
        new(app.Id, app.TenantId, app.PropertyId, app.MonthlyIncome, app.IdentityDocUrl, app.Status, app.AiRiskScore, app.AiScreeningNotes, app.CreatedAtUtc);
}
