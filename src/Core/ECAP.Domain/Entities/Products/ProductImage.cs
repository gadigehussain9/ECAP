using ECAP.SharedKernel;

namespace ECAP.Domain.Entities.Products;

/// <summary>
/// Product image entity
/// </summary>
public sealed class ProductImage : Entity<Guid>
{
    public Guid ProductId { get; private set; }
    public string Url { get; private set; } = string.Empty;
    public string? AltText { get; private set; }
    public int DisplayOrder { get; private set; }
    public bool IsMain { get; private set; }

    private ProductImage() { }

    private ProductImage(Guid id, Guid productId, string url, string? altText, int displayOrder, bool isMain)
        : base(id)
    {
        ProductId = productId;
        Url = url;
        AltText = altText;
        DisplayOrder = displayOrder;
        IsMain = isMain;
    }

    public static Result<ProductImage> Create(Guid productId, string url, string? altText = null, int displayOrder = 0, bool isMain = false)
    {
        if (productId == Guid.Empty)
        {
            return Result<ProductImage>.Failure(Error.Validation("ProductImage.ProductId.Invalid", "Product ID cannot be empty"));
        }

        if (string.IsNullOrWhiteSpace(url))
        {
            return Result<ProductImage>.Failure(Error.Validation("ProductImage.Url.Empty", "Image URL is required"));
        }

        if (url.Length > 500)
        {
            return Result<ProductImage>.Failure(Error.Validation("ProductImage.Url.TooLong", "Image URL cannot exceed 500 characters"));
        }

        return Result<ProductImage>.Success(new ProductImage(Guid.NewGuid(), productId, url, altText, displayOrder, isMain));
    }

    public void SetAsMain()
    {
        IsMain = true;
    }

    public void UnsetAsMain()
    {
        IsMain = false;
    }

    public void UpdateDisplayOrder(int displayOrder)
    {
        DisplayOrder = displayOrder;
    }
}
