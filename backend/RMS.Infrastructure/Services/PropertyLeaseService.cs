// =================================================================================================
// File: PropertyLeaseService.cs
// Module: Component A: Property Listing & Lease Lifecycle Management
// Student Contributor: Upamada Ekanayake (Group Leader - IT24200314)
// Architecture: Infrastructure / Service Layer - Property Listing & Lease Agreement Business Logic
// Purpose: Implements core business logic for real-estate inventory CRUD, paginated querying,
//          drafting formal lease contracts, and non-trivial early lease termination with state rollback.
// =================================================================================================

using Microsoft.EntityFrameworkCore;
using RMS.Core.DTOs;
using RMS.Core.Entities;
using RMS.Core.Interfaces;
using RMS.Infrastructure.Data;

namespace RMS.Infrastructure.Services;

/// <summary>
/// Service implementation for property listings and lease contract lifecycle operations.
/// </summary>
public class PropertyLeaseService : IPropertyLeaseService
{
    private readonly AppDbContext _context;

    public PropertyLeaseService(AppDbContext context)
    {
        _context = context;
    }

    /// <inheritdoc/>
    public async Task<PropertyResponseDto> CreatePropertyAsync(CreatePropertyDto dto)
    {
        // Validate monthly rent and security deposit amounts
        if (dto.MonthlyRent <= 0)
        {
            throw new ArgumentException("Monthly rent must be greater than zero.", nameof(dto.MonthlyRent));
        }

        var property = new Property
        {
            Title = dto.Title,
            Description = dto.Description,
            Address = dto.Address,
            MonthlyRent = dto.MonthlyRent,
            SecurityDeposit = dto.SecurityDeposit,
            LandlordId = dto.LandlordId,
            Status = PropertyStatus.Available
        };

        _context.Properties.Add(property);
        await _context.SaveChangesAsync();

        return MapToPropertyResponse(property);
    }

    /// <inheritdoc/>
    public async Task<IEnumerable<PropertyResponseDto>> GetPropertiesAsync(string? searchTerm, int page = 1, int pageSize = 10)
    {
        var query = _context.Properties.AsNoTracking().AsQueryable();

        // Apply search filter on title or address if provided
        if (!string.IsNullOrWhiteSpace(searchTerm))
        {
            var term = searchTerm.Trim().ToLower();
            query = query.Where(p => p.Title.ToLower().Contains(term) || p.Address.ToLower().Contains(term));
        }

        // Apply pagination
        var pagedProperties = await query
            .OrderByDescending(p => p.CreatedAtUtc)
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .ToListAsync();

        return pagedProperties.Select(MapToPropertyResponse);
    }

    /// <inheritdoc/>
    public async Task<PropertyResponseDto> GetPropertyByIdAsync(Guid id)
    {
        var property = await _context.Properties.AsNoTracking().FirstOrDefaultAsync(p => p.Id == id);
        if (property == null)
        {
            throw new KeyNotFoundException($"Property with ID {id} was not found.");
        }
        return MapToPropertyResponse(property);
    }

    /// <inheritdoc/>
    public async Task<LeaseResponseDto> GenerateLeaseAgreementAsync(CreateLeaseDto dto)
    {
        var property = await _context.Properties.FirstOrDefaultAsync(p => p.Id == dto.PropertyId);
        if (property == null)
        {
            throw new KeyNotFoundException($"Property with ID {dto.PropertyId} was not found.");
        }

        // Business Rule: Ensure property is currently available for lease
        if (property.Status != PropertyStatus.Available)
        {
            throw new InvalidOperationException($"Cannot generate a lease. Property status is currently '{property.Status}'.");
        }

        if (dto.EndDate <= dto.StartDate)
        {
            throw new ArgumentException("Lease end date must be after the start date.");
        }

        var lease = new Lease
        {
            PropertyId = dto.PropertyId,
            TenantId = dto.TenantId,
            StartDate = dto.StartDate,
            EndDate = dto.EndDate,
            AgreedRent = dto.AgreedRent,
            Status = LeaseStatus.PendingSignature,
            AiDraftedClauses = dto.AiDraftedClauses
        };

        // Update property status to indicate pending occupancy
        property.Status = PropertyStatus.Occupied;
        property.UpdatedAtUtc = DateTime.UtcNow;

        _context.Leases.Add(lease);
        await _context.SaveChangesAsync();

        return MapToLeaseResponse(lease);
    }

    /// <inheritdoc/>
    public async Task<LeaseResponseDto> TerminateLeaseAsync(Guid leaseId, string terminationReason)
    {
        var lease = await _context.Leases.Include(l => l.Property).FirstOrDefaultAsync(l => l.Id == leaseId);
        if (lease == null)
        {
            throw new KeyNotFoundException($"Lease with ID {leaseId} was not found.");
        }

        // Business Rule: Only active or pending signature leases can be terminated
        if (lease.Status == LeaseStatus.Terminated || lease.Status == LeaseStatus.Expired)
        {
            throw new InvalidOperationException($"Lease is already in '{lease.Status}' state and cannot be terminated again.");
        }

        lease.Status = LeaseStatus.Terminated;
        lease.UpdatedAtUtc = DateTime.UtcNow;

        // Release associated property back to Available status
        if (lease.Property != null)
        {
            lease.Property.Status = PropertyStatus.Available;
            lease.Property.UpdatedAtUtc = DateTime.UtcNow;
        }

        await _context.SaveChangesAsync();

        return MapToLeaseResponse(lease);
    }

    private static PropertyResponseDto MapToPropertyResponse(Property p) =>
        new(p.Id, p.Title, p.Description, p.Address, p.MonthlyRent, p.SecurityDeposit, p.Status, p.LandlordId, p.CreatedAtUtc);

    private static LeaseResponseDto MapToLeaseResponse(Lease l) =>
        new(l.Id, l.PropertyId, l.TenantId, l.StartDate, l.EndDate, l.AgreedRent, l.Status, l.AiDraftedClauses, l.CreatedAtUtc);
}
