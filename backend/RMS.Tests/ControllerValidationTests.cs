// =================================================================================================
// File: ControllerValidationTests.cs
// Module: RMS.API / Controller & Validation Test Suite
// Student Contributor: Upamada Ekanayake (Group Leader - IT24200314)
// Architecture: Presentation / Controller Test Layer (xUnit + ASP.NET Core Action Invocation)
// Purpose: Validates REST HTTP status codes (200 OK, 201 Created, 400 BadRequest, 404 NotFound),
//          model state validation rules, and business-specific controller endpoints.
// =================================================================================================

using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using RMS.API.Controllers;
using RMS.Core.DTOs;
using RMS.Core.Entities;
using RMS.Infrastructure.Data;
using RMS.Infrastructure.Services;
using Xunit;

namespace RMS.Tests;

/// <summary>
/// Verifies REST controller action responses, HTTP status conventions, and validation contracts.
/// </summary>
public class ControllerValidationTests
{
    private static AppDbContext CreateInMemoryDbContext()
    {
        var options = new DbContextOptionsBuilder<AppDbContext>()
            .UseInMemoryDatabase(databaseName: $"RMS_Controller_Val_{Guid.NewGuid()}")
            .Options;

        return new AppDbContext(options);
    }

    [Fact]
    public async Task PropertiesController_CreateProperty_ValidModel_Returns201Created()
    {
        // Arrange
        using var context = CreateInMemoryDbContext();
        var service = new PropertyLeaseService(context);
        var controller = new PropertiesController(service);

        var landlordId = Guid.NewGuid();
        var dto = new CreatePropertyDto(
            "Luxury Penthouse",
            "High-rise with panoramic view",
            "100 Galle Face, Colombo",
            350000m,
            700000m,
            landlordId
        );

        // Act
        var result = await controller.CreateProperty(dto);

        // Assert
        var createdResult = Assert.IsType<CreatedAtActionResult>(result);
        Assert.Equal(StatusCodes.Status201Created, createdResult.StatusCode);

        var returnedDto = Assert.IsType<PropertyResponseDto>(createdResult.Value);
        Assert.Equal("Luxury Penthouse", returnedDto.Title);
        Assert.Equal(350000m, returnedDto.MonthlyRent);
    }

    [Fact]
    public async Task PropertiesController_GetPropertyById_NonExistentId_Returns404NotFound()
    {
        // Arrange
        using var context = CreateInMemoryDbContext();
        var service = new PropertyLeaseService(context);
        var controller = new PropertiesController(service);

        // Act
        var result = await controller.GetPropertyById(Guid.NewGuid());

        // Assert
        var notFoundResult = Assert.IsType<NotFoundObjectResult>(result);
        Assert.Equal(StatusCodes.Status404NotFound, notFoundResult.StatusCode);
    }

    [Fact]
    public async Task MaintenanceController_CreateTicket_ValidModel_Returns201Created()
    {
        // Arrange
        using var context = CreateInMemoryDbContext();
        var property = new Property
        {
            Title = "Marine Drive Suite",
            Address = "Colombo 03",
            MonthlyRent = 120000m,
            SecurityDeposit = 240000m,
            LandlordId = Guid.NewGuid()
        };
        var tenant = new User
        {
            FullName = "Ravi Tenant",
            Email = "ravi@example.com",
            PasswordHash = "hash",
            Role = UserRole.Tenant
        };
        context.Properties.Add(property);
        context.Users.Add(tenant);
        await context.SaveChangesAsync();

        var service = new MaintenanceService(context);
        var controller = new MaintenanceController(service);

        var dto = new CreateMaintenanceTicketDto(
            PropertyId: property.Id,
            TenantId: tenant.Id,
            IssueDescription: "Kitchen sink drain clogged with overflow",
            PhotoUrl: "https://storage.rms.lk/tickets/sink1.jpg",
            Priority: MaintenancePriority.High
        );

        // Act
        var result = await controller.CreateTicket(dto);

        // Assert
        var createdResult = Assert.IsType<CreatedAtActionResult>(result);
        Assert.Equal(StatusCodes.Status201Created, createdResult.StatusCode);

        var responseDto = Assert.IsType<MaintenanceTicketResponseDto>(createdResult.Value);
        Assert.Equal(MaintenanceStatus.Open, responseDto.Status);
        Assert.Equal("Kitchen sink drain clogged with overflow", responseDto.IssueDescription);
    }

    [Fact]
    public async Task MaintenanceController_TriageAndEstimate_BurstPipe_SetsPendingManagerApproval()
    {
        // Arrange
        using var context = CreateInMemoryDbContext();
        var property = new Property
        {
            Title = "Hilltop Residence",
            Address = "Kandy Road",
            MonthlyRent = 90000m,
            SecurityDeposit = 180000m,
            LandlordId = Guid.NewGuid()
        };
        var tenant = new User
        {
            FullName = "Amara Silva",
            Email = "amara@example.com",
            PasswordHash = "hash",
            Role = UserRole.Tenant
        };
        context.Properties.Add(property);
        context.Users.Add(tenant);
        await context.SaveChangesAsync();

        var service = new MaintenanceService(context);
        var controller = new MaintenanceController(service);

        // Seed a ticket with emergency keyword
        var createDto = new CreateMaintenanceTicketDto(
            PropertyId: property.Id,
            TenantId: tenant.Id,
            IssueDescription: "Burst pipe flooding the master bedroom floor",
            PhotoUrl: "https://storage.rms.lk/burst.jpg",
            Priority: MaintenancePriority.Emergency
        );
        var ticket = await service.CreateTicketAsync(createDto);

        // Act
        var result = await controller.TriageAndEstimate(ticket.Id);

        // Assert
        var okResult = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(StatusCodes.Status200OK, okResult.StatusCode);

        var triageDto = Assert.IsType<TriageAndEstimateResultDto>(okResult.Value);
        Assert.True(triageDto.RequiresManagerApproval);
        Assert.True(triageDto.EstimatedCost >= 50000m);
        Assert.Equal(MaintenanceStatus.PendingManagerApproval, triageDto.Status);
    }

    [Fact]
    public async Task TenantScreeningController_GetApplicationById_InvalidId_ThrowsNotFoundException()
    {
        // Arrange
        using var context = CreateInMemoryDbContext();
        var service = new TenantScreeningService(context);
        var controller = new TenantScreeningController(service);

        // Act & Assert (GlobalExceptionMiddleware translates this to HTTP 404 in production pipeline)
        await Assert.ThrowsAsync<RMS.Core.Exceptions.NotFoundException>(() =>
            controller.GetApplicationById(Guid.NewGuid()));
    }
}
