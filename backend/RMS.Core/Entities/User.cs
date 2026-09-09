// =================================================================================================
// File: User.cs
// Module: RMS.Core / Identity & Role-Based Access Control (RBAC)
// Student Contributor: Upamada Ekanayake (Group Leader - IT24200314)
// Architecture: Core Domain Layer - User Authentication & Authorization Entity
// Purpose: Models system user profiles, password hashes, and assigned operational roles 
//          (Tenant, PropertyManager, Contractor) for secure JWT issuance and endpoint protection.
// =================================================================================================

namespace RMS.Core.Entities;

/// <summary>
/// Operational roles for role-based authorization across RMS endpoints.
/// </summary>
public enum UserRole
{
    /// <summary>Renter searching properties, signing leases, and reporting maintenance.</summary>
    Tenant,
    /// <summary>Administrative staff reviewing applications, managing inventory, and approving high-cost jobs.</summary>
    PropertyManager,
    /// <summary>Trade specialist executing maintenance jobs and submitting repair invoices.</summary>
    Contractor
}

/// <summary>
/// Domain entity representing an authenticated user account.
/// </summary>
public class User : BaseEntity
{
    /// <summary>Gets or sets the user's full legal name.</summary>
    public string FullName { get; set; } = string.Empty;

    /// <summary>Gets or sets the normalized login email address.</summary>
    public string Email { get; set; } = string.Empty;

    /// <summary>Gets or sets the cryptographically hashed password with salt.</summary>
    public string PasswordHash { get; set; } = string.Empty;

    /// <summary>Gets or sets the assigned operational role.</summary>
    public UserRole Role { get; set; } = UserRole.Tenant;

    /// <summary>Gets or sets optional contact phone number.</summary>
    public string? PhoneNumber { get; set; }
}
