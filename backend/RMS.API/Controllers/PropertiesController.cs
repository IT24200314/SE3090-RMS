// =================================================================================================
// File: PropertiesController.cs
// Module: Component A: Property Listing & Lease Lifecycle Management
// Student Contributor: Upamada Ekanayake (Group Leader - IT24200314)
// Architecture: Presentation / API Layer - REST Controller for Property Listings
// Purpose: Exposes HTTP REST endpoints for registering property inventory, paginated search,
//          and individual listing retrieval, adhering to strict RESTful URL and status conventions.
// =================================================================================================

using Microsoft.AspNetCore.Mvc;
using RMS.Core.DTOs;
using RMS.Core.Interfaces;

namespace RMS.API.Controllers;

/// <summary>
/// RESTful controller managing real-estate property listings.
/// </summary>
[ApiController]
[Route("api/[controller]")]
public class PropertiesController : ControllerBase
{
    private readonly IPropertyLeaseService _propertyLeaseService;

    public PropertiesController(IPropertyLeaseService propertyLeaseService)
    {
        _propertyLeaseService = propertyLeaseService;
    }

    /// <summary>
    /// Creates a new property listing.
    /// </summary>
    /// <param name="dto">Property listing creation payload.</param>
    /// <returns>Created property details.</returns>
    [HttpPost]
    [ProducesResponseType(typeof(PropertyResponseDto), StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<IActionResult> CreateProperty([FromBody] CreatePropertyDto dto)
    {
        try
        {
            var created = await _propertyLeaseService.CreatePropertyAsync(dto);
            return CreatedAtAction(nameof(GetPropertyById), new { id = created.Id }, created);
        }
        catch (ArgumentException ex)
        {
            return BadRequest(new { message = ex.Message });
        }
    }

    /// <summary>
    /// Searches and retrieves a paginated list of properties.
    /// </summary>
    /// <param name="search">Optional text filter for title or address.</param>
    /// <param name="page">Page number (default 1).</param>
    /// <param name="pageSize">Items per page (default 10).</param>
    /// <returns>List of matching properties.</returns>
    [HttpGet]
    [ProducesResponseType(typeof(IEnumerable<PropertyResponseDto>), StatusCodes.Status200OK)]
    public async Task<IActionResult> GetProperties([FromQuery] string? search, [FromQuery] int page = 1, [FromQuery] int pageSize = 10)
    {
        var properties = await _propertyLeaseService.GetPropertiesAsync(search, page, pageSize);
        return Ok(properties);
    }

    /// <summary>
    /// Retrieves a single property listing by ID.
    /// </summary>
    /// <param name="id">Property unique identifier.</param>
    /// <returns>Property details.</returns>
    [HttpGet("{id:guid}")]
    [ProducesResponseType(typeof(PropertyResponseDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> GetPropertyById(Guid id)
    {
        try
        {
            var property = await _propertyLeaseService.GetPropertyByIdAsync(id);
            return Ok(property);
        }
        catch (KeyNotFoundException ex)
        {
            return NotFound(new { message = ex.Message });
        }
    }
}
