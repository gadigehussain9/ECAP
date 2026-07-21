using ECAP.SharedKernel;

namespace ECAP.Domain.Events.Products;

/// <summary>
/// Event raised when a product is updated
/// </summary>
public sealed record ProductUpdatedEvent(
    Guid ProductId,
    string Sku,
    string Name,
    Guid BrandId,
    Guid CategoryId,
    decimal Price,
    string? UpdatedBy) : DomainEvent;
