// =================================================================================================
// File: IThirdPartyIntegrationService.cs
// Module: RMS.Core / Third-Party Integration Abstraction Layer
// Student Contributors: Upamada Ekanayake, Nethmi Seya, Hashini Wicramathilake
// Purpose: Contract for resilient third-party integrations (Currency & Reverse Geocoding)
//          fulfilling Section 11 of the SE3090 Assignment 1 Specification.
// =================================================================================================

using RMS.Core.DTOs;

namespace RMS.Core.Interfaces;

/// <summary>
/// Service abstraction for external third-party API communication with resilient error handling,
/// timeout protection, rate-limit tolerance, and zero private credential leakage.
/// </summary>
public interface IThirdPartyIntegrationService
{
    /// <summary>
    /// Converts rental amounts in Sri Lankan Rupees (LKR) to foreign currencies (USD, EUR, GBP)
    /// to support expatriate tenants and international property investors.
    /// </summary>
    Task<CurrencyConversionResponseDto> ConvertLkrCurrencyAsync(CurrencyConversionRequestDto request);

    /// <summary>
    /// Reverse-geocodes GPS coordinates captured by the Flutter mobile app to verify
    /// that maintenance requests originate from verified Sri Lankan property coordinates.
    /// </summary>
    Task<ReverseGeocodeResponseDto> ReverseGeocodeLocationAsync(ReverseGeocodeRequestDto request);
}
