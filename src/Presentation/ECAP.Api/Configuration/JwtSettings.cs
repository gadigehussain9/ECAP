namespace ECAP.Api.Configuration;

/// <summary>
/// JWT authentication configuration settings
/// </summary>
public class JwtSettings
{
    public const string SectionName = "JwtSettings";

    /// <summary>
    /// Secret key for signing tokens (should be in Key Vault in production)
    /// </summary>
    public string Secret { get; init; } = string.Empty;

    /// <summary>
    /// Token issuer (who creates the token)
    /// </summary>
    public string Issuer { get; init; } = string.Empty;

    /// <summary>
    /// Token audience (who can use the token)
    /// </summary>
    public string Audience { get; init; } = string.Empty;

    /// <summary>
    /// Token expiration in minutes (default: 60 minutes)
    /// </summary>
    public int ExpirationMinutes { get; init; } = 60;

    /// <summary>
    /// Refresh token expiration in days (default: 7 days)
    /// </summary>
    public int RefreshTokenExpirationDays { get; init; } = 7;
}
