#pragma warning disable CS8602, CS8604 // Null checks handled by Result pattern
using ECAP.Application.Common.Interfaces;
using ECAP.Application.Products.Common;
using ECAP.Domain.Entities.Products;
using ECAP.Domain.Interfaces;
using ECAP.Domain.ValueObjects;
using ECAP.SharedKernel;
using Mapster;
using MediatR;
using Microsoft.Extensions.Logging;

namespace ECAP.Application.Products.Commands.CreateProduct;

/// <summary>
/// Handler for CreateProductCommand
/// </summary>
public sealed class CreateProductCommandHandler : IRequestHandler<CreateProductCommand, Result<ProductDto>>
{
    private readonly IProductRepository _productRepository;
    private readonly IBrandRepository _brandRepository;
    private readonly ICategoryRepository _categoryRepository;
    private readonly IUnitOfWork _unitOfWork;
    private readonly ILogger<CreateProductCommandHandler> _logger;

    public CreateProductCommandHandler(
        IProductRepository productRepository,
        IBrandRepository brandRepository,
        ICategoryRepository categoryRepository,
        IUnitOfWork unitOfWork,
        ILogger<CreateProductCommandHandler> logger)
    {
        _productRepository = productRepository;
        _brandRepository = brandRepository;
        _categoryRepository = categoryRepository;
        _unitOfWork = unitOfWork;
        _logger = logger;
    }

    public async Task<Result<ProductDto>> Handle(CreateProductCommand request, CancellationToken cancellationToken)
    {
        _logger.LogInformation(
            "Creating product with SKU: {Sku}, Name: {Name}, BrandId: {BrandId}",
            request.Sku,
            request.Name,
            request.BrandId);

        // Check if SKU already exists
        if (await _productRepository.ExistsBySkuAsync(request.Sku, cancellationToken))
        {
            _logger.LogWarning("Product creation failed: Duplicate SKU {Sku}", request.Sku);
            return Result<ProductDto>.Failure(
                Error.Conflict("Product.Sku.Duplicate", $"A product with SKU '{request.Sku}' already exists"));
        }

        // Validate brand exists
        var brand = await _brandRepository.GetByIdAsync(request.BrandId, cancellationToken);
        if (brand is null)
        {
            _logger.LogWarning("Product creation failed: Brand not found {BrandId}", request.BrandId);
            return Result<ProductDto>.Failure(
                Error.NotFound("Brand.NotFound", $"Brand with ID '{request.BrandId}' was not found"));
        }

        if (!brand.IsActive)
        {
            return Result<ProductDto>.Failure(
                Error.Validation("Brand.Inactive", "Cannot create product with inactive brand"));
        }

        // Validate category exists
        var category = await _categoryRepository.GetByIdAsync(request.CategoryId, cancellationToken);
        if (category is null)
        {
            return Result<ProductDto>.Failure(
                Error.NotFound("Category.NotFound", $"Category with ID '{request.CategoryId}' was not found"));
        }

        if (!category.IsActive)
        {
            return Result<ProductDto>.Failure(
                Error.Validation("Category.Inactive", "Cannot create product with inactive category"));
        }

        // Create product
        var productResult = Product.Create(
            request.Sku,
            request.Name,
            request.Description,
            request.BrandId,
            request.CategoryId,
            request.Price,
            request.Currency);

        if (productResult.IsFailure)
        {
            return Result<ProductDto>.Failure(productResult.Error);
        }

        var product = productResult.Value;

        // Set optional fields
        if (!string.IsNullOrWhiteSpace(request.ShortDescription))
        {
            var updateResult = product.Update(
                request.Name,
                request.Description,
                request.ShortDescription,
                request.BrandId,
                request.CategoryId,
                request.Price);

            if (updateResult.IsFailure)
            {
                return Result<ProductDto>.Failure(updateResult.Error);
            }
        }

        // Set weight if provided
        if (request.Weight.HasValue && !string.IsNullOrWhiteSpace(request.WeightUnit))
        {
            var weightResult = Weight.Create(request.Weight.Value, request.WeightUnit);
            if (weightResult.IsFailure)
            {
                return Result<ProductDto>.Failure(weightResult.Error);
            }
            product.SetWeight(weightResult.Value);
        }

        // Set dimensions if provided
        if (request.Length.HasValue && request.Width.HasValue && request.Height.HasValue &&
            !string.IsNullOrWhiteSpace(request.DimensionUnit))
        {
            var dimensionsResult = Dimensions.Create(
                request.Length.Value,
                request.Width.Value,
                request.Height.Value,
                request.DimensionUnit);

            if (dimensionsResult.IsFailure)
            {
                return Result<ProductDto>.Failure(dimensionsResult.Error);
            }
            product.SetDimensions(dimensionsResult.Value);
        }

        // Set SEO fields
        if (!string.IsNullOrWhiteSpace(request.MetaTitle) ||
            !string.IsNullOrWhiteSpace(request.MetaDescription) ||
            !string.IsNullOrWhiteSpace(request.MetaKeywords))
        {
            product.SetSeo(request.MetaTitle, request.MetaDescription, request.MetaKeywords);
        }

        // Add images
        if (request.Images is not null && request.Images.Any())
        {
            foreach (var image in request.Images)
            {
                var imageResult = product.AddImage(image.Url, image.AltText, image.DisplayOrder, image.IsMain);
                if (imageResult.IsFailure)
                {
                    return Result<ProductDto>.Failure(imageResult.Error);
                }
            }
        }

        // Save to repository
        _productRepository.Add(product);
        await _unitOfWork.SaveChangesAsync(cancellationToken);

        // Map to DTO
        var dto = product.Adapt<ProductDto>();
        dto = dto with
        {
            BrandName = brand.Name,
            CategoryName = category.Name,
            IsLowStock = product.IsLowStock()
        };

        return Result<ProductDto>.Success(dto);
    }
}
