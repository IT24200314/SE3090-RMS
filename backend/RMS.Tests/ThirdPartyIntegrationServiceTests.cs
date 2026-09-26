// =================================================================================================
// File: ThirdPartyIntegrationServiceTests.cs
// Module: RMS.Tests / Section 11 Third-Party Integration Testing
// Student Contributors: Upamada Ekanayake, Nethmi Seya, Hashini Wicramathilake
// Purpose: Verifies currency conversion calculation and reverse geocoding boundary checks
//          under resilient fallback and network timeout simulation conditions.
// =================================================================================================

using System.Net.Http;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging.Abstractions;
using RMS.Core.DTOs;
using RMS.Infrastructure.Services;
using Xunit;

namespace RMS.Tests;

/// <summary>
/// Lightweight HTTP client factory stub for testing without external mock frameworks.
/// </summary>
public class TestHttpClientFactory : IHttpClientFactory
{
    public HttpClient CreateClient(string name) => new HttpClient();
}

public class ThirdPartyIntegrationServiceTests
{
    private readonly IHttpClientFactory _clientFactory;
    private readonly IConfiguration _configuration;

    public ThirdPartyIntegrationServiceTests()
    {
        _clientFactory = new TestHttpClientFactory();
        _configuration = new ConfigurationBuilder().Build();
    }

    [Fact]
    public async Task ConvertLkrCurrencyAsync_ValidLkrAmount_ReturnsConvertedAmountWithRate()
    {
        // Arrange
        var service = new ThirdPartyIntegrationService(
            _clientFactory,
            NullLogger<ThirdPartyIntegrationService>.Instance,
            _configuration);

        var request = new CurrencyConversionRequestDto
        {
            AmountLkr = 150000m,
            TargetCurrency = "USD"
        };

        // Act
        var result = await service.ConvertLkrCurrencyAsync(request);

        // Assert
        Assert.NotNull(result);
        Assert.Equal(150000m, result.OriginalAmountLkr);
        Assert.Equal("USD", result.TargetCurrency);
        Assert.True(result.ConvertedAmount > 0, "Converted amount should be greater than zero.");
        Assert.True(result.ExchangeRate > 0, "Exchange rate should be positive.");
    }

    [Fact]
    public async Task ReverseGeocodeLocationAsync_CoordinatesInsideSriLanka_IdentifiesSriLankanLocation()
    {
        // Arrange
        var service = new ThirdPartyIntegrationService(
            _clientFactory,
            NullLogger<ThirdPartyIntegrationService>.Instance,
            _configuration);

        // Colombo Galle Face coordinates
        var request = new ReverseGeocodeRequestDto
        {
            Latitude = 6.9271,
            Longitude = 79.8612
        };

        // Act
        var result = await service.ReverseGeocodeLocationAsync(request);

        // Assert
        Assert.NotNull(result);
        Assert.True(result.VerifiedInSriLanka, "Coordinates should be identified as within Sri Lanka boundaries.");
        Assert.Equal("Sri Lanka", result.Country);
        Assert.NotEmpty(result.DisplayName);
    }
}
