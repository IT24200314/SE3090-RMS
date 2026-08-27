// =================================================================================================
// File: Property.cs
// Module: Component A: Property Listing & Lease Lifecycle Management
// Student Contributor: Upamada Ekanayake (Group Leader - IT24200314)
// Architecture: Core Domain Layer - Entities representing real-estate units and lease contracts
// Purpose: Defines domain models for Property listings and Lease agreements, enforcing state 
//          transitions (Available -> Occupied -> Available) and tracking contract metadata.
// =================================================================================================

namespace RMS.Core.Entities;

/// <summary>
/// Represents the lifecycle availability state of a rental property.
/// </summary>
public enum PropertyStatus
{
    /// <summary>Property is vacant and actively accepting tenant applications.</summary>
    Available,
    /// <summary>Property is currently bound to an active or signed lease agreement.</summary>
    Occupied,
    /// <summary>Property is undergoing required repairs or safety inspections.</summary>
    UnderMaintenance,
    /// <summary>Property is unlisted or temporarily withdrawn by the landlord.</summary>
    Inactive
}

/// <summary>
/// Represents the formal contractual status of a residential lease agreement.
/// </summary>
public enum LeaseStatus
{
    /// <summary>Draft lease prepared by property manager or AI planning assistant.</summary>
    Draft,
    /// <summary>Lease awaiting formal digital signature by tenant or landlord.</summary>
    PendingSignature,
    /// <summary>Active lease currently in effect with ongoing tenancy.</summary>
    Active,
    /// <summary>Lease terminated prior to expiry date via mutual consent or breach.</summary>
    Terminated,
    /// <summary>Lease that has naturally concluded its contracted duration.</summary>
    Expired
}

/// <summary>
/// Domain entity representing a real-estate rental property unit.
/// </summary>
public class Property : BaseEntity
{
    /// <summary>Gets or sets the public marketing title of the property.</summary>
    public string Title { get; set; } = string.Empty;

    /// <summary>Gets or sets the comprehensive physical and architectural description.</summary>
    public string Description { get; set; } = string.Empty;

    /// <summary>Gets or sets the civic street address and locality in Sri Lanka.</summary>
    public string Address { get; set; } = string.Empty;

    /// <summary>Gets or sets the monthly rental rate in Sri Lankan Rupees (LKR).</summary>
    public decimal MonthlyRent { get; set; }

    /// <summary>Gets or sets the required refundable security deposit in LKR.</summary>
    public decimal SecurityDeposit { get; set; }

    /// <summary>Gets or sets the current occupancy and availability status of the property.</summary>
    public PropertyStatus Status { get; set; } = PropertyStatus.Available;

    /// <summary>Gets or sets the unique identifier of the landlord owner.</summary>
    public Guid LandlordId { get; set; }

    /// <summary>Navigation collection of historical and active leases for this property.</summary>
    public ICollection<Lease> Leases { get; set; } = new List<Lease>();
}

/// <summary>
/// Domain entity representing a legally binding lease agreement between landlord and tenant.
/// </summary>
public class Lease : BaseEntity
{
    /// <summary>Foreign key referencing the leased property unit.</summary>
    public Guid PropertyId { get; set; }

    /// <summary>Navigation property to the associated property entity.</summary>
    public Property? Property { get; set; }

    /// <summary>Foreign key referencing the approved tenant occupant.</summary>
    public Guid TenantId { get; set; }

    /// <summary>Effective start date of tenancy.</summary>
    public DateTime StartDate { get; set; }

    /// <summary>Contracted end date of tenancy.</summary>
    public DateTime EndDate { get; set; }

    /// <summary>Agreed recurring monthly rental payment in LKR.</summary>
    public decimal AgreedRent { get; set; }

    /// <summary>Current contractual status of the lease.</summary>
    public LeaseStatus Status { get; set; } = LeaseStatus.Draft;

    /// <summary>URL to the securely archived PDF copy of the executed agreement.</summary>
    public string ContractPdfUrl { get; set; } = string.Empty;

    /// <summary>AI-synthesized custom lease clauses generated during the onboarding workflow.</summary>
    public string? AiDraftedClauses { get; set; }
}
