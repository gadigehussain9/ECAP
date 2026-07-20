using ECAP.SharedKernel;

namespace ECAP.Domain.ValueObjects;

/// <summary>
/// Value object representing money (amount and currency).
/// </summary>
public sealed class Money : ValueObject
{
    public decimal Amount { get; }
    public string Currency { get; }

    private Money(decimal amount, string currency)
    {
        Amount = amount;
        Currency = currency;
    }

    public static Money Create(decimal amount, string currency)
    {
        Guard.AgainstNegative(amount, nameof(amount));
        Guard.AgainstNullOrEmpty(currency, nameof(currency));

        return new Money(amount, currency);
    }

    protected override IEnumerable<object?> GetEqualityComponents()
    {
        yield return Amount;
        yield return Currency;
    }

    public override string ToString() => $"{Amount:N2} {Currency}";
}
