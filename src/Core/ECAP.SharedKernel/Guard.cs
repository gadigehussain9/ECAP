namespace ECAP.SharedKernel;

/// <summary>
/// Provides guard clauses to validate method arguments and business rules.
/// </summary>
public static class Guard
{
    /// <summary>
    /// Guards against a null argument.
    /// </summary>
    public static void AgainstNull(object? value, string parameterName)
    {
        if (value is null)
        {
            throw new ArgumentNullException(parameterName);
        }
    }

    /// <summary>
    /// Guards against a null or empty string argument.
    /// </summary>
    public static void AgainstNullOrEmpty(string? value, string parameterName)
    {
        if (string.IsNullOrWhiteSpace(value))
        {
            throw new ArgumentException("Value cannot be null or empty", parameterName);
        }
    }

    /// <summary>
    /// Guards against a negative number.
    /// </summary>
    public static void AgainstNegative(int value, string parameterName)
    {
        if (value < 0)
        {
            throw new ArgumentException($"Value cannot be negative: {value}", parameterName);
        }
    }

    /// <summary>
    /// Guards against a negative decimal number.
    /// </summary>
    public static void AgainstNegative(decimal value, string parameterName)
    {
        if (value < 0)
        {
            throw new ArgumentException($"Value cannot be negative: {value}", parameterName);
        }
    }

    /// <summary>
    /// Guards against a value that is out of the specified range.
    /// </summary>
    public static void AgainstOutOfRange<T>(T value, T min, T max, string parameterName)
        where T : IComparable<T>
    {
        if (value.CompareTo(min) < 0 || value.CompareTo(max) > 0)
        {
            throw new ArgumentOutOfRangeException(parameterName, $"Value must be between {min} and {max}");
        }
    }

    /// <summary>
    /// Guards against an invalid enum value.
    /// </summary>
    public static void AgainstInvalidEnum<TEnum>(TEnum value, string parameterName)
        where TEnum : struct, Enum
    {
        if (!Enum.IsDefined(typeof(TEnum), value))
        {
            throw new ArgumentException($"Invalid enum value: {value}", parameterName);
        }
    }
}
