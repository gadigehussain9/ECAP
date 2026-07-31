using ECAP.Application.Products.Common;
using ECAP.Domain.Entities.Products;
using Mapster;

namespace ECAP.Application.Common.Mappings;

/// <summary>
/// Mapster configuration for mapping domain entities to DTOs
/// </summary>
public static class MapsterConfiguration
{
#pragma warning disable IDE0041 // ReferenceEquals is required for expression trees - null-conditional/pattern operators are not supported
    public static void RegisterMappings()
    {
        // Configure Product to ProductDto mapping
        TypeAdapterConfig<Product, ProductDto>.NewConfig()
            .Map(dest => dest.Sku, src => src.Sku.Value)
            .Map(dest => dest.Status, src => src.Status.ToString())
            .Map(dest => dest.Weight, src => ReferenceEquals(src.Weight, null) ? default(decimal?) : (decimal?)src.Weight.Value)
            .Map(dest => dest.WeightUnit, src => ReferenceEquals(src.Weight, null) ? default(string) : src.Weight.Unit)
            .Map(dest => dest.Dimensions, src => ReferenceEquals(src.Dimensions, null) ? default(string) : src.Dimensions.ToString())
            .Map(dest => dest.BrandName, src => ReferenceEquals(src.Brand, null) ? string.Empty : src.Brand.Name)
            .Map(dest => dest.CategoryName, src => ReferenceEquals(src.Category, null) ? string.Empty : src.Category.Name)
            .Map(dest => dest.IsLowStock, src => src.IsLowStock())
            .Map(dest => dest.Images, src => src.Images);

        // Configure ProductImage to ProductImageDto mapping
        TypeAdapterConfig<ProductImage, ProductImageDto>.NewConfig();

        // Configure Brand to BrandDto mapping
        TypeAdapterConfig<Brand, BrandDto>.NewConfig();

        // Configure Category to CategoryDto mapping
        TypeAdapterConfig<Category, CategoryDto>.NewConfig()
            .Map(dest => dest.ParentCategoryName, src => ReferenceEquals(src.ParentCategory, null) ? default(string) : src.ParentCategory.Name);
    }
#pragma warning restore IDE0041
}
