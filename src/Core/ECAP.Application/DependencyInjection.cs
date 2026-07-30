using ECAP.Application.Common.Behaviors;
using FluentValidation;
using Microsoft.Extensions.DependencyInjection;
using System.Reflection;

namespace ECAP.Application;

/// <summary>
/// Dependency injection configuration for the Application layer
/// </summary>
public static class DependencyInjection
{
    public static IServiceCollection AddApplication(this IServiceCollection services)
    {
        var assembly = Assembly.GetExecutingAssembly();

        // Register MediatR with pipeline behaviors
        services.AddMediatR(config =>
        {
            config.RegisterServicesFromAssembly(assembly);

            // Register pipeline behaviors (order matters!)
            // 1. Logging - logs all requests
            config.AddOpenBehavior(typeof(LoggingBehavior<,>));

            // 2. Validation - validates before handling
            config.AddOpenBehavior(typeof(ValidationBehavior<,>));

            // 3. Performance - measures execution time
            config.AddOpenBehavior(typeof(PerformanceBehavior<,>));
        });

        // Register FluentValidation validators
        services.AddValidatorsFromAssembly(assembly);

        // Register Mapster
        // Mapster doesn't require explicit registration - it works via extension methods

        return services;
    }
}
