using Microsoft.Extensions.DependencyInjection;

namespace ECAP.Infrastructure.Identity;

/// <summary>
/// Dependency injection configuration for the Identity layer.
/// </summary>
public static class DependencyInjection
{
    public static IServiceCollection AddIdentity(this IServiceCollection services)
    {
        // Register JWT authentication services
        // services.AddScoped<ITokenService, TokenService>();
        // services.AddScoped<IIdentityService, IdentityService>();

        return services;
    }
}
