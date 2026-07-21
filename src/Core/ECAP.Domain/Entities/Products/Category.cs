using ECAP.SharedKernel;

namespace ECAP.Domain.Entities.Products;

/// <summary>
/// Category aggregate root
/// Supports hierarchical categories (parent-child relationship)
/// </summary>
public sealed class Category : Entity<Guid>
{
    public string Name { get; private set; }
    public string? Description { get; private set; }
    public Guid? ParentCategoryId { get; private set; }
    public bool IsActive { get; private set; }
    public int DisplayOrder { get; private set; }

    // Navigation property (loaded lazily if needed)
    public Category? ParentCategory { get; private set; }

    // Audit fields
    public DateTime CreatedDate { get; private set; }
    public string? CreatedBy { get; private set; }
    public DateTime? UpdatedDate { get; private set; }
    public string? UpdatedBy { get; private set; }
    public bool IsDeleted { get; private set; }

    private Category() { }

    private Category(Guid id, string name, string? description, Guid? parentCategoryId, int displayOrder)
        : base(id)
    {
        Name = name;
        Description = description;
        ParentCategoryId = parentCategoryId;
        DisplayOrder = displayOrder;
        IsActive = true;
        CreatedDate = DateTime.UtcNow;
        IsDeleted = false;
    }

    public static Result<Category> Create(string name, string? description = null, Guid? parentCategoryId = null, int displayOrder = 0)
    {
        if (string.IsNullOrWhiteSpace(name))
        {
            return Result<Category>.Failure(Error.Validation("Category.Name.Empty", "Category name is required"));
        }

        if (name.Length > 100)
        {
            return Result<Category>.Failure(Error.Validation("Category.Name.TooLong", "Category name cannot exceed 100 characters"));
        }

        if (description?.Length > 500)
        {
            return Result<Category>.Failure(Error.Validation("Category.Description.TooLong", "Category description cannot exceed 500 characters"));
        }

        return Result<Category>.Success(new Category(Guid.NewGuid(), name, description, parentCategoryId, displayOrder));
    }

    public Result Update(string name, string? description, Guid? parentCategoryId, int displayOrder, string? updatedBy = null)
    {
        if (string.IsNullOrWhiteSpace(name))
        {
            return Result.Failure(Error.Validation("Category.Name.Empty", "Category name is required"));
        }

        if (name.Length > 100)
        {
            return Result.Failure(Error.Validation("Category.Name.TooLong", "Category name cannot exceed 100 characters"));
        }

        // Prevent self-referencing
        if (parentCategoryId.HasValue && parentCategoryId.Value == Id)
        {
            return Result.Failure(Error.Validation("Category.SelfReference", "A category cannot be its own parent"));
        }

        Name = name;
        Description = description;
        ParentCategoryId = parentCategoryId;
        DisplayOrder = displayOrder;
        UpdatedDate = DateTime.UtcNow;
        UpdatedBy = updatedBy;

        return Result.Success();
    }

    public void Activate()
    {
        IsActive = true;
        UpdatedDate = DateTime.UtcNow;
    }

    public void Deactivate()
    {
        IsActive = false;
        UpdatedDate = DateTime.UtcNow;
    }

    public void Delete(string? deletedBy = null)
    {
        IsDeleted = true;
        UpdatedDate = DateTime.UtcNow;
        UpdatedBy = deletedBy;
    }
}
