// =================================================================================================
// File: ThirdPartyController.cs
// Module: RMS.API / Third-Party Integration Gateway
// Student Contributors: Upamada Ekanayake, Nethmi Seya, Hashini Wicramathilake
// Architecture: Presentation / API Layer - REST Endpoints for External Service Integrations
// Purpose: Fulfills Section 11 of SE3090 Assignment 1 by routing all external third-party requests
//          (Currency Conversion & Location Geocoding) securely through the ASP.NET Core backend.
// =================================================================================================

using Microsoft.AspNetCore.Mvc;
using RMS.Core.DTOs;
using RMS.Core.Interfaces;

namespace RMS.API.Controllers;

/// <summary>
/// RESTful controller exposing third-party services (Currency conversion, Geocoding) through the backend.
/// </summary>
[ApiController]
[Route("api/external")]
[Produces("application/json")]
public class ThirdPartyController : ControllerBase
{
    private readonly IThirdPartyIntegrationService _thirdPartyService;

    public ThirdPartyController(IThirdPartyIntegrationService thirdPartyService)
    {
        _thirdPartyService = thirdPartyService;
    }

    /// <summary>
    /// Converts rental prices from LKR to foreign currencies (USD, EUR, GBP) for diaspora and expat clients.
    /// </summary>
    [HttpPost("currency/convert")]
    [ProducesResponseType(typeof(CurrencyConversionResponseDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<IActionResult> ConvertCurrency([FromBody] CurrencyConversionRequestDto request)
    {
        if (!ModelState.IsValid)
        {
            return BadRequest(ModelState);
        }

        var result = await _thirdPartyService.ConvertLkrCurrencyAsync(request);
        return Ok(result);
    }

    /// <summary>
    /// Reverse geocodes mobile GPS coordinates to verify physical property location.
    /// </summary>
    [HttpPost("location/reverse-geocode")]
    [ProducesResponseType(typeof(ReverseGeocodeResponseDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<IActionResult> ReverseGeocode([FromBody] ReverseGeocodeRequestDto request)
    {
        if (!ModelState.IsValid)
        {
            return BadRequest(ModelState);
        }

        var result = await _thirdPartyService.ReverseGeocodeLocationAsync(request);
        return Ok(result);
    }
}
