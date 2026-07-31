using ECAP.Domain.Entities.Products;
using ECAP.SharedKernel;
using MediatR;
using Microsoft.EntityFrameworkCore;

namespace ECAP.Infrastructure.Persistence.DbContexts;

/// <summary>
/// Main application database context.
/// </summary>
public class ApplicationDbContext : DbContext
{
    private readonly IPublisher? _publisher;

    public ApplicationDbContext(
        DbContextOptions<ApplicationDbContext> options,
        IPublisher? publisher = null)
        : base(options)
    {
        _publisher = publisher;
    }

    // Product Catalog
    public DbSet<Product> Products => Set<Product>();
    public DbSet<Brand> Brands => Set<Brand>();
    public DbSet<Category> Categories => Set<Category>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        // Apply all entity configurations from this assembly
        modelBuilder.ApplyConfigurationsFromAssembly(typeof(ApplicationDbContext).Assembly);

        // Ignore DomainEvents property for all entities (it's not a navigation property)
        foreach (var entityType in modelBuilder.Model.GetEntityTypes())
        {
            // Skip owned entity types - they are configured through their owner
            if (entityType.IsOwned())
            {
                continue;
            }

            var domainEventsProperty = entityType.ClrType.GetProperty("DomainEvents");
            if (domainEventsProperty != null)
            {
                modelBuilder.Entity(entityType.ClrType).Ignore(domainEventsProperty.Name);
            }
        }

        // Add global query filters for soft delete
        modelBuilder.Entity<Product>().HasQueryFilter(p => !p.IsDeleted);
        modelBuilder.Entity<Brand>().HasQueryFilter(b => !b.IsDeleted);
        modelBuilder.Entity<Category>().HasQueryFilter(c => !c.IsDeleted);
    }

    public override async Task<int> SaveChangesAsync(CancellationToken cancellationToken = default)
    {
        // Collect domain events before saving
        var domainEvents = ChangeTracker.Entries<Entity<Guid>>()
            .Select(e => e.Entity)
            .Where(e => e.DomainEvents.Any())
            .SelectMany(e => e.DomainEvents)
            .ToList();

        // Save changes
        var result = await base.SaveChangesAsync(cancellationToken);

        // Dispatch domain events after successful save
        if (_publisher != null)
        {
            foreach (var domainEvent in domainEvents)
            {
                await _publisher.Publish(domainEvent, cancellationToken);
            }
        }

        // Clear domain events
        foreach (var entity in ChangeTracker.Entries<Entity<Guid>>()
            .Select(e => e.Entity)
            .Where(e => e.DomainEvents.Any()))
        {
            entity.ClearDomainEvents();
        }

        return result;
    }
}
