// =================================================================================================
// File: TenantScreeningServiceTests.cs
// Module: Component B Tests: Tenant Screening & Onboarding Management
// Student Contributor: Nethmi Seya (IT24200314 Group Member)
// Architecture: Automated Unit & Service Testing Layer (xUnit + InMemory EF Core)
// Purpose: Validates automated financial risk scoring, rent-to-income threshold policies (<=35% auto-approval,
//          35%-50% HITL manager review flag, >50% rejection), and KYC document attachments.
// =================================================================================================

using Microsoft.EntityFrameworkCore;
using RMS.Core.DTOs;
using RMS.Core.Entities;
using RMS.Infrastructure.Data;
using RMS.Infrastructure.Services;
using Xunit;

namespace RMS.Tests;

/// <summary>
/// Unit and integration test suite for Tenant Screening and automated risk scoring engine.
/// </summary>
public class TenantScreeningServiceTests
{
    private static AppDbContext CreateInMemoryDbContext()
    {
        var options = new DbContextOptionsBuilder<AppDbContext>()
            .UseInMemoryDatabase(databaseName: $"RMS_Test_Screening_{Guid.NewGuid()}")
            .Options;

        return new AppDbContext(options);
    }

    [Fact]
    public async Task EvaluateApplicationRiskAsync_LowRentToIncomeRatio_AutoApprovesWithHighRiskScore()
    {
        // Arrange
        using var context = CreateInMemoryDbContext();
        var service = new TenantScreeningService(context);

        var property = new Property
        {
            Title = "Suburban Villa",
            Address = "12 Main St",
            MonthlyRent = 50000m,
            Status = PropertyStatus.Available,
            LandlordId = Guid.NewGuid()
        };
        context.Properties.Add(property);
        await context.SaveChangesAsync();

        var app = new TenantApplication
        {
            TenantId = Guid.NewGuid(),
            PropertyId = property.Id,
            MonthlyIncome = 250000m, // Rent is 20% of income (<= 35%)
            IdentityDocUrl = "https://docs.rms.local/kyc/id_01.pdf",
            Status = ScreeningStatus.Pending
        };
        context.TenantApplications.Add(app);
        await context.SaveChangesAsync();

        // Act
        var result = await service.EvaluateApplicationRiskAsync(app.Id);

        // Assert
        Assert.NotNull(result);
        Assert.Equal(ScreeningStatus.Approved, result.Status);
        Assert.Equal(92, result.AiRiskScore);
        Assert.False(result.RequiresManagerApproval);
        Assert.Equal(20.00m, result.RentToIncomeRatio);
    }

    [Fact]
    public async Task EvaluateApplicationRiskAsync_ModerateRentToIncomeRatio_FlagsForManagerReview()
    {
        // Arrange
        using var context = CreateInMemoryDbContext();
        var service = new TenantScreeningService(context);

        var property = new Property
        {
            Title = "City Apartment",
            Address = "88 Galle Road",
            MonthlyRent = 80000m,
            Status = PropertyStatus.Available,
            LandlordId = Guid.NewGuid()
        };
        context.Properties.Add(property);
        await context.SaveChangesAsync();

        var app = new TenantApplication
        {
            TenantId = Guid.NewGuid(),
            PropertyId = property.Id,
            MonthlyIncome = 200000m, // Rent is 40% of income (between 35% and 50%)
            IdentityDocUrl = "https://docs.rms.local/kyc/id_02.pdf",
            Status = ScreeningStatus.Pending
        };
        context.TenantApplications.Add(app);
        await context.SaveChangesAsync();

        // Act
        var result = await service.EvaluateApplicationRiskAsync(app.Id);

        // Assert
        Assert.NotNull(result);
        Assert.Equal(ScreeningStatus.ReviewRequired, result.Status);
        Assert.Equal(65, result.AiRiskScore);
        Assert.True(result.RequiresManagerApproval);
        Assert.Equal(40.00m, result.RentToIncomeRatio);
    }

    [Fact]
    public async Task EvaluateApplicationRiskAsync_HighRentToIncomeRatio_RejectsApplication()
    {
        // Arrange
        using var context = CreateInMemoryDbContext();
        var service = new TenantScreeningService(context);

        var property = new Property
        {
            Title = "Penthouse Suite",
            Address = "10 Ocean View",
            MonthlyRent = 120000m,
            Status = PropertyStatus.Available,
            LandlordId = Guid.NewGuid()
        };
        context.Properties.Add(property);
        await context.SaveChangesAsync();

        var app = new TenantApplication
        {
            TenantId = Guid.NewGuid(),
            PropertyId = property.Id,
            MonthlyIncome = 150000m, // Rent is 80% of income (> 50%)
            IdentityDocUrl = "https://docs.rms.local/kyc/id_03.pdf",
            Status = ScreeningStatus.Pending
        };
        context.TenantApplications.Add(app);
        await context.SaveChangesAsync();

        // Act
        var result = await service.EvaluateApplicationRiskAsync(app.Id);

        // Assert
        Assert.NotNull(result);
        Assert.Equal(ScreeningStatus.Rejected, result.Status);
        Assert.Equal(35, result.AiRiskScore);
        Assert.False(result.RequiresManagerApproval);
        Assert.Equal(80.00m, result.RentToIncomeRatio);
    }
}
