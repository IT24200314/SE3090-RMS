// =================================================================================================
// File: LeasesController.cs
// Module: Component A: Property Listing & Lease Lifecycle Management
// Student Contributor: Upamada Ekanayake (Group Leader - IT24200314)
// Architecture: Presentation / API Layer - REST Controller for Lease Lifecycle Management
// Purpose: Exposes HTTP REST endpoints for drafting lease contracts and executing non-trivial
//          early lease terminations that transition contract state and release property occupancy.
// =================================================================================================

using Microsoft.AspNetCore.Mvc;
using RMS.Core.DTOs;
using RMS.Core.Interfaces;

namespace RMS.API.Controllers;

/// <summary>
/// RESTful controller managing residential lease contracts and lifecycle state transitions.
/// </summary>
[ApiController]
[Route("api/[controller]")]
public class LeasesController : ControllerBase
{
    private readonly IPropertyLeaseService _propertyLeaseService;

    public LeasesController(IPropertyLeaseService propertyLeaseService)
    {
        _propertyLeaseService = propertyLeaseService;
    }

    /// <summary>
    /// Generates and drafts a lease agreement contract.
    /// </summary>
    /// <param name="dto">Lease creation payload.</param>
    /// <returns>Drafted lease response.</returns>
    [HttpPost]
    [ProducesResponseType(typeof(LeaseResponseDto), StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> GenerateLeaseAgreement([FromBody] CreateLeaseDto dto)
    {
        try
        {
            // 1. Pass draft lease details to service to verify property availability and mark property Occupied
            var lease = await _propertyLeaseService.GenerateLeaseAgreementAsync(dto);

            // 2. Return HTTP 201 Created with the drafted lease contract details
            return StatusCode(StatusCodes.Status201Created, lease);
        }
        catch (KeyNotFoundException ex)
        {
            // Return HTTP 404 if the target property does not exist
            return NotFound(new { message = ex.Message });
        }
        catch (InvalidOperationException ex)
        {
            // Return HTTP 400 if the property is already occupied or under maintenance
            return BadRequest(new { message = ex.Message });
        }
        catch (ArgumentException ex)
        {
            // Return HTTP 400 if dates or agreed rent values are invalid
            return BadRequest(new { message = ex.Message });
        }
    }

    /// <summary>
    /// Terminates an active or pending lease agreement with status checks and property release.
    /// </summary>
    /// <param name="id">The unique ID of the lease.</param>
    /// <param name="dto">Reason for termination.</param>
    /// <returns>Updated lease details.</returns>
    [HttpPut("{id:guid}/terminate")]
    [ProducesResponseType(typeof(LeaseResponseDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> TerminateLease([FromRoute] Guid id, [FromBody] TerminateLeaseDto dto)
    {
        try
        {
            // 1. Execute early lease termination: sets Lease status to Terminated and resets Property status to Available
            var result = await _propertyLeaseService.TerminateLeaseAsync(id, dto.TerminationReason);

            // 2. Return HTTP 200 OK with updated lease details
            return Ok(result);
        }
        catch (KeyNotFoundException ex)
        {
            // Return HTTP 404 if lease record is not found
            return NotFound(new { message = ex.Message });
        }
        catch (InvalidOperationException ex)
        {
            // Return HTTP 400 if lease is already terminated or expired
            return BadRequest(new { message = ex.Message });
        }
    }
}
