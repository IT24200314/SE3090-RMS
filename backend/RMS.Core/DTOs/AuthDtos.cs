// =================================================================================================
// File: AuthDtos.cs
// Module: RMS.Core / Data Transfer Objects - Authentication & RBAC
// Student Contributor: Upamada Ekanayake (Group Leader - IT24200314)
// Architecture: Core Domain Layer - Contract DTOs for User Registration & JWT Login
// Purpose: Validates inbound authentication payloads and models token response envelopes.
// =================================================================================================

using System.ComponentModel.DataAnnotations;
using RMS.Core.Entities;

namespace RMS.Core.DTOs;

/// <summary>
/// Inbound payload for registering a new user account.
/// </summary>
public record RegisterRequestDto(
    [Required] [MaxLength(100)] string FullName,
    [Required] [EmailAddress] string Email,
    [Required] [MinLength(6)] string Password,
    [Required] UserRole Role,
    string? PhoneNumber
);

/// <summary>
/// Inbound payload for user credentials verification.
/// </summary>
public record LoginRequestDto(
    [Required] [EmailAddress] string Email,
    [Required] string Password
);

/// <summary>
/// Response payload containing the signed JWT token and user profile summary.
/// </summary>
public record AuthResponseDto(
    string Token,
    Guid UserId,
    string FullName,
    string Email,
    string Role,
    DateTime ExpiresAtUtc
);
