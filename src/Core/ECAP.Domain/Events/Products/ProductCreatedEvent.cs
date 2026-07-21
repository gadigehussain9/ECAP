using ECAP.SharedKernel;

namespace ECAP.Domain.Events.Products;

/// <summary>
/// Event raised when a new product is created
/// </summary>
public sealed record ProductCreatedEvent(
    Guid ProductId,
    string Sku,
    string Name,
    Guid BrandId,
    Guid CategoryId,
    decimal Price,
    string Currency,
    string? CreatedBy) : DomainEvent;
