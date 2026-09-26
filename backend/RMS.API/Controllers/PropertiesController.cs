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
            // 1. Pass the validated DTO to the PropertyLeaseService to handle entity creation and persistence
            var created = await _propertyLeaseService.CreatePropertyAsync(dto);

            // 2. Return HTTP 201 Created with Location header pointing to GetPropertyById and created object body
            return CreatedAtAction(nameof(GetPropertyById), new { id = created.Id }, created);
        }
        catch (ArgumentException ex)
        {
            // Return HTTP 400 Bad Request if validation rules fail (e.g., negative rent or missing title)
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
        // Query database via service with text search filter and pagination limits
        var properties = await _propertyLeaseService.GetPropertiesAsync(search, page, pageSize);

        // Return HTTP 200 OK with list of properties
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
            // Look up property by unique Guid in PostgreSQL database
            var property = await _propertyLeaseService.GetPropertyByIdAsync(id);

            // Return HTTP 200 OK with matching property details
            return Ok(property);
        }
        catch (KeyNotFoundException ex)
        {
            // Return HTTP 404 Not Found if no property exists with the requested Guid
            return NotFound(new { message = ex.Message });
        }
    }
}
