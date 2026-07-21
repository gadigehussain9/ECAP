using ECAP.SharedKernel;

namespace ECAP.Domain.Events.Products;

/// <summary>
/// Event raised when a product is copied
/// </summary>
public sealed record ProductCopiedEvent(
    Guid OriginalProductId,
    Guid NewProductId,
    string OriginalSku,
    string NewSku,
    string? CopiedBy) : DomainEvent;
