// =================================================================================================
// File: MaintenanceDtos.cs
// Module: Component C: Maintenance & Work-Order Operations
// Student Contributor: Hashini Wicramathilake (IT24200314 Group Member)
// Architecture: Core Layer - Data Transfer Objects (DTOs) for Maintenance Tickets & Triage
// Purpose: Encapsulates ticket creation payloads, contractor dispatching models, resolution notes,
//          and automated triage evaluation results (trade categorization and budget thresholds).
// =================================================================================================

using RMS.Core.Entities;

namespace RMS.Core.DTOs;

/// <summary>
/// Data contract for creating a tenant-reported maintenance request.
/// </summary>
/// <param name="PropertyId">Target property unit identifier.</param>
/// <param name="TenantId">Reporting tenant identifier.</param>
/// <param name="IssueDescription">Comprehensive description of the maintenance defect.</param>
/// <param name="PhotoUrl">URL or cloud storage path of captured defect photo.</param>
/// <param name="Priority">Initial priority classification.</param>
public record CreateMaintenanceTicketDto(
    Guid PropertyId,
    Guid TenantId,
    string IssueDescription,
    string PhotoUrl,
    MaintenancePriority Priority
);

/// <summary>
/// Data contract for assigning a certified contractor and allocating approved repair funds.
/// </summary>
/// <param name="ContractorId">Selected contractor identifier.</param>
/// <param name="ApprovedBudget">Approved spending budget in LKR.</param>
public record AssignContractorDto(
    Guid ContractorId,
    decimal ApprovedBudget
);

/// <summary>
/// Data contract for concluding a maintenance ticket with final invoice cost and resolution summary.
/// </summary>
/// <param name="CompletionNotes">Contractor work completion summary.</param>
/// <param name="FinalCost">Final invoiced cost in LKR.</param>
public record CompleteTicketDto(
    string CompletionNotes,
    decimal FinalCost
);

/// <summary>
/// Data contract representing full maintenance ticket state returned to clients.
/// </summary>
/// <param name="Id">Ticket unique identifier.</param>
/// <param name="PropertyId">Target property identifier.</param>
/// <param name="TenantId">Tenant identifier.</param>
/// <param name="IssueDescription">Issue description text.</param>
/// <param name="PhotoUrl">Photo evidence URL.</param>
/// <param name="Priority">Current priority level.</param>
/// <param name="Status">Current lifecycle status.</param>
/// <param name="EstimatedCost">Estimated repair budget in LKR.</param>
/// <param name="AiTriageSummary">Triage categorization summary and approval notes.</param>
/// <param name="AssignedContractorId">Assigned contractor identifier if any.</param>
/// <param name="CreatedAtUtc">Creation timestamp in UTC.</param>
/// <param name="UpdatedAtUtc">Last updated timestamp in UTC.</param>
public record MaintenanceTicketResponseDto(
    Guid Id,
    Guid PropertyId,
    Guid TenantId,
    string IssueDescription,
    string PhotoUrl,
    MaintenancePriority Priority,
    MaintenanceStatus Status,
    decimal EstimatedCost,
    string? AiTriageSummary,
    Guid? AssignedContractorId,
    DateTime CreatedAtUtc,
    DateTime? UpdatedAtUtc
);

/// <summary>
/// Data contract returned by the non-trivial maintenance triage and cost estimation engine.
/// </summary>
/// <param name="TicketId">Evaluated ticket GUID.</param>
/// <param name="Priority">Re-evaluated or confirmed urgency priority.</param>
/// <param name="Status">Resulting ticket status (Open vs. PendingManagerApproval).</param>
/// <param name="EstimatedCost">Estimated budget in LKR based on heuristic trade pricing.</param>
/// <param name="SuggestedTradeCategory">Classified trade (e.g. Plumbing Services, Electrical Engineering).</param>
/// <param name="RequiresManagerApproval">True if estimate is >= LKR 50,000 policy threshold.</param>
/// <param name="TriageSummary">Human-readable summary of classification and policy evaluation.</param>
public record TriageAndEstimateResultDto(
    Guid TicketId,
    MaintenancePriority Priority,
    MaintenanceStatus Status,
    decimal EstimatedCost,
    string SuggestedTradeCategory,
    bool RequiresManagerApproval,
    string TriageSummary
);
