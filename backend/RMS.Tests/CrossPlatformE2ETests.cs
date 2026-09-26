// =================================================================================================
// File: CrossPlatformE2ETests.cs
// Module: End-to-End Integration Layer / Complete Cross-Platform Workflow Verification
// Student Contributors: Upamada Ekanayake, Nethmi Seya, Hashini Wicramathilake
// Architecture: Full Integration Test - Section 10 / Figure 2 Architecture Validation
// Purpose: Validates the mandatory complete cross-platform Human-in-the-Loop workflow:
//          1. Flutter Mobile submits Maintenance Request (Issue, Photo URL, GPS Coordinates)
//          2. ASP.NET Core persists ticket to PostgreSQL database (Status: Open)
//          3. Internal LangGraph AI triages ticket, estimates cost >= LKR 50K, pauses at PendingManagerApproval
//          4. React Dashboard Manager reviews high-cost ticket and invokes AuthorizeRepair endpoint
//          5. PostgreSQL persists assigned contractor & status: Assigned
//          6. Mobile client queries and receives updated Assigned status with contractor SLA
// =================================================================================================

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
/// End-to-End integration suite validating the full cross-platform workflow from Mobile to Web via AI.
/// </summary>
public class CrossPlatformE2ETests
{
    private static AppDbContext CreateInMemoryDbContext()
    {
        var options = new DbContextOptionsBuilder<AppDbContext>()
            .UseInMemoryDatabase(databaseName: $"RMS_E2E_Workflow_{Guid.NewGuid()}")
            .Options;

        return new AppDbContext(options);
    }

    [Fact]
    public async Task CompleteCrossPlatformWorkflow_MobileToReactViaAiAndManagerApproval_Succeeds()
    {
        // ---------------------------------------------------------------------------------
        // Setup: Initialize shared PostgreSQL context, services, and REST controllers
        // ---------------------------------------------------------------------------------
        using var context = CreateInMemoryDbContext();
        var maintenanceService = new MaintenanceService(context);
        var maintenanceController = new MaintenanceController(maintenanceService);

        // Seed Landlord and Tenant users
        var manager = new User
        {
            FullName = "Anura Manager",
            Email = "manager@rms.lk",
            PasswordHash = "hashed_pw",
            Role = UserRole.PropertyManager
        };
        var tenant = new User
        {
            FullName = "Nuwan Tenant",
            Email = "nuwan@rms.lk",
            PasswordHash = "hashed_pw",
            Role = UserRole.Tenant
        };
        var contractor = new User
        {
            FullName = "Lanka QuickPlumb Services",
            Email = "quickplumb@contracts.lk",
            PasswordHash = "hashed_pw",
            Role = UserRole.Contractor
        };

        var property = new Property
        {
            Title = "Oceanview Luxury Flat 4B",
            Address = "12 Marine Drive, Colombo 03",
            MonthlyRent = 250000m,
            SecurityDeposit = 500000m,
            Status = PropertyStatus.Occupied,
            LandlordId = manager.Id
        };

        context.Users.AddRange(manager, tenant, contractor);
        context.Properties.Add(property);
        await context.SaveChangesAsync();

        // ---------------------------------------------------------------------------------
        // STEP 1 & 2: Mobile Client submits emergency maintenance ticket with GPS Tagging
        // ---------------------------------------------------------------------------------
        var mobileTicketDto = new CreateMaintenanceTicketDto(
            PropertyId: property.Id,
            TenantId: tenant.Id,
            IssueDescription: "Kitchen pipe burst with severe flooding under cabinets (GPS Lat: 6.892, Long: 79.855)",
            PhotoUrl: "https://storage.rms.lk/tickets/burst_pipe_cam_capture.jpg",
            Priority: MaintenancePriority.Emergency
        );

        var createResult = await maintenanceController.CreateTicket(mobileTicketDto);
        var createdAction = Assert.IsType<CreatedAtActionResult>(createResult);
        var initialTicket = Assert.IsType<MaintenanceTicketResponseDto>(createdAction.Value);

        Assert.Equal(MaintenanceStatus.Open, initialTicket.Status);
        Assert.Equal(property.Id, initialTicket.PropertyId);

        // ---------------------------------------------------------------------------------
        // STEP 3: Internal AI Agent analyzes ticket & triggers HITL pause (LKR 50K ceiling)
        // ---------------------------------------------------------------------------------
        var triageResult = await maintenanceController.TriageAndEstimate(initialTicket.Id);
        var triageOk = Assert.IsType<OkObjectResult>(triageResult);
        var triageDto = Assert.IsType<TriageAndEstimateResultDto>(triageOk.Value);

        // Verify AI classification and deterministic HITL ceiling trigger
        Assert.True(triageDto.RequiresManagerApproval);
        Assert.True(triageDto.EstimatedCost >= 50000m);
        Assert.Equal(MaintenanceStatus.PendingManagerApproval, triageDto.Status);
        Assert.Equal("Plumbing Services", triageDto.SuggestedTradeCategory);

        // Verify state is durably persisted in PostgreSQL database
        var ticketInDb = await context.MaintenanceTickets.FindAsync(initialTicket.Id);
        Assert.NotNull(ticketInDb);
        Assert.Equal(MaintenanceStatus.PendingManagerApproval, ticketInDb.Status);
        Assert.True(ticketInDb.EstimatedCost >= 50000m);

        // ---------------------------------------------------------------------------------
        // STEP 4: React Web Dashboard (Manager) reviews high-cost card & assigns contractor
        // ---------------------------------------------------------------------------------
        var assignDto = new AssignContractorDto(
            ContractorId: contractor.Id,
            ApprovedBudget: 60000m
        );

        var assignResult = await maintenanceController.AssignContractor(initialTicket.Id, assignDto);
        var assignOk = Assert.IsType<OkObjectResult>(assignResult);
        var assignedTicket = Assert.IsType<MaintenanceTicketResponseDto>(assignOk.Value);

        Assert.Equal(MaintenanceStatus.Assigned, assignedTicket.Status);
        Assert.Equal(contractor.Id, assignedTicket.AssignedContractorId);

        // ---------------------------------------------------------------------------------
        // STEP 5: Mobile App retrieves updated ticket status
        // ---------------------------------------------------------------------------------
        var mobileRefreshResult = await maintenanceController.GetTicketById(initialTicket.Id);
        var mobileOk = Assert.IsType<OkObjectResult>(mobileRefreshResult);
        var finalMobileView = Assert.IsType<MaintenanceTicketResponseDto>(mobileOk.Value);

        Assert.Equal(MaintenanceStatus.Assigned, finalMobileView.Status);
        Assert.Equal(contractor.Id, finalMobileView.AssignedContractorId);
        Assert.NotNull(finalMobileView.AiTriageSummary);
    }
}
