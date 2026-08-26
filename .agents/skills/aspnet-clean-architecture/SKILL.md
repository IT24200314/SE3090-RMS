---
name: aspnet-clean-architecture
description: Expert .NET 8 / C# Clean Architecture design, controllers, DTOs, EF Core, middleware, global exception handling, and XML documentation.
---

# ASP.NET Core 8 & C# Clean Architecture Skill

## Core Principles
1. **Layer Separation**:
   - `Domain`: Enterprise entities, value objects, domain exceptions, enums.
   - `Application`: Use cases, interfaces (repositories/services), DTOs, FluentValidation rules, business logic.
   - `Infrastructure`: EF Core `DbContext`, migrations, external service integrations, logging implementations.
   - `API`: Controllers / Minimal APIs, Middleware, Program.cs DI configurations, filters, Swagger/OpenAPI setup.

2. **DTO & Model Mapping**:
   - Never return EF Core entities directly from Controllers.
   - Explicit mapping or clean mapper extensions for Request/Response DTOs.

3. **Global Exception Handling**:
   - Use custom middleware or `IExceptionHandler` in .NET 8 to map domain exceptions into standardized `ProblemDetails` responses.

4. **Humanized Code & XML Documentation**:
   - Use XML summary tags on all public controllers, methods, and DTOs:
     ```csharp
     /// <summary>
     /// Approves a pending lease agreement and notifies tenant.
     /// </summary>
     /// <param name="leaseId">The unique identifier of the lease.</param>
     /// <returns>Updated lease details with status.</returns>
     ```
   - Explain business rationale in comments (e.g. `// Verify tenant passes 30% rent-to-income affordability threshold`).
