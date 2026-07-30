using ECAP.SharedKernel;
using FluentValidation;
using MediatR;

namespace ECAP.Application.Common.Behaviors;

/// <summary>
/// Pipeline behavior that validates requests using FluentValidation before handling.
/// </summary>
/// <typeparam name="TRequest">The request type</typeparam>
/// <typeparam name="TResponse">The response type (must be Result-based)</typeparam>
public class ValidationBehavior<TRequest, TResponse> : IPipelineBehavior<TRequest, TResponse>
    where TRequest : IRequest<TResponse>
{
    private readonly IEnumerable<IValidator<TRequest>> _validators;

    public ValidationBehavior(IEnumerable<IValidator<TRequest>> validators)
    {
        _validators = validators;
    }

    public async Task<TResponse> Handle(
        TRequest request,
        RequestHandlerDelegate<TResponse> next,
        CancellationToken cancellationToken)
    {
        if (!_validators.Any())
        {
            return await next();
        }

        var context = new ValidationContext<TRequest>(request);

        var validationResults = await Task.WhenAll(
            _validators.Select(v => v.ValidateAsync(context, cancellationToken)));

        var failures = validationResults
            .Where(r => r.Errors.Any())
            .SelectMany(r => r.Errors)
            .ToList();

        if (failures.Any())
        {
            // Build validation error
            var errorMessages = failures
                .Select(f => $"{f.PropertyName}: {f.ErrorMessage}")
                .ToList();

            var error = Error.Validation(
                "Validation.Failed",
                $"One or more validation failures occurred: {string.Join("; ", errorMessages)}");

            // Return a failed Result
            // This assumes TResponse is Result<T> or Result
            return CreateValidationResult<TResponse>(error);
        }

        return await next();
    }

    private static TResult CreateValidationResult<TResult>(Error error)
    {
        // Check if TResult is Result<T>
        if (typeof(TResult).IsGenericType &&
            typeof(TResult).GetGenericTypeDefinition() == typeof(Result<>))
        {
            var resultType = typeof(TResult).GetGenericArguments()[0];
            var failureMethod = typeof(Result<>)
                .MakeGenericType(resultType)
                .GetMethod(nameof(Result<object>.Failure), new[] { typeof(Error) });

            return (TResult)failureMethod!.Invoke(null, new object[] { error })!;
        }

        // Check if TResult is Result
        if (typeof(TResult) == typeof(Result))
        {
            return (TResult)(object)Result.Failure(error);
        }

        throw new InvalidOperationException(
            $"TResponse must be Result or Result<T>. Actual type: {typeof(TResult).Name}");
    }
}
