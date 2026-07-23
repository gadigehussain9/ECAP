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

    /// <summary>
    /// Gets the error type (Validation, NotFound, Conflict, etc.).
    /// </summary>
    public string Type { get; }

    public Error(string code, string message, string type = "Error")
    {
        Code = code;
        Message = message;
        Type = type;
    }

    /// <summary>
    /// Represents no error (successful operation).
    /// </summary>
    public static readonly Error None = new(string.Empty, string.Empty);

    /// <summary>
    /// Represents a null value error.
    /// </summary>
    public static readonly Error NullValue = new("Error.NullValue", "A null value was provided");

    /// <summary>
    /// Creates a validation error.
    /// </summary>
    public static Error Validation(string code, string message) =>
        new(code, message, "Validation");

    /// <summary>
    /// Creates a not found error.
    /// </summary>
    public static Error NotFound(string code, string message) =>
        new(code, message, "NotFound");

    /// <summary>
    /// Creates a conflict error.
    /// </summary>
    public static Error Conflict(string code, string message) =>
        new(code, message, "Conflict");

    /// <summary>
    /// Creates an unauthorized error.
    /// </summary>
    public static Error Unauthorized(string code, string message) =>
        new(code, message, "Unauthorized");

    /// <summary>
    /// Creates a forbidden error.
    /// </summary>
    public static Error Forbidden(string code, string message) =>
        new(code, message, "Forbidden");
}
