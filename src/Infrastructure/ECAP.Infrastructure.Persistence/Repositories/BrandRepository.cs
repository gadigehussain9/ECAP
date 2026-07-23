using ECAP.Application.Common.Interfaces;
using ECAP.Domain.Entities.Products;
using ECAP.Infrastructure.Persistence.DbContexts;
using Microsoft.EntityFrameworkCore;

namespace ECAP.Infrastructure.Persistence.Repositories;

/// <summary>
/// Repository implementation for Brand aggregate
/// </summary>
public sealed class BrandRepository : IBrandRepository
{
    private readonly ApplicationDbContext _context;

    public BrandRepository(ApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<Brand?> GetByIdAsync(Guid id, CancellationToken cancellationToken = default)
    {
        return await _context.Brands
            .FirstOrDefaultAsync(b => b.Id == id, cancellationToken);
    }

    public async Task<List<Brand>> GetAllAsync(bool includeInactive = false, CancellationToken cancellationToken = default)
    {
        var query = _context.Brands.AsQueryable();

        if (!includeInactive)
        {
            query = query.Where(b => b.IsActive);
        }

        return await query
            .OrderBy(b => b.Name)
            .ToListAsync(cancellationToken);
    }

    public async Task<bool> ExistsByNameAsync(string name, CancellationToken cancellationToken = default)
    {
        return await _context.Brands
            .AnyAsync(b => b.Name == name, cancellationToken);
    }

    public void Add(Brand brand)
    {
        _context.Brands.Add(brand);
    }

    public void Update(Brand brand)
    {
        _context.Brands.Update(brand);
    }

    public void Delete(Brand brand)
    {
        _context.Brands.Remove(brand);
    }
}
