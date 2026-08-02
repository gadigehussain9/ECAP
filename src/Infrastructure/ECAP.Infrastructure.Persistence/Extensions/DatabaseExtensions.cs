using ECAP.Domain.Entities.Products;
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
    private static async Task SeedDataAsync(ApplicationDbContext context, ILogger logger)
    {
        if (await context.Products.AnyAsync())
        {
            return;
        }

        var brandNames = new[] { "Northstar", "Contoso", "Fabrikam", "Adventure Works", "Tailspin" };
        var categoryNames = new[]
        {
            "Electronics", "Home & Kitchen", "Office", "Outdoor", "Sports",
            "Apparel", "Books", "Toys", "Beauty", "Automotive"
        };

        var brands = await context.Brands.ToListAsync();
        foreach (var brandName in brandNames)
        {
            var brand = brands.FirstOrDefault(b => b.Name == brandName);
            if (brand is null)
            {
                var result = Brand.Create(brandName, $"{brandName} test brand");
                if (result.IsFailure)
                {
                    throw new InvalidOperationException(result.Error?.Message ?? $"Unable to create brand {brandName}.");
                }

                brand = result.Value!;
                context.Brands.Add(brand);
                brands.Add(brand);
            }
        }

        var categories = await context.Categories.ToListAsync();
        foreach (var categoryName in categoryNames)
        {
            var category = categories.FirstOrDefault(c => c.Name == categoryName);
            if (category is null)
            {
                var result = Category.Create(categoryName, $"{categoryName} test category");
                if (result.IsFailure)
                {
                    throw new InvalidOperationException(result.Error?.Message ?? $"Unable to create category {categoryName}.");
                }

                category = result.Value!;
                context.Categories.Add(category);
                categories.Add(category);
            }
        }

        await context.SaveChangesAsync();

        var products = new List<Product>(capacity: 50);
        for (var index = 0; index < 50; index++)
        {
            var productResult = Product.Create(
                sku: $"TEST-PROD-{index + 1:000}",
                name: $"Test Product {index + 1:00}",
                description: $"Initial test product {index + 1:00} for development and integration testing.",
                brandId: brands[index % brandNames.Length].Id,
                categoryId: categories[index % categoryNames.Length].Id,
                price: 9.99m + index * 5.00m,
                createdBy: "SeedData");

            if (productResult.IsFailure)
            {
                throw new InvalidOperationException(productResult.Error?.Message ?? $"Unable to create product {index + 1}.");
            }

            var product = productResult.Value!;
            product.Activate("SeedData");
            product.SetInventorySummary(25 + index * 5, index % 4);
            products.Add(product);
        }

        context.Products.AddRange(products);
        await context.SaveChangesAsync();

        logger.LogInformation("Seeded {Count} initial test products.", products.Count);
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
