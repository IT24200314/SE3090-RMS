// =================================================================================================
// File: ThirdPartyDtos.cs
// Module: RMS.Core / Third-Party Integration DTOs
// Student Contributors: Upamada Ekanayake, Nethmi Seya, Hashini Wicramathilake
// Purpose: Defines request and response models for external currency conversion and reverse geocoding
//          third-party services, adhering to minimal data sharing and zero sensitive data exposure.
// =================================================================================================

using System.ComponentModel.DataAnnotations;

namespace RMS.Core.DTOs;

/// <summary>
/// Request model for converting Sri Lankan Rupees (LKR) to foreign currencies.
/// </summary>
public class CurrencyConversionRequestDto
{
    /// <summary>Amount in Sri Lankan Rupees (LKR) to convert.</summary>
    [Range(0.01, 100000000.00, ErrorMessage = "Amount must be greater than zero.")]
    public decimal AmountLkr { get; set; }

    /// <summary>Target currency code (e.g., USD, EUR, GBP, AUD, SGD).</summary>
    [Required(ErrorMessage = "Target currency code is required.")]
    [StringLength(3, MinimumLength = 3, ErrorMessage = "Currency code must be exactly 3 uppercase letters.")]
    public string TargetCurrency { get; set; } = "USD";
}

/// <summary>
/// Response model containing calculated currency conversion with audit metadata.
/// </summary>
public class CurrencyConversionResponseDto
{
    public decimal OriginalAmountLkr { get; set; }
    public string TargetCurrency { get; set; } = "USD";
    public decimal ConvertedAmount { get; set; }
    public decimal ExchangeRate { get; set; }
    public string Provider { get; set; } = "ExchangeRate-API / Resilient Fallback";
    public DateTime FetchedAtUtc { get; set; } = DateTime.UtcNow;
    public bool IsFallbackRate { get; set; }
}

/// <summary>
/// Request model for reverse geocoding device coordinates to a physical address.
/// </summary>
public class ReverseGeocodeRequestDto
{
    /// <summary>GPS Latitude recorded by Flutter mobile client.</summary>
    [Range(-90.0, 90.0, ErrorMessage = "Latitude must be between -90 and 90.")]
    public double Latitude { get; set; }

    /// <summary>GPS Longitude recorded by Flutter mobile client.</summary>
    [Range(-180.0, 180.0, ErrorMessage = "Longitude must be between -180 and 180.")]
    public double Longitude { get; set; }
}

/// <summary>
/// Response model returning verified physical location without exposing private device telemetry.
/// </summary>
public class ReverseGeocodeResponseDto
{
    public double Latitude { get; set; }
    public double Longitude { get; set; }
    public string DisplayName { get; set; } = string.Empty;
    public string City { get; set; } = string.Empty;
    public string Suburb { get; set; } = string.Empty;
    public string Country { get; set; } = "Sri Lanka";
    public string Provider { get; set; } = "OpenStreetMap Nominatim";
    public bool VerifiedInSriLanka { get; set; }
}
