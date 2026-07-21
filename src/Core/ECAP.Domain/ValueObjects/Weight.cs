using ECAP.SharedKernel;

namespace ECAP.Domain.ValueObjects;

/// <summary>
/// Product weight
/// </summary>
public sealed class Weight : ValueObject
{
    public decimal Value { get; private set; }
    public string Unit { get; private set; } // kg, lb, g, oz

    private Weight(decimal value, string unit)
    {
        Value = value;
        Unit = unit;
    }

    public static Result<Weight> Create(decimal value, string unit = "kg")
    {
        if (value <= 0)
        {
            return Result<Weight>.Failure(Error.Validation("Weight.InvalidValue", "Weight must be greater than zero"));
        }

        if (value > 10000)
        {
            return Result<Weight>.Failure(Error.Validation("Weight.ValueTooLarge", "Weight exceeds maximum allowed value"));
        }

        if (string.IsNullOrWhiteSpace(unit))
        {
            return Result<Weight>.Failure(Error.Validation("Weight.InvalidUnit", "Unit cannot be empty"));
        }

        return Result<Weight>.Success(new Weight(value, unit));
    }

    protected override IEnumerable<object?> GetEqualityComponents()
    {
        yield return Value;
        yield return Unit;
    }

    public override string ToString() => $"{Value} {Unit}";
}
