using ECAP.SharedKernel;

namespace ECAP.Domain.ValueObjects;

/// <summary>
/// Stock Keeping Unit - Unique product identifier
/// </summary>
public sealed class SKU : ValueObject
{
    public string Value { get; private set; }

    private SKU(string value)
    {
        Value = value;
    }

    public static Result<SKU> Create(string value)
    {
        if (string.IsNullOrWhiteSpace(value))
        {
            return Result<SKU>.Failure(Error.Validation("SKU.Empty", "SKU cannot be empty"));
        }

        if (value.Length > 50)
        {
            return Result<SKU>.Failure(Error.Validation("SKU.TooLong", "SKU cannot exceed 50 characters"));
        }

        // SKU should be alphanumeric with hyphens allowed
        if (!System.Text.RegularExpressions.Regex.IsMatch(value, @"^[a-zA-Z0-9-]+$"))
        {
            return Result<SKU>.Failure(Error.Validation("SKU.InvalidFormat", "SKU can only contain letters, numbers, and hyphens"));
        }

        return Result<SKU>.Success(new SKU(value.ToUpperInvariant()));
    }

    protected override IEnumerable<object?> GetEqualityComponents()
    {
        yield return Value;
    }

    public override string ToString() => Value;

    public static implicit operator string(SKU sku) => sku.Value;
}
