namespace ECAP.Domain.Enums;

/// <summary>
/// Product lifecycle status
/// </summary>
public enum ProductStatus
{
    /// <summary>
    /// Product is in draft state, not visible to customers
    /// </summary>
    Draft = 0,

    /// <summary>
    /// Product is active and available for sale
    /// </summary>
    Active = 1,

    /// <summary>
    /// Product is temporarily inactive, not available for sale
    /// </summary>
    Inactive = 2,

    /// <summary>
    /// Product is discontinued, permanently unavailable
    /// </summary>
    Discontinued = 3
}
