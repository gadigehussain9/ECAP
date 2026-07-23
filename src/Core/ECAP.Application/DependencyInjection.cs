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

        // Register MediatR
        services.AddMediatR(config =>
        {
            config.RegisterServicesFromAssembly(assembly);
        });

        // Register FluentValidation validators
        services.AddValidatorsFromAssembly(assembly);

        // Register Mapster
        // Mapster doesn't require explicit registration - it works via extension methods

        return services;
    }
}
