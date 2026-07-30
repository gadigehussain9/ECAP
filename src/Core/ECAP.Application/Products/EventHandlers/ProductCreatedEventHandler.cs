using ECAP.Domain.Events.Products;
using MediatR;
using Microsoft.Extensions.Logging;

namespace ECAP.Application.Products.EventHandlers;

/// <summary>
/// Handles ProductCreatedEvent.
/// Example: Send notifications, update caches, trigger workflows, etc.
/// </summary>
public class ProductCreatedEventHandler : INotificationHandler<ProductCreatedEvent>
{
    private readonly ILogger<ProductCreatedEventHandler> _logger;

    public ProductCreatedEventHandler(ILogger<ProductCreatedEventHandler> logger)
    {
        _logger = logger;
    }

    public Task Handle(ProductCreatedEvent notification, CancellationToken cancellationToken)
    {
        _logger.LogInformation(
            "Product created: {ProductId} - {ProductName} (SKU: {Sku})",
            notification.ProductId,
            notification.Name,
            notification.Sku);

        // TODO: Add business logic here
        // - Send email notifications
        // - Update search index
        // - Invalidate caches
        // - Trigger downstream workflows

        return Task.CompletedTask;
    }
}
