using ECAP.SharedKernel;

namespace ECAP.Domain.Events.Products;

/// <summary>
/// Event raised when a product is activated
/// </summary>
public sealed record ProductActivatedEvent(
    Guid ProductId,
    string Sku,
    string? ActivatedBy) : DomainEvent;
