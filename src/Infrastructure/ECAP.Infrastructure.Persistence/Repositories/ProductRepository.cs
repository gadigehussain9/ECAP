using ECAP.Application.Common.Interfaces;
using ECAP.Domain.Entities.Products;
using ECAP.Infrastructure.Persistence.DbContexts;
using Microsoft.EntityFrameworkCore;

namespace ECAP.Infrastructure.Persistence.Repositories;

/// <summary>
/// Repository implementation for Product aggregate
/// </summary>
public sealed class ProductRepository : IProductRepository
{
    private readonly ApplicationDbContext _context;

    public ProductRepository(ApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<Product?> GetByIdAsync(Guid id, CancellationToken cancellationToken = default)
    {
        return await _context.Products
            .Include(p => p.Brand)
            .Include(p => p.Category)
            .FirstOrDefaultAsync(p => p.Id == id, cancellationToken);
    }

    public async Task<Product?> GetBySkuAsync(string sku, CancellationToken cancellationToken = default)
    {
        return await _context.Products
            .Include(p => p.Brand)
            .Include(p => p.Category)
            .FirstOrDefaultAsync(p => p.Sku.Value == sku.ToUpper(), cancellationToken);
    }

    public async Task<List<Product>> GetAllAsync(CancellationToken cancellationToken = default)
    {
        return await _context.Products
            .Include(p => p.Brand)
            .Include(p => p.Category)
            .OrderBy(p => p.Name)
            .ToListAsync(cancellationToken);
    }

    public async Task<List<Product>> SearchAsync(
        string? keyword,
        Guid? brandId,
        Guid? categoryId,
        int pageNumber,
        int pageSize,
        CancellationToken cancellationToken = default)
    {
        var query = _context.Products
            .Include(p => p.Brand)
            .Include(p => p.Category)
            .AsQueryable();

        if (!string.IsNullOrWhiteSpace(keyword))
        {
            query = query.Where(p =>
                p.Name.Contains(keyword) ||
                p.Description.Contains(keyword) ||
                p.Sku.Value.Contains(keyword));
        }

        if (brandId.HasValue)
        {
            query = query.Where(p => p.BrandId == brandId.Value);
        }

        if (categoryId.HasValue)
        {
            query = query.Where(p => p.CategoryId == categoryId.Value);
        }

        return await query
            .OrderBy(p => p.Name)
            .Skip((pageNumber - 1) * pageSize)
            .Take(pageSize)
            .ToListAsync(cancellationToken);
    }

    public async Task<int> CountAsync(
        string? keyword,
        Guid? brandId,
        Guid? categoryId,
        CancellationToken cancellationToken = default)
    {
        var query = _context.Products.AsQueryable();

        if (!string.IsNullOrWhiteSpace(keyword))
        {
            query = query.Where(p =>
                p.Name.Contains(keyword) ||
                p.Description.Contains(keyword) ||
                p.Sku.Value.Contains(keyword));
        }

        if (brandId.HasValue)
        {
            query = query.Where(p => p.BrandId == brandId.Value);
        }

        if (categoryId.HasValue)
        {
            query = query.Where(p => p.CategoryId == categoryId.Value);
        }

        return await query.CountAsync(cancellationToken);
    }

    public async Task<bool> ExistsBySkuAsync(string sku, CancellationToken cancellationToken = default)
    {
        return await _context.Products
            .AnyAsync(p => p.Sku.Value == sku.ToUpper(), cancellationToken);
    }

    public void Add(Product product)
    {
        _context.Products.Add(product);
    }

    public void Update(Product product)
    {
        _context.Products.Update(product);
    }

    public void Delete(Product product)
    {
        _context.Products.Remove(product);
    }
}
