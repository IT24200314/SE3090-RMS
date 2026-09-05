// =================================================================================================
// File: MaintenanceService.cs
// Module: Component C: Maintenance & Work-Order Operations
// Student Contributor: Hashini Wicramathilake (IT24200314 Group Member)
// Architecture: Infrastructure / Service Layer - Maintenance Operations & Automated Triage Business Logic
// Purpose: Implements ticket lifecycle operations, contractor job assignments, resolution handling,
//          heuristic trade categorization, and the LKR 50,000 policy threshold check for HITL approval.
// =================================================================================================

using Microsoft.EntityFrameworkCore;
using RMS.Core.DTOs;
using RMS.Core.Entities;
using RMS.Core.Exceptions;
using RMS.Core.Interfaces;
using RMS.Infrastructure.Data;

namespace RMS.Infrastructure.Services;

/// <summary>
/// Service implementing maintenance operations, heuristic triage, and threshold validations.
/// </summary>
public class MaintenanceService : IMaintenanceService
{
    private readonly AppDbContext _context;
    
    // Policy ceiling triggering Human-in-the-Loop manager financial approval (LKR 50,000)
    private const decimal HighCostThreshold = 50000m;

    public MaintenanceService(AppDbContext context)
    {
        _context = context;
    }

    /// <inheritdoc/>
    public async Task<MaintenanceTicketResponseDto> CreateTicketAsync(CreateMaintenanceTicketDto dto)
    {
        var property = await _context.Properties.FindAsync(dto.PropertyId)
            ?? throw new NotFoundException($"Property with ID '{dto.PropertyId}' was not found.");

        var ticket = new MaintenanceTicket
        {
            PropertyId = dto.PropertyId,
            TenantId = dto.TenantId,
            IssueDescription = dto.IssueDescription,
            PhotoUrl = dto.PhotoUrl,
            Priority = dto.Priority,
            Status = MaintenanceStatus.Open,
            EstimatedCost = 0
        };

        _context.MaintenanceTickets.Add(ticket);
        await _context.SaveChangesAsync();

        return MapToDto(ticket);
    }

    /// <inheritdoc/>
    public async Task<MaintenanceTicketResponseDto> GetTicketByIdAsync(Guid ticketId)
    {
        var ticket = await _context.MaintenanceTickets.FindAsync(ticketId)
            ?? throw new NotFoundException($"Maintenance ticket '{ticketId}' was not found.");

        return MapToDto(ticket);
    }

    /// <inheritdoc/>
    public async Task<IEnumerable<MaintenanceTicketResponseDto>> GetTicketsAsync(MaintenanceStatus? status, MaintenancePriority? priority)
    {
        var query = _context.MaintenanceTickets.AsNoTracking();

        if (status.HasValue)
        {
            query = query.Where(t => t.Status == status.Value);
        }

        if (priority.HasValue)
        {
            query = query.Where(t => t.Priority == priority.Value);
        }

        var tickets = await query.OrderByDescending(t => t.CreatedAtUtc).ToListAsync();
        return tickets.Select(MapToDto);
    }

    /// <inheritdoc/>
    public async Task<MaintenanceTicketResponseDto> AssignContractorAsync(Guid ticketId, AssignContractorDto dto)
    {
        var ticket = await _context.MaintenanceTickets.FindAsync(ticketId)
            ?? throw new NotFoundException($"Maintenance ticket '{ticketId}' was not found.");

        if (ticket.Status == MaintenanceStatus.PendingManagerApproval)
        {
            throw new InvalidBusinessOperationException("Cannot assign contractor while ticket is pending manager financial approval.");
        }

        ticket.AssignedContractorId = dto.ContractorId;
        ticket.EstimatedCost = dto.ApprovedBudget;
        ticket.Status = MaintenanceStatus.Assigned;
        ticket.UpdatedAtUtc = DateTime.UtcNow;

        await _context.SaveChangesAsync();
        return MapToDto(ticket);
    }

