// =================================================================================================
// File: Program.cs
// Module: RMS.API / Host Application Entrypoint
// Student Contributor: Upamada Ekanayake (Group Leader - IT24200314)
// Architecture: ASP.NET Core 8 Web API - Dependency Injection, CORS, Swagger, and Seed Pipeline
// Purpose: Configures Web API middleware pipelines, Entity Framework Core DbContext registration,
//          service dependencies for all 3 components, CORS policies, and Swagger UI documentation.
// =================================================================================================

using Microsoft.EntityFrameworkCore;
using RMS.Core.Entities;
using RMS.Core.Interfaces;
using RMS.Infrastructure.Data;
using RMS.Infrastructure.Services;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// Enable CORS for React Frontend and Flutter Mobile
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", policy =>
    {
        policy.AllowAnyOrigin()
              .AllowAnyMethod()
              .AllowAnyHeader();
    });
});

// Configure InMemory Database for local reliable startup
builder.Services.AddDbContext<AppDbContext>(options =>
{
    options.UseInMemoryDatabase("RMS_Live_Db");
});

// Register Application Services
builder.Services.AddScoped<IPropertyLeaseService, PropertyLeaseService>();
builder.Services.AddScoped<ITenantScreeningService, TenantScreeningService>();
builder.Services.AddScoped<IMaintenanceService, MaintenanceService>();

var app = builder.Build();

// Seed initial demo properties into DbContext
using (var scope = app.Services.CreateScope())
{
    var context = scope.ServiceProvider.GetRequiredService<AppDbContext>();
    context.Database.EnsureCreated();
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
app.UseAuthorization();
app.MapControllers();

app.Run();
