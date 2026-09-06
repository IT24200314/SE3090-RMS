// =================================================================================================
// File: PropertyLeaseServiceTests.cs
// Module: Component A Tests: Property Listing & Lease Lifecycle Management
// Student Contributor: Upamada Ekanayake (Group Leader - IT24200314)
// Architecture: Automated Unit & Service Testing Layer (xUnit + InMemory EF Core)
// Purpose: Validates property creation constraints, lease agreement drafting state transitions,
//          and early termination rollback mechanics restoring property availability.
// =================================================================================================

using Microsoft.EntityFrameworkCore;
using RMS.Core.DTOs;
using RMS.Core.Entities;
using RMS.Infrastructure.Data;
using RMS.Infrastructure.Services;
using Xunit;

namespace RMS.Tests;

/// <summary>
/// Unit and integration test suite for Property and Lease lifecycle business logic.
/// </summary>
public class PropertyLeaseServiceTests
{
    private static AppDbContext CreateInMemoryDbContext()
    {
        var options = new DbContextOptionsBuilder<AppDbContext>()
            .UseInMemoryDatabase(databaseName: $"RMS_Test_PropLease_{Guid.NewGuid()}")
            .Options;

        return new AppDbContext(options);
    }

    [Fact]
    public async Task CreatePropertyAsync_ValidDto_ReturnsCreatedProperty()
    {
        // Arrange
        using var context = CreateInMemoryDbContext();
        var service = new PropertyLeaseService(context);
        var landlordId = Guid.NewGuid();
        var dto = new CreatePropertyDto("Luxury Apartment", "2 Bedroom sea view", "123 Marine Drive, Colombo", 150000m, 300000m, landlordId);

        // Act
        var result = await service.CreatePropertyAsync(dto);

        // Assert
        Assert.NotNull(result);
        Assert.Equal(dto.Title, result.Title);
        Assert.Equal(PropertyStatus.Available, result.Status);
        Assert.Equal(150000m, result.MonthlyRent);
    }

    [Fact]
    public async Task GenerateLeaseAgreementAsync_AvailableProperty_CreatesLeaseAndMarksOccupied()
    {
        // Arrange
        using var context = CreateInMemoryDbContext();
        var service = new PropertyLeaseService(context);
        var property = new Property
        {
            Title = "Studio Flat",
            Description = "Cozy studio",
            Address = "45 Rosemead Place",
            MonthlyRent = 80000m,
            SecurityDeposit = 160000m,
            Status = PropertyStatus.Available,
            LandlordId = Guid.NewGuid()
        };
        context.Properties.Add(property);
        await context.SaveChangesAsync();

        var tenantId = Guid.NewGuid();
        var leaseDto = new CreateLeaseDto(
            property.Id, 
            tenantId, 
            DateTime.UtcNow, 
            DateTime.UtcNow.AddMonths(12), 
            80000m, 
            "Standard Residential Lease Clauses"
        );

        // Act
        var leaseResponse = await service.GenerateLeaseAgreementAsync(leaseDto);

        // Assert
        Assert.NotNull(leaseResponse);
        Assert.Equal(LeaseStatus.PendingSignature, leaseResponse.Status);
        Assert.Equal(property.Id, leaseResponse.PropertyId);

        // Verify property occupancy update
        var updatedProperty = await context.Properties.FindAsync(property.Id);
        Assert.NotNull(updatedProperty);
        Assert.Equal(PropertyStatus.Occupied, updatedProperty.Status);
    }

    [Fact]
    public async Task TerminateLeaseAsync_ActiveLease_TerminatesAndRestoresPropertyToAvailable()
    {
        // Arrange
        using var context = CreateInMemoryDbContext();
        var service = new PropertyLeaseService(context);
        var property = new Property
        {
            Title = "Townhouse",
            Description = "3 Storey townhouse",
            Address = "78 Flower Road",
            MonthlyRent = 200000m,
            SecurityDeposit = 400000m,
            Status = PropertyStatus.Occupied,
            LandlordId = Guid.NewGuid()
        };
        context.Properties.Add(property);
        await context.SaveChangesAsync();

        var lease = new Lease
        {
            PropertyId = property.Id,
            TenantId = Guid.NewGuid(),
            StartDate = DateTime.UtcNow.AddMonths(-6),
            EndDate = DateTime.UtcNow.AddMonths(6),
            AgreedRent = 200000m,
            Status = LeaseStatus.Active
        };
        context.Leases.Add(lease);
        await context.SaveChangesAsync();

        // Act
        var terminated = await service.TerminateLeaseAsync(lease.Id, "Tenant relocation requested early termination");

        // Assert
        Assert.NotNull(terminated);
        Assert.Equal(LeaseStatus.Terminated, terminated.Status);

        var restoredProperty = await context.Properties.FindAsync(property.Id);
        Assert.NotNull(restoredProperty);
        Assert.Equal(PropertyStatus.Available, restoredProperty.Status);
    }
}
