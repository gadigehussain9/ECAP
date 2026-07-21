using ECAP.SharedKernel;

namespace ECAP.Domain.Events.Products;

/// <summary>
/// Event raised when a product is deactivated
/// </summary>
public sealed record ProductDeactivatedEvent(
    Guid ProductId,
    string Sku,
    string? DeactivatedBy) : DomainEvent;
