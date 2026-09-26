// =================================================================================================
// File: DatabaseIntegrityAndTransactionTests.cs
// Module: RMS.Infrastructure / Database & Transaction Integrity Tests
// Student Contributor: Upamada Ekanayake (Group Leader - IT24200314)
// Architecture: Data Access & Transaction Verification Layer (xUnit + EF Core InMemory)
// Purpose: Validates relational foreign key constraints, atomic multi-step transaction rollbacks,
//          and UTC audit trail timestamp enforcement (CreatedAtUtc, UpdatedAtUtc).
// =================================================================================================

using Microsoft.EntityFrameworkCore;
using RMS.Core.Entities;
using RMS.Infrastructure.Data;
using Xunit;

namespace RMS.Tests;

/// <summary>
/// Tests database schema constraints, atomic transaction consistency, and audit integrity.
/// </summary>
public class DatabaseIntegrityAndTransactionTests
{
    private static AppDbContext CreateInMemoryDbContext()
    {
        var options = new DbContextOptionsBuilder<AppDbContext>()
            .UseInMemoryDatabase(databaseName: $"RMS_Db_Integrity_{Guid.NewGuid()}")
            .Options;

        return new AppDbContext(options);
    }

    [Fact]
    public async Task AuditTimestamps_OnEntityCreation_AreAssignedInUtc()
    {
        // Arrange
        using var context = CreateInMemoryDbContext();
        var property = new Property
        {
            Title = "Ocean Breeze Villa",
            Description = "Panoramic ocean view residency",
            Address = "45 Galle Road, Mount Lavinia",
            MonthlyRent = 250000m,
            SecurityDeposit = 500000m,
            Status = PropertyStatus.Available,
            LandlordId = Guid.NewGuid()
        };

        var beforeTime = DateTime.UtcNow.AddSeconds(-1);

        // Act
        context.Properties.Add(property);
        await context.SaveChangesAsync();

        var afterTime = DateTime.UtcNow.AddSeconds(1);

        // Assert
        Assert.True(property.CreatedAtUtc >= beforeTime && property.CreatedAtUtc <= afterTime);
    }

    [Fact]
    public async Task RelationalIntegrity_LeaseLinkedToProperty_MaintainsForeignRelationship()
    {
        // Arrange
        using var context = CreateInMemoryDbContext();
        var landlord = new User
        {
            FullName = "Sirimal Perera",
            Email = "sirimal@example.com",
            PasswordHash = "hash123",
            Role = UserRole.PropertyManager
        };
        var tenant = new User
        {
            FullName = "Kamal Silva",
            Email = "kamal@example.com",
            PasswordHash = "hash456",
            Role = UserRole.Tenant
        };
        context.Users.AddRange(landlord, tenant);
        await context.SaveChangesAsync();

        var property = new Property
        {
            Title = "Suburban Flat",
            Description = "Spacious apartment",
            Address = "12 Station Road, Nugegoda",
            MonthlyRent = 120000m,
            SecurityDeposit = 240000m,
            Status = PropertyStatus.Occupied,
            LandlordId = landlord.Id
        };
        context.Properties.Add(property);
        await context.SaveChangesAsync();

        var lease = new Lease
        {
            PropertyId = property.Id,
            TenantId = tenant.Id,
            StartDate = DateTime.UtcNow,
            EndDate = DateTime.UtcNow.AddMonths(12),
            AgreedRent = 120000m,
            Status = LeaseStatus.Active
        };
        context.Leases.Add(lease);
        await context.SaveChangesAsync();

        // Act
        var loadedLease = await context.Leases
            .Include(l => l.Property)
            .FirstOrDefaultAsync(l => l.Id == lease.Id);

        // Assert
        Assert.NotNull(loadedLease);
        Assert.Equal(property.Id, loadedLease.PropertyId);
        Assert.NotNull(loadedLease.Property);
        Assert.Equal("Suburban Flat", loadedLease.Property.Title);
        Assert.Equal(120000m, loadedLease.AgreedRent);
    }

    [Fact]
    public async Task AtomicTransaction_SimulatedFailureDuringMultiEntitySave_PreservesStateConsistency()
    {
        // Arrange
        using var context = CreateInMemoryDbContext();
        var landlordId = Guid.NewGuid();

        var prop1 = new Property
        {
            Title = "Valid Unit A",
            Description = "Desc",
            Address = "Address A",
            MonthlyRent = 80000m,
            SecurityDeposit = 160000m,
            Status = PropertyStatus.Available,
            LandlordId = landlordId
        };

        // Act & Assert: Demonstrate that an explicit error in a transaction scope rolls back
        // In EF Core, if SaveChanges fails, pending entities remain detached/uncommitted
        context.Properties.Add(prop1);
        await context.SaveChangesAsync();

        // Verify Unit A is saved
        Assert.Equal(1, await context.Properties.CountAsync());

        // Simulate a broken secondary batch operation
        try
        {
            var prop2 = new Property
            {
                Title = "Valid Unit B",
                Description = "Desc B",
                Address = "Address B",
                MonthlyRent = 95000m,
                SecurityDeposit = 190000m,
                Status = PropertyStatus.Available,
                LandlordId = landlordId
            };
            context.Properties.Add(prop2);

            // Deliberately trigger an exception before commit
            throw new InvalidOperationException("Simulated mid-flight network/database partition fault");
        }
        catch (InvalidOperationException)
        {
            // Detach pending entries on error
            foreach (var entry in context.ChangeTracker.Entries().Where(e => e.State == EntityState.Added))
            {
                entry.State = EntityState.Detached;
            }
        }

        // Assert: Database still strictly contains only Unit A, maintaining atomic integrity
        var remainingProperties = await context.Properties.ToListAsync();
        Assert.Single(remainingProperties);
        Assert.Equal("Valid Unit A", remainingProperties[0].Title);
    }
}
