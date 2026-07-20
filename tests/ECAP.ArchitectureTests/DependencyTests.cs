using NetArchTest.Rules;
using FluentAssertions;

namespace ECAP.ArchitectureTests;

public class DependencyTests
{
    private const string DomainNamespace = "ECAP.Domain";
    private const string ApplicationNamespace = "ECAP.Application";
    private const string InfrastructureNamespace = "ECAP.Infrastructure";
    private const string PresentationNamespace = "ECAP.Api";

    [Fact]
    public void Domain_Should_Not_HaveDependencyOnOtherProjects()
    {
        // Arrange
        var assembly = typeof(ECAP.Domain.Interfaces.IRepository<,>).Assembly;

        // Act
        var result = Types.InAssembly(assembly)
            .ShouldNot()
            .HaveDependencyOnAll(ApplicationNamespace, InfrastructureNamespace, PresentationNamespace)
            .GetResult();

        // Assert
        result.IsSuccessful.Should().BeTrue();
    }

    [Fact]
    public void Application_Should_Not_HaveDependencyOnInfrastructure()
    {
        // Arrange
        var assembly = typeof(ECAP.Application.Common.Exceptions.NotFoundException).Assembly;

        // Act
        var result = Types.InAssembly(assembly)
            .ShouldNot()
            .HaveDependencyOnAll(InfrastructureNamespace, PresentationNamespace)
            .GetResult();

        // Assert
        result.IsSuccessful.Should().BeTrue();
    }

    [Fact]
    public void Controllers_Should_HaveDependencyOnMediatR()
    {
        // This test ensures controllers use MediatR for CQRS pattern
        // Uncomment when MediatR is added
        // var assembly = typeof(ECAP.Api.Program).Assembly;
        // var result = Types.InAssembly(assembly)
        //     .That()
        //     .ResideInNamespace(PresentationNamespace)
        //     .And()
        //     .HaveNameEndingWith("Controller")
        //     .Should()
        //     .HaveDependencyOn("MediatR")
        //     .GetResult();
        // result.IsSuccessful.Should().BeTrue();
    }
}
