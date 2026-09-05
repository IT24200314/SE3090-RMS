// =================================================================================================
// File: MaintenanceController.cs
// Module: Component C: Maintenance & Work-Order Operations
// Student Contributor: Hashini Wicramathilake (IT24200314 Group Member)
// Architecture: Presentation / API Layer - REST Controller for Maintenance & Contractor Dispatch
// Purpose: Exposes HTTP REST endpoints for tenant maintenance ticket logging, contractor dispatching,
//          job completion, and non-trivial automated trade categorization and cost threshold validation.
// =================================================================================================

using Microsoft.AspNetCore.Mvc;
using RMS.Core.DTOs;
using RMS.Core.Entities;
using RMS.Core.Interfaces;

namespace RMS.API.Controllers;

/// <summary>
/// RESTful controller managing maintenance service requests, contractor assignment, and automated triage.
/// </summary>
[ApiController]
[Route("api/maintenance")]
[Produces("application/json")]
public class MaintenanceController : ControllerBase
{
    private readonly IMaintenanceService _maintenanceService;

    public MaintenanceController(IMaintenanceService maintenanceService)
    {
        _maintenanceService = maintenanceService;
    }

    /// <summary>
    /// Creates a new tenant maintenance request ticket
    /// </summary>
    [HttpPost("tickets")]
    [ProducesResponseType(typeof(MaintenanceTicketResponseDto), StatusCodes.Status201Created)]
    public async Task<IActionResult> CreateTicket([FromBody] CreateMaintenanceTicketDto dto)
    {
        var result = await _maintenanceService.CreateTicketAsync(dto);
        return CreatedAtAction(nameof(GetTicketById), new { id = result.Id }, result);
    }

    /// <summary>
    /// Retrieves a maintenance ticket by ID
    /// </summary>
    [HttpGet("tickets/{id:guid}")]
    [ProducesResponseType(typeof(MaintenanceTicketResponseDto), StatusCodes.Status200OK)]
    public async Task<IActionResult> GetTicketById(Guid id)
    {
        var result = await _maintenanceService.GetTicketByIdAsync(id);
        return Ok(result);
    }

    /// <summary>
    /// Retrieves maintenance tickets filtered by status and priority
    /// </summary>
    [HttpGet("tickets")]
    [ProducesResponseType(typeof(IEnumerable<MaintenanceTicketResponseDto>), StatusCodes.Status200OK)]
    public async Task<IActionResult> GetTickets(
        [FromQuery] MaintenanceStatus? status,
        [FromQuery] MaintenancePriority? priority)
    {
        var results = await _maintenanceService.GetTicketsAsync(status, priority);
        return Ok(results);
    }

    /// <summary>
    /// Assigns a maintenance contractor and sets approved budget
    /// </summary>
    [HttpPut("tickets/{id:guid}/assign")]
    [ProducesResponseType(typeof(MaintenanceTicketResponseDto), StatusCodes.Status200OK)]
    public async Task<IActionResult> AssignContractor(Guid id, [FromBody] AssignContractorDto dto)
    {
        var result = await _maintenanceService.AssignContractorAsync(id, dto);
        return Ok(result);
    }

    /// <summary>
    /// Marks a maintenance ticket as resolved with completion summary
    /// </summary>
    [HttpPut("tickets/{id:guid}/complete")]
    [ProducesResponseType(typeof(MaintenanceTicketResponseDto), StatusCodes.Status200OK)]
    public async Task<IActionResult> CompleteTicket(Guid id, [FromBody] CompleteTicketDto dto)
    {
        var result = await _maintenanceService.CompleteTicketAsync(id, dto);
        return Ok(result);
    }

    /// <summary>
    /// Executes automated triage, cost estimation, and threshold validation (Business-Specific Operation)
    /// </summary>
    [HttpPost("tickets/{id:guid}/triage-and-estimate")]
    [ProducesResponseType(typeof(TriageAndEstimateResultDto), StatusCodes.Status200OK)]
    public async Task<IActionResult> TriageAndEstimate(Guid id)
    {
        var result = await _maintenanceService.TriageAndEstimateCostAsync(id);
        return Ok(result);
    }
}
