using ECAP.Domain.Interfaces;
using ECAP.Infrastructure.Persistence.DbContexts;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;

namespace ECAP.Infrastructure.Persistence;

/// <summary>
/// Dependency injection configuration for the Persistence layer.
/// </summary>
public static class DependencyInjection
{
    public static IServiceCollection AddPersistence(this IServiceCollection services, string connectionString)
    {
        // Register DbContext
        services.AddDbContext<ApplicationDbContext>(options =>
            options.UseSqlServer(connectionString));

        // Register Unit of Work
        services.AddScoped<IUnitOfWork, UnitOfWork>();

        // Register repositories (add specific repository registrations here)
        // services.AddScoped(typeof(IRepository<,>), typeof(Repository<,>));

        return services;
    }
}
