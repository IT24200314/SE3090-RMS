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

    /// <summary>Gets or sets the users and authentication profiles table.</summary>
    public DbSet<User> Users => Set<User>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);
        
        // Optimize search and filter queries with B-Tree indexes
        modelBuilder.Entity<Property>().HasIndex(p => p.Status);
        modelBuilder.Entity<Property>().HasIndex(p => p.Title);
        modelBuilder.Entity<Property>().HasIndex(p => p.Address);

        modelBuilder.Entity<MaintenanceTicket>().HasIndex(m => m.Status);
        modelBuilder.Entity<MaintenanceTicket>().HasIndex(m => m.Priority);

        modelBuilder.Entity<TenantApplication>().HasIndex(t => t.Status);

        modelBuilder.Entity<User>().HasIndex(u => u.Email).IsUnique();

        // Relational configurations
        modelBuilder.Entity<Lease>()
            .HasOne(l => l.Property)
            .WithMany(p => p.Leases)
            .HasForeignKey(l => l.PropertyId)
            .OnDelete(DeleteBehavior.Restrict);
    }
}
