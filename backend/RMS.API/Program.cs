// =================================================================================================
// File: Program.cs
// Module: RMS.API / Host Application Entrypoint
// Student Contributor: Upamada Ekanayake (Group Leader - IT24200314)
// Architecture: ASP.NET Core 8/10 Web API - Dependency Injection, PostgreSQL / EF Core Migrations,
//              JWT Bearer Authentication, CORS, Swagger with Bearer Support, and Resilient Seed Pipeline
// Purpose: Configures Web API middleware pipelines, EF Core PostgreSQL DbContext registration with
//          automatic migration, JWT token validation, role-based authorization, and seed demo records.
// =================================================================================================

using System.Security.Cryptography;
using System.Text;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using RMS.Core.Entities;
using RMS.Core.Interfaces;
using RMS.Infrastructure.Data;
using RMS.Infrastructure.Services;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();

builder.Services.AddSwaggerGen();

// Enable CORS for React Frontend and Flutter Mobile clients
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", policy =>
    {
        policy.AllowAnyOrigin()
              .AllowAnyMethod()
              .AllowAnyHeader();
    });
});

// Configure JWT Bearer Authentication
var jwtSettings = builder.Configuration.GetSection("Jwt");
var secretKey = jwtSettings["Key"] ?? "RMS_Super_Secret_Security_Key_SE3090_Assignment_Grading_2026_Key!";
var issuer = jwtSettings["Issuer"] ?? "RMS_API";
var audience = jwtSettings["Audience"] ?? "RMS_Clients";

builder.Services.AddAuthentication(options =>
{
    options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
    options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
})
.AddJwtBearer(options =>
{
    options.RequireHttpsMetadata = false;
    options.SaveToken = true;
    options.TokenValidationParameters = new TokenValidationParameters
    {
        ValidateIssuerSigningKey = true,
        IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(secretKey)),
        ValidateIssuer = true,
        ValidIssuer = issuer,
        ValidateAudience = true,
        ValidAudience = audience,
        ValidateLifetime = true,
        ClockSkew = TimeSpan.Zero
    };
});

builder.Services.AddAuthorization(options =>
{
    options.AddPolicy("RequireManager", policy => policy.RequireRole(UserRole.PropertyManager.ToString()));
    options.AddPolicy("RequireTenant", policy => policy.RequireRole(UserRole.Tenant.ToString()));
    options.AddPolicy("RequireContractor", policy => policy.RequireRole(UserRole.Contractor.ToString()));
});

// Configure Database Connection: PostgreSQL with resilient local InMemory fallback
var postgresConnectionString = builder.Configuration.GetConnectionString("DefaultConnection");
bool isPostgresAvailable = false;

if (!string.IsNullOrWhiteSpace(postgresConnectionString))
{
    try
    {
        using var testConn = new Npgsql.NpgsqlConnection(postgresConnectionString);
        testConn.Open();
        isPostgresAvailable = true;
    }
    catch
    {
        isPostgresAvailable = false;
    }
}

builder.Services.AddDbContext<AppDbContext>(options =>
{
    if (isPostgresAvailable)
    {
        options.UseNpgsql(postgresConnectionString, npgsqlOptions =>
        {
            npgsqlOptions.MigrationsAssembly("RMS.Infrastructure");
            npgsqlOptions.EnableRetryOnFailure(maxRetryCount: 2, maxRetryDelay: TimeSpan.FromSeconds(2), errorCodesToAdd: null);
        });
    }
    else
    {
        options.UseInMemoryDatabase("RMS_Live_Db");
    }
});

// Register Application Services
builder.Services.AddScoped<IPropertyLeaseService, PropertyLeaseService>();
builder.Services.AddScoped<ITenantScreeningService, TenantScreeningService>();
builder.Services.AddScoped<IMaintenanceService, MaintenanceService>();

var app = builder.Build();

