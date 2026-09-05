// =================================================================================================
// File: MaintenanceServiceTests.cs
// Module: Component C Tests: Maintenance & Work-Order Operations
// Student Contributor: Hashini Wicramathilake (IT24200314 Group Member)
// Architecture: Automated Unit & Service Testing Layer (xUnit + InMemory EF Core)
// Purpose: Validates automated triage heuristic classification, emergency burst pipe escalation,
//          the LKR 50,000 policy threshold check pausing for HITL review, and contractor completion.
// =================================================================================================

using Microsoft.EntityFrameworkCore;
using RMS.Core.DTOs;
using RMS.Core.Entities;
using RMS.Infrastructure.Data;
using RMS.Infrastructure.Services;
using Xunit;

namespace RMS.Tests;

/// <summary>
/// Unit and integration test suite for Maintenance ticket triage, cost estimation, and contractor assignment.
/// </summary>
public class MaintenanceServiceTests
{
    private static AppDbContext CreateInMemoryDbContext()
    {
        var options = new DbContextOptionsBuilder<AppDbContext>()
            .UseInMemoryDatabase(databaseName: $"RMS_Test_Maintenance_{Guid.NewGuid()}")
            .Options;

        return new AppDbContext(options);
    }

    [Fact]
    public async Task TriageAndEstimateCostAsync_BurstPipeIssue_ClassifiesEmergencyAndExceedsThreshold()
    {
        // Arrange
        using var context = CreateInMemoryDbContext();
        var service = new MaintenanceService(context);

        var property = new Property
        {
            Title = "Garden House",
            Address = "15 Park Lane",
            MonthlyRent = 70000m,
            LandlordId = Guid.NewGuid()
        };
        context.Properties.Add(property);
        await context.SaveChangesAsync();

        var ticket = new MaintenanceTicket
        {
            PropertyId = property.Id,
            TenantId = Guid.NewGuid(),
            IssueDescription = "Burst pipe flooding kitchen floor with water leak everywhere",
            PhotoUrl = "https://cdn.rms.local/photos/leak_01.jpg",
            Priority = MaintenancePriority.Medium,
            Status = MaintenanceStatus.Open
        };
        context.MaintenanceTickets.Add(ticket);
        await context.SaveChangesAsync();

        // Act
        var triageResult = await service.TriageAndEstimateCostAsync(ticket.Id);

        // Assert
        Assert.NotNull(triageResult);
        Assert.Equal("Plumbing Services", triageResult.SuggestedTradeCategory);
        Assert.Equal(MaintenancePriority.Emergency, triageResult.Priority);
        Assert.Equal(65000m, triageResult.EstimatedCost);
        Assert.True(triageResult.RequiresManagerApproval); // >= 50,000 threshold
        Assert.Equal(MaintenanceStatus.PendingManagerApproval, triageResult.Status);
    }

    [Fact]
    public async Task TriageAndEstimateCostAsync_MinorElectricIssue_AutoApprovesBelowThreshold()
    {
        // Arrange
        using var context = CreateInMemoryDbContext();
        var service = new MaintenanceService(context);

        var property = new Property
        {
            Title = "Garden House",
            Address = "15 Park Lane",
            MonthlyRent = 70000m,
            LandlordId = Guid.NewGuid()
        };
        context.Properties.Add(property);
        await context.SaveChangesAsync();

        var ticket = new MaintenanceTicket
        {
            PropertyId = property.Id,
            TenantId = Guid.NewGuid(),
            IssueDescription = "Living room power socket not working",
            PhotoUrl = "https://cdn.rms.local/photos/socket_01.jpg",
            Priority = MaintenancePriority.Low,
            Status = MaintenanceStatus.Open
        };
        context.MaintenanceTickets.Add(ticket);
        await context.SaveChangesAsync();

        // Act
        var triageResult = await service.TriageAndEstimateCostAsync(ticket.Id);

        // Assert
        Assert.NotNull(triageResult);
        Assert.Equal("Electrical Engineering", triageResult.SuggestedTradeCategory);
        Assert.Equal(22000m, triageResult.EstimatedCost);
        Assert.False(triageResult.RequiresManagerApproval); // < 50,000 threshold
        Assert.Equal(MaintenanceStatus.Open, triageResult.Status);
    }

    [Fact]
    public async Task AssignContractorAndComplete_ValidWorkflow_ResolvesTicket()
    {
        // Arrange
        using var context = CreateInMemoryDbContext();
        var service = new MaintenanceService(context);

        var property = new Property
        {
            Title = "Modern Villa",
            Address = "20 Havelock Rd",
            MonthlyRent = 95000m,
            LandlordId = Guid.NewGuid()
        };
        context.Properties.Add(property);
        await context.SaveChangesAsync();

        var ticket = new MaintenanceTicket
        {
            PropertyId = property.Id,
            TenantId = Guid.NewGuid(),
            IssueDescription = "Door hinge broken",
            PhotoUrl = "https://cdn.rms.local/photos/door_01.jpg",
            Priority = MaintenancePriority.Low,
            Status = MaintenanceStatus.Open
        };
        context.MaintenanceTickets.Add(ticket);
        await context.SaveChangesAsync();

        var contractorId = Guid.NewGuid();

        // Act: Assign Contractor
        var assigned = await service.AssignContractorAsync(ticket.Id, new AssignContractorDto(contractorId, 8500m));
        Assert.Equal(MaintenanceStatus.Assigned, assigned.Status);
        Assert.Equal(contractorId, assigned.AssignedContractorId);

        // Act: Complete Ticket
        var completed = await service.CompleteTicketAsync(ticket.Id, new CompleteTicketDto("Hinge replaced and tested", 8500m));

        // Assert
        Assert.Equal(MaintenanceStatus.Resolved, completed.Status);
        Assert.Equal(8500m, completed.EstimatedCost);
    }
}
