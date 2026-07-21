using ECAP.Infrastructure.Persistence.DbContexts;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;

namespace ECAP.Infrastructure.Persistence.Extensions;

/// <summary>
/// Extension methods for database initialization and migrations.
/// </summary>
public static class DatabaseExtensions
{
    /// <summary>
    /// Applies pending migrations and initializes the database.
    /// For production, migrations should be applied via deployment pipeline.
    /// </summary>
    public static async Task InitializeDatabaseAsync(this IHost host)
    {
        using var scope = host.Services.CreateScope();
        var services = scope.ServiceProvider;
        var logger = services.GetRequiredService<ILogger<ApplicationDbContext>>();

        try
        {
            var context = services.GetRequiredService<ApplicationDbContext>();

            logger.LogInformation("Starting database initialization...");

            // Check if database can connect
            var canConnect = await context.Database.CanConnectAsync();
            if (!canConnect)
            {
                logger.LogWarning("Cannot connect to database. Skipping initialization.");
                return;
            }

            // Get pending migrations
            var pendingMigrations = await context.Database.GetPendingMigrationsAsync();
            if (pendingMigrations.Any())
            {
                logger.LogInformation("Applying {Count} pending migrations...", pendingMigrations.Count());
                await context.Database.MigrateAsync();
                logger.LogInformation("Database migrations applied successfully.");
            }
            else
            {
                logger.LogInformation("Database is up to date. No pending migrations.");
            }

            // Seed initial data if needed
            await SeedDataAsync(context, logger);

            logger.LogInformation("Database initialization completed successfully.");
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "An error occurred while initializing the database.");
            throw;
        }
    }

    /// <summary>
    /// Seeds initial data for development and testing.
    /// In production, use migrations or separate seeding scripts.
    /// </summary>
    private static Task SeedDataAsync(ApplicationDbContext _, ILogger __)
    {
        // Add initial seed data here when needed
        // Example:
        // if (!await context.Users.AnyAsync())
        // {
        //     logger.LogInformation("Seeding initial data...");
        //     // Add seed data
        //     await context.SaveChangesAsync();
        // }

        return Task.CompletedTask;
    }

    /// <summary>
    /// Ensures the database is created (for development only).
    /// Do NOT use in production - use migrations instead.
    /// </summary>
    public static async Task EnsureDatabaseCreatedAsync(this IHost host)
    {
        using var scope = host.Services.CreateScope();
        var services = scope.ServiceProvider;
        var logger = services.GetRequiredService<ILogger<ApplicationDbContext>>();

        try
        {
            var context = services.GetRequiredService<ApplicationDbContext>();

            var created = await context.Database.EnsureCreatedAsync();
            if (created)
            {
                logger.LogInformation("Database created successfully.");
            }
            else
            {
                logger.LogInformation("Database already exists.");
            }
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "An error occurred while creating the database.");
            throw;
        }
    }
}
