// =================================================================================================
// File: PropertyDtos.cs
// Module: Component A: Property Listing & Lease Lifecycle Management
// Student Contributor: Upamada Ekanayake (Group Leader - IT24200314)
// Architecture: Core Layer - Data Transfer Objects (DTOs) for Properties & Leases
// Purpose: Encapsulates incoming request contracts and outgoing response models for property
//          listing CRUD and lease generation/termination endpoints, ensuring immutable records.
// =================================================================================================

using RMS.Core.Entities;

namespace RMS.Core.DTOs;

/// <summary>
/// Data contract for registering a new real-estate property listing.
/// </summary>
/// <param name="Title">Marketing title of the property.</param>
/// <param name="Description">Detailed overview of features and condition.</param>
/// <param name="Address">Civic physical location in Sri Lanka.</param>
/// <param name="MonthlyRent">Monthly rental price in LKR.</param>
/// <param name="SecurityDeposit">Required refundable security deposit in LKR.</param>
/// <param name="LandlordId">Unique identifier of the property owner.</param>
public record CreatePropertyDto(
    string Title, 
    string Description, 
    string Address, 
    decimal MonthlyRent, 
    decimal SecurityDeposit, 
    Guid LandlordId);

/// <summary>
/// Data contract representing public property listing details returned to web and mobile clients.
/// </summary>
/// <param name="Id">Unique identifier of the property.</param>
/// <param name="Title">Listing title.</param>
/// <param name="Description">Listing description.</param>
/// <param name="Address">Physical address.</param>
/// <param name="MonthlyRent">Monthly rent in LKR.</param>
/// <param name="SecurityDeposit">Security deposit in LKR.</param>
/// <param name="Status">Current availability state.</param>
/// <param name="LandlordId">Owner GUID.</param>
/// <param name="CreatedAtUtc">Creation timestamp in UTC.</param>
public record PropertyResponseDto(
    Guid Id, 
    string Title, 
    string Description, 
    string Address, 
    decimal MonthlyRent, 
    decimal SecurityDeposit, 
    PropertyStatus Status, 
    Guid LandlordId, 
    DateTime CreatedAtUtc);

/// <summary>
/// Data contract for drafting a new residential lease agreement.
/// </summary>
/// <param name="PropertyId">Target property identifier.</param>
/// <param name="TenantId">Approved tenant applicant identifier.</param>
/// <param name="StartDate">Effective tenancy commencement date.</param>
/// <param name="EndDate">Tenancy expiration date.</param>
/// <param name="AgreedRent">Contracted monthly rental fee.</param>
/// <param name="AiDraftedClauses">AI-generated terms and special conditions.</param>
public record CreateLeaseDto(
    Guid PropertyId, 
    Guid TenantId, 
    DateTime StartDate, 
    DateTime EndDate, 
    decimal AgreedRent, 
    string? AiDraftedClauses);

/// <summary>
/// Data contract for executing an early or scheduled lease termination.
/// </summary>
/// <param name="TerminationReason">Justification for terminating tenancy (e.g. mutual agreement, early exit, eviction).</param>
public record TerminateLeaseDto(
    string TerminationReason);

/// <summary>
/// Data contract representing full lease agreement details returned to clients.
/// </summary>
/// <param name="Id">Unique identifier of the lease agreement.</param>
/// <param name="PropertyId">Associated property identifier.</param>
/// <param name="TenantId">Associated tenant identifier.</param>
/// <param name="StartDate">Start date of tenancy.</param>
/// <param name="EndDate">End date of tenancy.</param>
/// <param name="AgreedRent">Agreed rent in LKR.</param>
/// <param name="Status">Current contractual status.</param>
/// <param name="AiDraftedClauses">Custom legal clauses.</param>
/// <param name="CreatedAtUtc">Creation timestamp in UTC.</param>
public record LeaseResponseDto(
    Guid Id, 
    Guid PropertyId, 
    Guid TenantId, 
    DateTime StartDate, 
    DateTime EndDate, 
    decimal AgreedRent, 
    LeaseStatus Status, 
    string? AiDraftedClauses, 
    DateTime CreatedAtUtc);
