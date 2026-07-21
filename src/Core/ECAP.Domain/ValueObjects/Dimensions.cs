using ECAP.SharedKernel;

namespace ECAP.Domain.ValueObjects;

/// <summary>
/// Product dimensions (Length x Width x Height)
/// </summary>
public sealed class Dimensions : ValueObject
{
    public decimal Length { get; private set; }
    public decimal Width { get; private set; }
    public decimal Height { get; private set; }
    public string Unit { get; private set; } // cm, inch, etc.

    private Dimensions(decimal length, decimal width, decimal height, string unit)
    {
        Length = length;
        Width = width;
        Height = height;
        Unit = unit;
    }

    public static Result<Dimensions> Create(decimal length, decimal width, decimal height, string unit = "cm")
    {
        if (length <= 0)
        {
            return Result<Dimensions>.Failure(Error.Validation("Dimensions.InvalidLength", "Length must be greater than zero"));
        }

        if (width <= 0)
        {
            return Result<Dimensions>.Failure(Error.Validation("Dimensions.InvalidWidth", "Width must be greater than zero"));
        }

        if (height <= 0)
        {
            return Result<Dimensions>.Failure(Error.Validation("Dimensions.InvalidHeight", "Height must be greater than zero"));
        }

        if (string.IsNullOrWhiteSpace(unit))
        {
            return Result<Dimensions>.Failure(Error.Validation("Dimensions.InvalidUnit", "Unit cannot be empty"));
        }

        return Result<Dimensions>.Success(new Dimensions(length, width, height, unit));
    }

    protected override IEnumerable<object?> GetEqualityComponents()
    {
        yield return Length;
        yield return Width;
        yield return Height;
        yield return Unit;
    }

    public override string ToString() => $"{Length} x {Width} x {Height} {Unit}";
}
