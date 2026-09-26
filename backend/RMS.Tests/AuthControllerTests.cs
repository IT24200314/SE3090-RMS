// =================================================================================================
// File: AuthControllerTests.cs
// Module: Presentation Layer / Authentication & Security Tests
// Student Contributor: Upamada Ekanayake (Group Leader - IT24200314)
// Architecture: Automated Unit & Controller Testing Layer (xUnit + EF Core InMemory + JWT Validation)
// Purpose: Validates cryptographic user registration, password hashing verification, JWT token
//          claim integrity (Role, NameIdentifier), and HTTP 401/409 security status codes.
// =================================================================================================

using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using RMS.API.Controllers;
using RMS.Core.DTOs;
using RMS.Core.Entities;
using RMS.Infrastructure.Data;
using Xunit;

namespace RMS.Tests;

/// <summary>
/// Verifies authentication security, password hashing, and role-based JWT issuance.
/// </summary>
public class AuthControllerTests
{
    private static AppDbContext CreateInMemoryDbContext()
    {
        var options = new DbContextOptionsBuilder<AppDbContext>()
            .UseInMemoryDatabase(databaseName: $"RMS_Auth_Test_{Guid.NewGuid()}")
            .Options;

        return new AppDbContext(options);
    }

    private static IConfiguration CreateMockConfiguration()
    {
        var inMemorySettings = new Dictionary<string, string?>
        {
            {"Jwt:Key", "RMS_Super_Secret_Security_Key_SE3090_Assignment_Grading_2026_Key!"},
            {"Jwt:Issuer", "RMS_API"},
            {"Jwt:Audience", "RMS_Clients"},
            {"Jwt:ExpiryHours", "24"}
        };

        return new ConfigurationBuilder()
            .AddInMemoryCollection(inMemorySettings)
            .Build();
    }

    [Fact]
    public async Task Register_ValidNewUser_Returns201CreatedWithJwtToken()
    {
        // Arrange
        using var context = CreateInMemoryDbContext();
        var config = CreateMockConfiguration();
        var controller = new AuthController(context, config);

        var dto = new RegisterRequestDto("John Doe", "john@example.com", "SecureP@ss123", UserRole.Tenant, "+94771234567");

        // Act
        var result = await controller.Register(dto);

        // Assert
        var objectResult = Assert.IsType<ObjectResult>(result);
        Assert.Equal(StatusCodes.Status201Created, objectResult.StatusCode);

        var responseDto = Assert.IsType<AuthResponseDto>(objectResult.Value);
        Assert.False(string.IsNullOrEmpty(responseDto.Token));
        Assert.Equal("john@example.com", responseDto.Email);
        Assert.Equal("Tenant", responseDto.Role);

        // Verify stored user in database is hashed (not plain text)
        var userInDb = await context.Users.FirstOrDefaultAsync(u => u.Email == "john@example.com");
        Assert.NotNull(userInDb);
        Assert.NotEqual("SecureP@ss123", userInDb.PasswordHash);
    }

    [Fact]
    public async Task Register_DuplicateEmail_Returns409Conflict()
    {
        // Arrange
        using var context = CreateInMemoryDbContext();
        var config = CreateMockConfiguration();
        var controller = new AuthController(context, config);

        var dto = new RegisterRequestDto("First User", "duplicate@example.com", "Password123!", UserRole.Tenant, null);
        await controller.Register(dto);

        // Act
        var duplicateDto = new RegisterRequestDto("Second User", "duplicate@example.com", "AnotherPassword!", UserRole.PropertyManager, null);
        var result = await controller.Register(duplicateDto);

        // Assert
        var conflictResult = Assert.IsType<ConflictObjectResult>(result);
        Assert.Equal(StatusCodes.Status409Conflict, conflictResult.StatusCode);
    }

    [Fact]
    public async Task Login_ValidCredentials_Returns200OkWithValidClaims()
    {
        // Arrange
        using var context = CreateInMemoryDbContext();
        var config = CreateMockConfiguration();
        var controller = new AuthController(context, config);

        var regDto = new RegisterRequestDto("Manager Jane", "manager@example.com", "ManagerSecure123!", UserRole.PropertyManager, "+94779876543");
        await controller.Register(regDto);

        var loginDto = new LoginRequestDto("manager@example.com", "ManagerSecure123!");

        // Act
        var result = await controller.Login(loginDto);

        // Assert
        var okResult = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(StatusCodes.Status200OK, okResult.StatusCode);

        var responseDto = Assert.IsType<AuthResponseDto>(okResult.Value);
        Assert.Equal("PropertyManager", responseDto.Role);

        // Validate JWT Token structure
        var handler = new JwtSecurityTokenHandler();
        var jwtToken = handler.ReadJwtToken(responseDto.Token);
        Assert.Equal("RMS_API", jwtToken.Issuer);

        var roleClaim = jwtToken.Claims.FirstOrDefault(c => c.Type == ClaimTypes.Role || c.Type == "role");
        Assert.NotNull(roleClaim);
        Assert.Equal("PropertyManager", roleClaim.Value);
    }

    [Fact]
    public async Task Login_InvalidPassword_Returns401Unauthorized()
    {
        // Arrange
        using var context = CreateInMemoryDbContext();
        var config = CreateMockConfiguration();
        var controller = new AuthController(context, config);

        var regDto = new RegisterRequestDto("Test User", "test@example.com", "RealPassword123!", UserRole.Tenant, null);
        await controller.Register(regDto);

        var loginDto = new LoginRequestDto("test@example.com", "WrongPassword456!");

        // Act
        var result = await controller.Login(loginDto);

        // Assert
        var unauthorizedResult = Assert.IsType<UnauthorizedObjectResult>(result);
        Assert.Equal(StatusCodes.Status401Unauthorized, unauthorizedResult.StatusCode);
    }

    [Fact]
    public async Task Login_NonExistentEmail_Returns401Unauthorized()
    {
        // Arrange
        using var context = CreateInMemoryDbContext();
        var config = CreateMockConfiguration();
        var controller = new AuthController(context, config);

        var loginDto = new LoginRequestDto("nonexistent@example.com", "AnyPassword!");

        // Act
        var result = await controller.Login(loginDto);

        // Assert
        var unauthorizedResult = Assert.IsType<UnauthorizedObjectResult>(result);
        Assert.Equal(StatusCodes.Status401Unauthorized, unauthorizedResult.StatusCode);
    }
}
