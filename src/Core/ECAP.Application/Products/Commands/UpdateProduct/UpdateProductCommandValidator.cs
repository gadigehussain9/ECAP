using FluentValidation;

namespace ECAP.Application.Products.Commands.UpdateProduct;

/// <summary>
/// Validator for UpdateProductCommand
/// </summary>
public sealed class UpdateProductCommandValidator : AbstractValidator<UpdateProductCommand>
{
    public UpdateProductCommandValidator()
    {
        RuleFor(x => x.Id)
            .NotEmpty().WithMessage("Product ID is required");

        RuleFor(x => x.Name)
            .NotEmpty().WithMessage("Product name is required")
            .MaximumLength(200).WithMessage("Product name cannot exceed 200 characters");

        RuleFor(x => x.Description)
            .NotEmpty().WithMessage("Product description is required")
            .MaximumLength(2000).WithMessage("Product description cannot exceed 2000 characters");

        RuleFor(x => x.ShortDescription)
            .MaximumLength(500).WithMessage("Short description cannot exceed 500 characters")
            .When(x => !string.IsNullOrEmpty(x.ShortDescription));

        RuleFor(x => x.BrandId)
            .NotEmpty().WithMessage("Brand is required");

        RuleFor(x => x.CategoryId)
            .NotEmpty().WithMessage("Category is required");

        RuleFor(x => x.Price)
            .GreaterThanOrEqualTo(0).WithMessage("Price cannot be negative");

        RuleFor(x => x.Weight)
            .GreaterThan(0).WithMessage("Weight must be greater than zero")
            .When(x => x.Weight.HasValue);

        RuleFor(x => x.Length)
            .GreaterThan(0).WithMessage("Length must be greater than zero")
            .When(x => x.Length.HasValue);

        RuleFor(x => x.Width)
            .GreaterThan(0).WithMessage("Width must be greater than zero")
            .When(x => x.Width.HasValue);

        RuleFor(x => x.Height)
            .GreaterThan(0).WithMessage("Height must be greater than zero")
            .When(x => x.Height.HasValue);

        RuleFor(x => x.MetaTitle)
            .MaximumLength(100).WithMessage("Meta title cannot exceed 100 characters")
            .When(x => !string.IsNullOrEmpty(x.MetaTitle));

        RuleFor(x => x.MetaDescription)
            .MaximumLength(300).WithMessage("Meta description cannot exceed 300 characters")
            .When(x => !string.IsNullOrEmpty(x.MetaDescription));
    }
}
