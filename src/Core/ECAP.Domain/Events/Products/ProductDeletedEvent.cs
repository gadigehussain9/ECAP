using ECAP.SharedKernel;

namespace ECAP.Domain.Events.Products;

/// <summary>
/// Event raised when a product is deleted (soft delete)
/// </summary>
public sealed record ProductDeletedEvent(
    Guid ProductId,
    string Sku,
    string? DeletedBy) : DomainEvent;
