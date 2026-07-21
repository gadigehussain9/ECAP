using ECAP.Domain.Interfaces;
using ECAP.Infrastructure.Persistence.DbContexts;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Diagnostics.HealthChecks;

namespace ECAP.Infrastructure.Persistence;

/// <summary>
/// Dependency injection configuration for the Persistence layer.
/// </summary>
public static class DependencyInjection
{
    public static IServiceCollection AddPersistence(this IServiceCollection services, string connectionString)
    {
        // Register DbContext with connection resiliency for production
        services.AddDbContext<ApplicationDbContext>(options =>
        {
            options.UseSqlServer(connectionString, sqlOptions =>
            {
                // Enable connection resiliency (retry on transient failures)
                sqlOptions.EnableRetryOnFailure(
                    maxRetryCount: 5,
                    maxRetryDelay: TimeSpan.FromSeconds(30),
                    errorNumbersToAdd: null);

                // Command timeout for long-running queries
                sqlOptions.CommandTimeout(30);

                // Enable query splitting for better performance with includes
                sqlOptions.UseQuerySplittingBehavior(QuerySplittingBehavior.SplitQuery);
            });

            // Enable sensitive data logging only in development
            // options.EnableSensitiveDataLogging();
            // options.EnableDetailedErrors();
        });

        // Register Unit of Work
        services.AddScoped<IUnitOfWork, UnitOfWork>();

        // Register repositories (add specific repository registrations here)
        // services.AddScoped(typeof(IRepository<,>), typeof(Repository<,>));

        // Add health checks for SQL Server
        services.AddHealthChecks().AddSqlServer(connectionString);

        return services;
    }
}
