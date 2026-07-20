using ECAP.Application.Common.Interfaces;
using ECAP.Infrastructure.ExternalServices.Email;
using Microsoft.Extensions.DependencyInjection;

namespace ECAP.Infrastructure.ExternalServices;

/// <summary>
/// Dependency injection configuration for External Services layer.
/// </summary>
public static class DependencyInjection
{
    public static IServiceCollection AddExternalServices(this IServiceCollection services)
    {
        // Register external service implementations
        services.AddScoped<IEmailService, EmailService>();

        // Add payment services, notification services, etc.
        // services.AddScoped<IPaymentService, StripePaymentService>();

        return services;
    }
}
