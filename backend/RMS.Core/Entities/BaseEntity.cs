// =================================================================================================
// File: BaseEntity.cs
// Module: RMS.Core / Shared Kernel Entities
// Student Contributor: Upamada Ekanayake (Group Leader - Component A: Property Listing & Lease Lifecycle)
// Architecture: Core Domain Layer - Base entity providing identity and audit timestamps
// Purpose: Serves as the base class for all persistent entities in the PostgreSQL relational schema,
//          guaranteeing consistent UUID primary keys and UTC audit trails across the system.
// =================================================================================================

namespace RMS.Core.Entities;

/// <summary>
/// Abstract base class for all domain entities providing unified UUID keys and UTC timestamps.
/// </summary>
public abstract class BaseEntity
{
    /// <summary>
    /// Gets or sets the globally unique identifier for the entity.
    /// </summary>
    public Guid Id { get; set; } = Guid.NewGuid();

    /// <summary>
    /// Gets or sets the UTC creation timestamp for data auditing and chronological sorting.
    /// </summary>
    public DateTime CreatedAtUtc { get; set; } = DateTime.UtcNow;

    /// <summary>
    /// Gets or sets the UTC last modification timestamp, updated whenever the record state changes.
    /// </summary>
    public DateTime? UpdatedAtUtc { get; set; }
}
