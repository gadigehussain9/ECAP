namespace ECAP.SharedKernel;

/// <summary>
/// Represents an error with a code and message.
/// </summary>
public sealed record Error
{
    /// <summary>
    /// Gets the error code (e.g., "Product.NotFound").
    /// </summary>
    public string Code { get; }

    /// <summary>
    /// Gets the human-readable error message.
    /// </summary>
    public string Message { get; }

    public Error(string code, string message)
    {
        Code = code;
        Message = message;
    }

    /// <summary>
    /// Represents no error (successful operation).
    /// </summary>
    public static readonly Error None = new(string.Empty, string.Empty);

    /// <summary>
    /// Represents a null value error.
    /// </summary>
    public static readonly Error NullValue = new("Error.NullValue", "A null value was provided");
}
