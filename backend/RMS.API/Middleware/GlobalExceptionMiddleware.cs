// =================================================================================================
// File: GlobalExceptionMiddleware.cs
// Module: Presentation / API Layer - Enterprise Error Handling Middleware
// Student Contributor: Upamada Ekanayake (Group Leader - IT24200314)
// Architecture: Clean Architecture / Global Exception Handling Pipeline
// Purpose: Intercepts unhandled domain and runtime exceptions, logging details and serializing
//          standard RFC 7807 ProblemDetails JSON responses with appropriate HTTP status codes.
// =================================================================================================

using System.Net;
using System.Text.Json;
using Microsoft.AspNetCore.Mvc;
using RMS.Core.Exceptions;

namespace RMS.API.Middleware;

/// <summary>
/// Global exception handling middleware mapping domain exceptions to RFC 7807 ProblemDetails.
/// </summary>
public class GlobalExceptionMiddleware
{
    private readonly RequestDelegate _next;
    private readonly ILogger<GlobalExceptionMiddleware> _logger;

    public GlobalExceptionMiddleware(RequestDelegate _next, ILogger<GlobalExceptionMiddleware> logger)
    {
        this._next = _next;
        _logger = logger;
    }

    public async Task InvokeAsync(HttpContext context)
    {
        try
        {
            await _next(context);
        }
        catch (Exception ex)
        {
            await HandleExceptionAsync(context, ex);
        }
    }

    private async Task HandleExceptionAsync(HttpContext context, Exception exception)
    {
        _logger.LogError(exception, "Unhandled exception occurred during request execution: {Message}", exception.Message);

        var statusCode = exception switch
        {
            NotFoundException or KeyNotFoundException => HttpStatusCode.NotFound,
            InvalidBusinessOperationException or ArgumentException or InvalidOperationException => HttpStatusCode.BadRequest,
            UnauthorizedAccessException => HttpStatusCode.Unauthorized,
            _ => HttpStatusCode.InternalServerError
        };

        var problemDetails = new ProblemDetails
        {
            Status = (int)statusCode,
            Title = statusCode switch
            {
                HttpStatusCode.NotFound => "Resource Not Found",
                HttpStatusCode.BadRequest => "Invalid Business Operation",
                HttpStatusCode.Unauthorized => "Unauthorized Access",
                _ => "An internal server error occurred"
            },
            Detail = exception.Message,
            Instance = context.Request.Path
        };

        context.Response.ContentType = "application/problem+json";
        context.Response.StatusCode = (int)statusCode;

        var json = JsonSerializer.Serialize(problemDetails);
        await context.Response.WriteAsync(json);
    }
}
