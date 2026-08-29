// =================================================================================================
// File: IPropertyLeaseService.cs
// Module: Component A: Property Listing & Lease Lifecycle Management
// Student Contributor: Upamada Ekanayake (Group Leader - IT24200314)
// Architecture: Core Layer - Interface contract for property listings and lease lifecycle services
// Purpose: Declares synchronous/asynchronous contracts for managing property inventory, pagination,
//          drafting formal leases, and executing early lease terminations with state rollback.
// =================================================================================================

using RMS.Core.DTOs;

namespace RMS.Core.Interfaces;

/// <summary>
/// Service interface handling Property & Lease Management operations.
/// </summary>
public interface IPropertyLeaseService
{
    /// <summary>
    /// Creates a new property listing in the system.
    /// </summary>
    /// <param name="dto">Property creation payload.</param>
    /// <returns>Created property details.</returns>
    Task<PropertyResponseDto> CreatePropertyAsync(CreatePropertyDto dto);

    /// <summary>
    /// Retrieves a paginated list of properties matching an optional search term.
    /// </summary>
    /// <param name="searchTerm">Optional title or address filter.</param>
    /// <param name="page">Page index starting at 1.</param>
    /// <param name="pageSize">Number of items per page.</param>
    /// <returns>Collection of matching property DTOs.</returns>
    Task<IEnumerable<PropertyResponseDto>> GetPropertiesAsync(string? searchTerm, int page = 1, int pageSize = 10);

    /// <summary>
    /// Retrieves a single property by unique identifier.
    /// </summary>
    /// <param name="id">Property unique GUID.</param>
    /// <returns>Property response DTO.</returns>
    Task<PropertyResponseDto> GetPropertyByIdAsync(Guid id);

    /// <summary>
    /// Generates and drafts a lease contract for an approved tenant.
    /// </summary>
    /// <param name="dto">Lease creation parameters.</param>
    /// <returns>Drafted lease response DTO.</returns>
    Task<LeaseResponseDto> GenerateLeaseAgreementAsync(CreateLeaseDto dto);

    /// <summary>
    /// Performs early or scheduled lease termination with validation on existing status and property availability release.
    /// </summary>
    /// <param name="leaseId">Unique lease identifier.</param>
    /// <param name="terminationReason">Stated business reason for lease termination.</param>
    /// <returns>Updated lease response DTO with Terminated status.</returns>
    Task<LeaseResponseDto> TerminateLeaseAsync(Guid leaseId, string terminationReason);
}
