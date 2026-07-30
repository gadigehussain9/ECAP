using MediatR;

namespace ECAP.SharedKernel;

/// <summary>
/// Base record for domain events.
/// Domain events represent something that happened in the domain that domain experts care about.
/// </summary>
public abstract record DomainEvent : INotification
{
    /// <summary>
    /// Gets the unique identifier for this event.
    /// </summary>
    public Guid Id { get; init; } = Guid.NewGuid();

    /// <summary>
    /// Gets the date and time when this event occurred (UTC).
    /// </summary>
    public DateTime OccurredOnUtc { get; init; } = DateTime.UtcNow;
}
