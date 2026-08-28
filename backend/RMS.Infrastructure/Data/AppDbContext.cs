// =================================================================================================
// File: AppDbContext.cs
// Module: RMS.Infrastructure / Data Access Layer
// Student Contributor: Upamada Ekanayake (Group Leader - IT24200314)
// Architecture: Infrastructure Layer - Entity Framework Core Database Context for PostgreSQL
// Purpose: Configures Entity Framework Core mappings, relational DbSet collections, PostgreSQL
//          table definitions, indexes for fast querying, and persistence life-cycle management.
// =================================================================================================

using Microsoft.EntityFrameworkCore;
using RMS.Core.Entities;

namespace RMS.Infrastructure.Data;

/// <summary>
/// Entity Framework Core database context representing the normalized relational schema of RMS.
/// </summary>
public class AppDbContext : DbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

    /// <summary>Gets or sets the properties table.</summary>
    public DbSet<Property> Properties => Set<Property>();

    /// <summary>Gets or sets the leases table.</summary>
    public DbSet<Lease> Leases => Set<Lease>();

    /// <summary>Gets or sets the tenant applications table.</summary>
    public DbSet<TenantApplication> TenantApplications => Set<TenantApplication>();

    /// <summary>Gets or sets the maintenance work order tickets table.</summary>
    public DbSet<MaintenanceTicket> MaintenanceTickets => Set<MaintenanceTicket>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);
        
        // Optimize search queries by indexing frequently filtered status columns
        modelBuilder.Entity<Property>().HasIndex(p => p.Status);
        modelBuilder.Entity<MaintenanceTicket>().HasIndex(m => m.Status);
    }
}
