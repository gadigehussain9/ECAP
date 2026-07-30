using ECAP.Domain.Events.Products;
using MediatR;
using Microsoft.Extensions.Logging;

namespace ECAP.Application.Products.EventHandlers;

/// <summary>
/// Handles ProductActivatedEvent.
/// </summary>
public class ProductActivatedEventHandler : INotificationHandler<ProductActivatedEvent>
{
    private readonly ILogger<ProductActivatedEventHandler> _logger;

    public ProductActivatedEventHandler(ILogger<ProductActivatedEventHandler> logger)
    {
        _logger = logger;
    }

    public Task Handle(ProductActivatedEvent notification, CancellationToken cancellationToken)
    {
        _logger.LogInformation(
            "Product activated: {ProductId} (SKU: {Sku}) by {ActivatedBy}",
            notification.ProductId,
            notification.Sku,
            notification.ActivatedBy);

        // TODO: Add business logic
        // - Update product status in search index
        // - Send notifications to subscribers
        // - Update availability in inventory system

        return Task.CompletedTask;
    }
}
