// =================================================================================================
// File: IMaintenanceService.cs
// Module: Component C: Maintenance & Work-Order Operations
// Student Contributor: Hashini Wicramathilake (IT24200314 Group Member)
// Architecture: Core Layer - Interface contract for maintenance tickets & triage operations
// Purpose: Declares contracts for maintenance ticket logging, contractor dispatching, completion,
//          and automated triage with trade classification and LKR 50,000 threshold enforcement.
// =================================================================================================

using RMS.Core.DTOs;
using RMS.Core.Entities;

namespace RMS.Core.Interfaces;

/// <summary>
/// Service interface handling Maintenance ticket lifecycle, contractor dispatch, and automated triage.
/// </summary>
public interface IMaintenanceService
{
    /// <summary>
    /// Creates a new maintenance ticket reported by tenant.
    /// </summary>
    /// <param name="dto">Ticket creation parameters with description and photo URL.</param>
    /// <returns>Created maintenance ticket response.</returns>
    Task<MaintenanceTicketResponseDto> CreateTicketAsync(CreateMaintenanceTicketDto dto);

    /// <summary>
    /// Retrieves a maintenance ticket by ID.
    /// </summary>
    /// <param name="ticketId">Unique ticket GUID.</param>
    /// <returns>Ticket response DTO.</returns>
    Task<MaintenanceTicketResponseDto> GetTicketByIdAsync(Guid ticketId);

    /// <summary>
    /// Retrieves tickets filtered by status and priority.
    /// </summary>
    /// <param name="status">Optional status filter.</param>
    /// <param name="priority">Optional priority filter.</param>
    /// <returns>Collection of matching tickets.</returns>
    Task<IEnumerable<MaintenanceTicketResponseDto>> GetTicketsAsync(MaintenanceStatus? status, MaintenancePriority? priority);

    /// <summary>
    /// Assigns a licensed contractor with approved budget.
    /// </summary>
    /// <param name="ticketId">Unique ticket GUID.</param>
    /// <param name="dto">Contractor ID and allocated budget.</param>
    /// <returns>Updated ticket response DTO.</returns>
    Task<MaintenanceTicketResponseDto> AssignContractorAsync(Guid ticketId, AssignContractorDto dto);

    /// <summary>
    /// Resolves and completes a maintenance ticket with final invoice cost.
    /// </summary>
    /// <param name="ticketId">Unique ticket GUID.</param>
    /// <param name="dto">Resolution notes and final cost in LKR.</param>
    /// <returns>Completed ticket response DTO.</returns>
    Task<MaintenanceTicketResponseDto> CompleteTicketAsync(Guid ticketId, CompleteTicketDto dto);
    
    /// <summary>
    /// Non-Trivial Business-Specific Operation: Evaluates repair urgency, estimates cost, classifies trade, and pauses high-cost repairs (>= LKR 50,000) for Human-in-the-Loop manager approval.
    /// </summary>
    /// <param name="ticketId">Unique ticket GUID.</param>
    /// <returns>Triage and cost estimation result DTO.</returns>
    Task<TriageAndEstimateResultDto> TriageAndEstimateCostAsync(Guid ticketId);
}
