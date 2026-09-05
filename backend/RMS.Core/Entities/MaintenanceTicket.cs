// =================================================================================================
// File: MaintenanceTicket.cs
// Module: Component C: Maintenance & Work-Order Operations
// Student Contributor: Hashini Wicramathilake (IT24200314 Group Member)
// Architecture: Core Domain Layer - Maintenance Work Order & Triage Entities
// Purpose: Models maintenance tickets, photos, priority levels, estimated repair budgets,
//          and Human-in-the-Loop approval triggers for high-cost jobs (>= LKR 50,000).
// =================================================================================================

namespace RMS.Core.Entities;

/// <summary>
/// Urgency classification level for maintenance service requests.
/// </summary>
public enum MaintenancePriority
{
    /// <summary>Non-urgent cosmetic or minor convenience issue.</summary>
    Low,
    /// <summary>Standard maintenance issue requiring attention within standard turnaround time.</summary>
    Medium,
    /// <summary>Urgent malfunction affecting core amenities or security.</summary>
    High,
    /// <summary>Critical hazard (e.g. burst pipe, electrical fire hazard, gas leak) requiring immediate action.</summary>
    Emergency
}

/// <summary>
/// Lifecycle status of a maintenance ticket throughout triage, contractor dispatch, and resolution.
/// </summary>
public enum MaintenanceStatus
{
    /// <summary>Newly logged ticket awaiting triage or contractor assignment.</summary>
    Open,
    /// <summary>Certified contractor assigned and work order issued.</summary>
    Assigned,
    /// <summary>Paused for Human-in-the-Loop review because estimated cost exceeds LKR 50,000 ceiling.</summary>
    PendingManagerApproval,
    /// <summary>Contractor is on-site or actively performing repairs.</summary>
    InProgress,
    /// <summary>Work completed, inspected, and invoice settled.</summary>
    Resolved
}

/// <summary>
/// Domain entity representing a tenant-reported property maintenance or repair ticket.
/// </summary>
public class MaintenanceTicket : BaseEntity
{
    /// <summary>Unique identifier of the property unit requiring maintenance.</summary>
    public Guid PropertyId { get; set; }

    /// <summary>Unique identifier of the tenant reporting the issue.</summary>
    public Guid TenantId { get; set; }

    /// <summary>Detailed description of the defect or issue observed.</summary>
    public string IssueDescription { get; set; } = string.Empty;

    /// <summary>Secure URL / path to the captured photo evidence.</summary>
    public string PhotoUrl { get; set; } = string.Empty;

    /// <summary>Priority level assigned during submission or auto-triage.</summary>
    public MaintenancePriority Priority { get; set; } = MaintenancePriority.Medium;

    /// <summary>Current operational status of the ticket.</summary>
    public MaintenanceStatus Status { get; set; } = MaintenanceStatus.Open;

    /// <summary>Estimated repair budget in LKR determined by AI heuristic triage or contractor quote.</summary>
    public decimal EstimatedCost { get; set; }

    /// <summary>AI-generated triage justification, trade classification, and approval audit notes.</summary>
    public string? AiTriageSummary { get; set; }

    /// <summary>Identifier of the contractor assigned to execute this job.</summary>
    public Guid? AssignedContractorId { get; set; }
}
