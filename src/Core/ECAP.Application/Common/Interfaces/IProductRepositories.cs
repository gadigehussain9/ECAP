using ECAP.Domain.Entities.Products;

namespace ECAP.Application.Common.Interfaces;

/// <summary>
/// Repository interface for Product aggregate
/// </summary>
public interface IProductRepository
{
    Task<Product?> GetByIdAsync(Guid id, CancellationToken cancellationToken = default);
    Task<Product?> GetBySkuAsync(string sku, CancellationToken cancellationToken = default);
    Task<List<Product>> GetAllAsync(CancellationToken cancellationToken = default);
    Task<List<Product>> SearchAsync(
        string? keyword,
        Guid? brandId,
        Guid? categoryId,
        int pageNumber,
        int pageSize,
        CancellationToken cancellationToken = default);
    Task<int> CountAsync(
        string? keyword,
        Guid? brandId,
        Guid? categoryId,
        CancellationToken cancellationToken = default);
    Task<bool> ExistsBySkuAsync(string sku, CancellationToken cancellationToken = default);
    void Add(Product product);
    void Update(Product product);
    void Delete(Product product);
}

/// <summary>
/// Repository interface for Brand aggregate
/// </summary>
public interface IBrandRepository
{
    Task<Brand?> GetByIdAsync(Guid id, CancellationToken cancellationToken = default);
    Task<List<Brand>> GetAllAsync(bool includeInactive = false, CancellationToken cancellationToken = default);
    Task<bool> ExistsByNameAsync(string name, CancellationToken cancellationToken = default);
    void Add(Brand brand);
    void Update(Brand brand);
    void Delete(Brand brand);
}

/// <summary>
/// Repository interface for Category aggregate
/// </summary>
public interface ICategoryRepository
{
    Task<Category?> GetByIdAsync(Guid id, CancellationToken cancellationToken = default);
    Task<List<Category>> GetAllAsync(bool includeInactive = false, CancellationToken cancellationToken = default);
    Task<List<Category>> GetCategoriesByParentAsync(Guid? parentId, CancellationToken cancellationToken = default);
    Task<bool> ExistsByNameAsync(string name, CancellationToken cancellationToken = default);
    Task<bool> HasChildCategoriesAsync(Guid categoryId, CancellationToken cancellationToken = default);
    void Add(Category category);
    void Update(Category category);
    void Delete(Category category);
}
