using Microsoft.Extensions.DependencyInjection;

namespace ECAP.Infrastructure.Messaging;

/// <summary>
/// Dependency injection configuration for Messaging layer.
/// </summary>
public static class DependencyInjection
{
    public static IServiceCollection AddMessaging(this IServiceCollection services)
    {
        // Register message bus implementations (RabbitMQ, Azure Service Bus, etc.)
        // services.AddSingleton<IEventBus, RabbitMQEventBus>();

        return services;
    }
}