    /// <inheritdoc/>
    public async Task<MaintenanceTicketResponseDto> CompleteTicketAsync(Guid ticketId, CompleteTicketDto dto)
    {
        var ticket = await _context.MaintenanceTickets.FindAsync(ticketId)
            ?? throw new NotFoundException($"Maintenance ticket '{ticketId}' was not found.");

        if (ticket.Status != MaintenanceStatus.Assigned && ticket.Status != MaintenanceStatus.InProgress)
        {
            throw new InvalidBusinessOperationException("Ticket must be Assigned or In-Progress before marking as Resolved.");
        }

        ticket.Status = MaintenanceStatus.Resolved;
        ticket.EstimatedCost = dto.FinalCost;
        ticket.AiTriageSummary = $"{ticket.AiTriageSummary} | Resolution: {dto.CompletionNotes}";
        ticket.UpdatedAtUtc = DateTime.UtcNow;

        await _context.SaveChangesAsync();
        return MapToDto(ticket);
    }

    /// <inheritdoc/>
    public async Task<TriageAndEstimateResultDto> TriageAndEstimateCostAsync(Guid ticketId)
    {
        var ticket = await _context.MaintenanceTickets.FindAsync(ticketId)
            ?? throw new NotFoundException($"Maintenance ticket '{ticketId}' was not found.");

        var desc = ticket.IssueDescription.ToLowerInvariant();
        decimal estimatedCost;
        string tradeCategory;
        MaintenancePriority evaluatedPriority = ticket.Priority;

        // Domain heuristic classification & cost modeling
        if (desc.Contains("leak") || desc.Contains("pipe") || desc.Contains("drain") || desc.Contains("plumb"))
        {
            tradeCategory = "Plumbing Services";
            estimatedCost = desc.Contains("burst") || desc.Contains("flood") ? 65000m : 18000m;
            if (desc.Contains("burst")) evaluatedPriority = MaintenancePriority.Emergency;
        }
        else if (desc.Contains("spark") || desc.Contains("wiring") || desc.Contains("power") || desc.Contains("electric"))
        {
            tradeCategory = "Electrical Engineering";
            estimatedCost = desc.Contains("panel") || desc.Contains("short") ? 55000m : 22000m;
            if (desc.Contains("spark")) evaluatedPriority = MaintenancePriority.High;
        }
        else if (desc.Contains("roof") || desc.Contains("wall") || desc.Contains("structure") || desc.Contains("crack"))
        {
            tradeCategory = "Structural / Masonry";
            estimatedCost = 85000m; // High cost structural work
        }
        else
        {
            tradeCategory = "General Handyman";
            estimatedCost = 12000m;
        }

        bool requiresManagerApproval = estimatedCost >= HighCostThreshold;
        var newStatus = requiresManagerApproval ? MaintenanceStatus.PendingManagerApproval : MaintenanceStatus.Open;

        var triageSummary = $"Classified under '{tradeCategory}'. Estimated repair budget: LKR {estimatedCost:N2}. " +
                            (requiresManagerApproval 
                                ? $"[FLAGGED] Exceeds LKR {HighCostThreshold:N2} threshold. Paused for Human-in-the-Loop manager approval." 
                                : "[APPROVED] Within auto-approval limits.");

        ticket.Priority = evaluatedPriority;
        ticket.EstimatedCost = estimatedCost;
        ticket.Status = newStatus;
        ticket.AiTriageSummary = triageSummary;
        ticket.UpdatedAtUtc = DateTime.UtcNow;

        await _context.SaveChangesAsync();

        return new TriageAndEstimateResultDto(
            ticket.Id,
            ticket.Priority,
            ticket.Status,
            ticket.EstimatedCost,
            tradeCategory,
            requiresManagerApproval,
            triageSummary
        );
    }

    private static MaintenanceTicketResponseDto MapToDto(MaintenanceTicket ticket) =>
        new(
            ticket.Id,
            ticket.PropertyId,
            ticket.TenantId,
            ticket.IssueDescription,
            ticket.PhotoUrl,
            ticket.Priority,
            ticket.Status,
            ticket.EstimatedCost,
            ticket.AiTriageSummary,
            ticket.AssignedContractorId,
            ticket.CreatedAtUtc,
            ticket.UpdatedAtUtc
        );
}
