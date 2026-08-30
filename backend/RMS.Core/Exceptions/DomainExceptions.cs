// =================================================================================================
// File: DomainExceptions.cs
// Module: RMS.Core / Domain Exceptions
// Student Contributor: Upamada Ekanayake (Group Leader - Component A: Property Listing & Lease Lifecycle)
// Architecture: Core Domain Layer - Exception taxonomy for domain rule and constraint violations
// Purpose: Provides strongly-typed domain exceptions used by services to enforce business logic
//          and allow ASP.NET Core global middleware to translate domain errors into HTTP status codes.
// =================================================================================================

namespace RMS.Core.Exceptions;

/// <summary>
/// Base domain exception for business rule violations across RMS.
/// </summary>
public abstract class DomainException : Exception
{
    protected DomainException(string message) : base(message) { }
}

/// <summary>
/// Thrown when a requested domain entity is not found in the persistence store.
/// </summary>
public class NotFoundException : DomainException
{
    public NotFoundException(string message) : base(message) { }
    public NotFoundException(string entityName, object key)
        : base($"{entityName} with identifier '{key}' was not found.") { }
}

/// <summary>
/// Alias for EntityNotFoundException for backwards compatibility with legacy service callers.
/// </summary>
public class EntityNotFoundException : NotFoundException
{
    public EntityNotFoundException(string entityName, object key) : base(entityName, key) { }
}

/// <summary>
/// Thrown when an invalid state transition or domain business rule is violated.
/// </summary>
public class InvalidBusinessOperationException : DomainException
{
    public InvalidBusinessOperationException(string message) : base(message) { }
}

/// <summary>
/// Alias for BusinessRuleValidationException for backwards compatibility.
/// </summary>
public class BusinessRuleValidationException : InvalidBusinessOperationException
{
    public BusinessRuleValidationException(string message) : base(message) { }
}
