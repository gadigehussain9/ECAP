using ECAP.Application.Common.Interfaces;
using ECAP.Domain.Entities.Products;
using ECAP.Infrastructure.Persistence.DbContexts;
using Microsoft.EntityFrameworkCore;

namespace ECAP.Infrastructure.Persistence.Repositories;

/// <summary>
/// Repository implementation for Category aggregate
/// </summary>
public sealed class CategoryRepository : ICategoryRepository
{
    private readonly ApplicationDbContext _context;

    public CategoryRepository(ApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<Category?> GetByIdAsync(Guid id, CancellationToken cancellationToken = default)
    {
        return await _context.Categories
            .FirstOrDefaultAsync(c => c.Id == id, cancellationToken);
    }

    public async Task<List<Category>> GetAllAsync(bool includeInactive = false, CancellationToken cancellationToken = default)
    {
        var query = _context.Categories.AsQueryable();

        if (!includeInactive)
        {
            query = query.Where(c => c.IsActive);
        }

        return await query
            .OrderBy(c => c.DisplayOrder)
            .ThenBy(c => c.Name)
            .ToListAsync(cancellationToken);
    }

    public async Task<List<Category>> GetCategoriesByParentAsync(Guid? parentId, CancellationToken cancellationToken = default)
    {
        return await _context.Categories
            .Where(c => c.ParentCategoryId == parentId)
            .OrderBy(c => c.DisplayOrder)
            .ThenBy(c => c.Name)
            .ToListAsync(cancellationToken);
    }

    public async Task<bool> ExistsByNameAsync(string name, CancellationToken cancellationToken = default)
    {
        return await _context.Categories
            .AnyAsync(c => c.Name == name, cancellationToken);
    }

    public async Task<bool> HasChildCategoriesAsync(Guid categoryId, CancellationToken cancellationToken = default)
    {
        return await _context.Categories
            .AnyAsync(c => c.ParentCategoryId == categoryId, cancellationToken);
    }

    public void Add(Category category)
    {
        _context.Categories.Add(category);
    }

    public void Update(Category category)
    {
        _context.Categories.Update(category);
    }

    public void Delete(Category category)
    {
        _context.Categories.Remove(category);
    }
}
