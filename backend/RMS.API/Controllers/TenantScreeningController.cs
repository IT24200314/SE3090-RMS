// =================================================================================================
// File: TenantScreeningController.cs
// Module: Component B: Tenant Screening & Onboarding Management
// Student Contributor: Nethmi Seya (IT24200314 Group Member)
// Architecture: Presentation / API Layer - REST Controller for Tenant Screening & Risk Assessment
// Purpose: Exposes HTTP REST endpoints for tenant onboarding submissions, KYC identity verification,
//          and executing non-trivial deterministic financial viability and credit risk evaluations.
// =================================================================================================

using Microsoft.AspNetCore.Mvc;
using RMS.Core.DTOs;
using RMS.Core.Entities;
using RMS.Core.Interfaces;

namespace RMS.API.Controllers;

/// <summary>
/// RESTful controller managing tenant onboarding, KYC identity verification, and financial risk evaluation.
/// </summary>
[ApiController]
[Route("api/tenants")]
[Produces("application/json")]
public class TenantScreeningController : ControllerBase
{
    private readonly ITenantScreeningService _screeningService;

    public TenantScreeningController(ITenantScreeningService screeningService)
    {
        _screeningService = screeningService;
    }

    /// <summary>
    /// Submits a new rental onboarding application
    /// </summary>
    [HttpPost("applications")]
    [ProducesResponseType(typeof(ApplicationResponseDto), StatusCodes.Status201Created)]
    public async Task<IActionResult> SubmitApplication([FromBody] SubmitApplicationDto dto)
    {
        var result = await _screeningService.SubmitApplicationAsync(dto);
        return CreatedAtAction(nameof(GetApplicationById), new { id = result.Id }, result);
    }

    /// <summary>
    /// Retrieves a specific application by unique ID
    /// </summary>
    [HttpGet("applications/{id:guid}")]
    [ProducesResponseType(typeof(ApplicationResponseDto), StatusCodes.Status200OK)]
    public async Task<IActionResult> GetApplicationById(Guid id)
    {
        var result = await _screeningService.GetApplicationByIdAsync(id);
        return Ok(result);
    }

    /// <summary>
    /// Retrieves tenant applications filtered by screening status
    /// </summary>
    [HttpGet("applications")]
    [ProducesResponseType(typeof(IEnumerable<ApplicationResponseDto>), StatusCodes.Status200OK)]
    public async Task<IActionResult> GetApplications([FromQuery] ScreeningStatus? status)
    {
        var results = await _screeningService.GetApplicationsByStatusAsync(status);
        return Ok(results);
    }

    /// <summary>
    /// Updates and verifies KYC identity documents for an application
    /// </summary>
    [HttpPost("applications/{id:guid}/verify-docs")]
    [ProducesResponseType(typeof(ApplicationResponseDto), StatusCodes.Status200OK)]
    public async Task<IActionResult> VerifyDocument(Guid id, [FromBody] VerifyDocumentDto dto)
    {
        var result = await _screeningService.VerifyIdentityDocumentAsync(id, dto);
        return Ok(result);
    }

    /// <summary>
    /// Executes financial & risk screening evaluation (Business-Specific Operation)
    /// </summary>
    [HttpPost("applications/{id:guid}/evaluate-risk")]
    [ProducesResponseType(typeof(ScreeningEvaluationResultDto), StatusCodes.Status200OK)]
    public async Task<IActionResult> EvaluateRisk(Guid id)
    {
        var result = await _screeningService.EvaluateApplicationRiskAsync(id);
        return Ok(result);
    }
}