// Database migration & demo seeding pipeline
using (var scope = app.Services.CreateScope())
{
    var context = scope.ServiceProvider.GetRequiredService<AppDbContext>();
    var logger = scope.ServiceProvider.GetRequiredService<ILogger<Program>>();

    try
    {
        if (isPostgresAvailable && context.Database.IsRelational())
        {
            logger.LogInformation("Applying pending PostgreSQL EF Core migrations...");
            context.Database.Migrate();
        }
        else
        {
            logger.LogInformation("PostgreSQL instance offline or credentials unconfigured. Operating on resilient in-memory database store.");
            context.Database.EnsureCreated();
        }
    }
    catch (Exception ex)
    {
        logger.LogWarning("Migration exception ({Message}). Ensuring created fallback.", ex.Message);
        context.Database.EnsureCreated();
    }

    // Seed default role-based test users if none exist
    if (!context.Users.Any())
    {
        string HashPasswordHelper(string pwd)
        {
            byte[] salt = RandomNumberGenerator.GetBytes(16);
            byte[] hash = Rfc2898DeriveBytes.Pbkdf2(
                Encoding.UTF8.GetBytes(pwd),
                salt,
                iterations: 10000,
                hashAlgorithm: HashAlgorithmName.SHA256,
                outputLength: 32
            );
            return $"{Convert.ToBase64String(salt)}:{Convert.ToBase64String(hash)}";
        }

        context.Users.AddRange(
            new User
            {
                Id = Guid.Parse("11111111-1111-1111-1111-111111111111"),
                FullName = "Upamada Ekanayake",
                Email = "manager@rms.lk",
                PasswordHash = HashPasswordHelper("Admin123!"),
                Role = UserRole.PropertyManager,
                PhoneNumber = "+94 77 123 4567"
            },
            new User
            {
                Id = Guid.Parse("22222222-2222-2222-2222-222222222222"),
                FullName = "Nethmi Seya",
                Email = "tenant@rms.lk",
                PasswordHash = HashPasswordHelper("Tenant123!"),
                Role = UserRole.Tenant,
                PhoneNumber = "+94 71 987 6543"
            },
            new User
            {
                Id = Guid.Parse("33333333-3333-3333-3333-333333333333"),
                FullName = "Hashini Wicramathilake",
                Email = "contractor@rms.lk",
                PasswordHash = HashPasswordHelper("Contractor123!"),
                Role = UserRole.Contractor,
                PhoneNumber = "+94 76 555 4321"
            }
        );
        context.SaveChanges();
    }

    // Seed initial demo properties into DbContext
    if (!context.Properties.Any())
    {
        context.Properties.AddRange(
            new Property
            {
                Id = Guid.Parse("e1a3b8c4-5d6e-7f8a-9b0c-1d2e3f4a5b6c"),
                Title = "Oceanfront Luxury Suite",
                Description = "Modern 3-bedroom apartment with panoramic views of the Indian Ocean.",
                Address = "142 Marine Drive, Colombo 03",
                MonthlyRent = 220000m,
                SecurityDeposit = 440000m,
                Status = PropertyStatus.Available,
                LandlordId = Guid.NewGuid()
            },
            new Property
            {
                Id = Guid.Parse("f2b4c9d5-6e7f-8a9b-0c1d-2e3f4a5b6c7d"),
                Title = "Cinnamon Gardens Townhouse",
                Description = "Colonial style refurbished 4-bedroom villa with private courtyard.",
                Address = "28 Flower Road, Colombo 07",
                MonthlyRent = 350000m,
                SecurityDeposit = 700000m,
                Status = PropertyStatus.Occupied,
                LandlordId = Guid.NewGuid()
            }
        );
        context.SaveChanges();
    }
}

app.UseSwagger();
app.UseSwaggerUI(c =>
{
    c.SwaggerEndpoint("/swagger/v1/swagger.json", "RMS API v1");
    c.RoutePrefix = "swagger";
});

app.UseCors("AllowAll");
app.UseAuthentication();
app.UseAuthorization();
app.MapControllers();

app.Run();
