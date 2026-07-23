using ECAP.SharedKernel;

namespace ECAP.Domain.Entities.Products;

/// <summary>
/// Brand aggregate root
/// </summary>
public sealed class Brand : Entity<Guid>
{
    public string Name { get; private set; } = string.Empty;
    public string? Description { get; private set; }
    public string? LogoUrl { get; private set; }
    public bool IsActive { get; private set; }

    // Audit fields
    public DateTime CreatedDate { get; private set; }
    public string? CreatedBy { get; private set; }
    public DateTime? UpdatedDate { get; private set; }
    public string? UpdatedBy { get; private set; }
    public bool IsDeleted { get; private set; }

    private Brand() { }

    private Brand(Guid id, string name, string? description, string? logoUrl)
        : base(id)
    {
        Name = name;
        Description = description;
        LogoUrl = logoUrl;
        IsActive = true;
        CreatedDate = DateTime.UtcNow;
        IsDeleted = false;
    }

    public static Result<Brand> Create(string name, string? description = null, string? logoUrl = null)
    {
        if (string.IsNullOrWhiteSpace(name))
        {
            return Result<Brand>.Failure(Error.Validation("Brand.Name.Empty", "Brand name is required"));
        }

        if (name.Length > 100)
        {
            return Result<Brand>.Failure(Error.Validation("Brand.Name.TooLong", "Brand name cannot exceed 100 characters"));
        }

        if (description?.Length > 500)
        {
            return Result<Brand>.Failure(Error.Validation("Brand.Description.TooLong", "Brand description cannot exceed 500 characters"));
        }

        return Result<Brand>.Success(new Brand(Guid.NewGuid(), name, description, logoUrl));
    }

    public Result Update(string name, string? description, string? logoUrl, string? updatedBy = null)
    {
        if (string.IsNullOrWhiteSpace(name))
        {
            return Result.Failure(Error.Validation("Brand.Name.Empty", "Brand name is required"));
        }

        if (name.Length > 100)
        {
            return Result.Failure(Error.Validation("Brand.Name.TooLong", "Brand name cannot exceed 100 characters"));
        }

        Name = name;
        Description = description;
        LogoUrl = logoUrl;
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
