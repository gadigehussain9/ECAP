# Contributing to ECAP

First off, thank you for considering contributing to ECAP! It's people like you that make ECAP such a great platform.

## Code of Conduct

This project and everyone participating in it is governed by our Code of Conduct. By participating, you are expected to uphold this code. Please report unacceptable behavior to the project maintainers.

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check the issue list as you might find out that you don't need to create one. When you are creating a bug report, please include as many details as possible using the bug report template.

**Great Bug Reports** tend to have:

- A quick summary and/or background
- Steps to reproduce (be specific!)
- What you expected would happen
- What actually happens
- Notes (possibly including why you think this might be happening, or stuff you tried that didn't work)

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion, please include:

- A clear and descriptive title
- A detailed description of the proposed functionality
- Explain why this enhancement would be useful
- List any alternative solutions you've considered

### Your First Code Contribution

Unsure where to begin? You can start by looking through these issues:

- `good-first-issue` - issues which should only require a few lines of code
- `help-wanted` - issues which should be a bit more involved

### Pull Requests

1. **Fork the repository** and create your branch from `develop`
2. **Follow the coding standards** documented in [docs/development/coding-standards.md](docs/development/coding-standards.md)
3. **Write tests** for your changes
4. **Ensure the test suite passes**
5. **Ensure architecture tests pass** (run `dotnet test tests/ECAP.ArchitectureTests`)
6. **Update documentation** as needed
7. **Follow the PR template** when submitting

#### PR Checklist

Before submitting your PR, ensure:

- [ ] Code follows the project's coding standards
- [ ] All tests pass (`dotnet test`)
- [ ] Architecture tests pass
- [ ] Code coverage hasn't decreased
- [ ] No compiler warnings introduced
- [ ] Documentation updated (if applicable)
- [ ] ADR created (for architectural changes)
- [ ] CHANGELOG.md updated

## Development Process

### Branch Strategy

- `main` - production-ready code
- `develop` - integration branch for features
- `feature/*` - feature branches
- `hotfix/*` - urgent production fixes

### Commit Messages

Follow conventional commits:

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:**
- `feat`: A new feature
- `fix`: A bug fix
- `docs`: Documentation only changes
- `style`: Changes that don't affect code meaning (formatting, etc.)
- `refactor`: Code change that neither fixes a bug nor adds a feature
- `perf`: Performance improvements
- `test`: Adding or correcting tests
- `chore`: Changes to build process or auxiliary tools

**Example:**
```
feat(catalog): add product search functionality

Implemented full-text search for products using EF Core.
Added unit and integration tests.

Closes #123
```

## Coding Standards

### General Guidelines

- Follow [C# Coding Conventions](https://docs.microsoft.com/en-us/dotnet/csharp/fundamentals/coding-style/coding-conventions)
- Use meaningful variable and method names
- Keep methods small and focused
- Write self-documenting code; add comments only when necessary
- Follow SOLID principles
- Prefer composition over inheritance

### Clean Architecture Rules

**Dependency Direction:**
- Core (Domain, Application) must not reference Infrastructure or Presentation
- Infrastructure and Presentation depend on Application and Domain
- All dependencies point inward

**Project-Specific Rules:**
- Domain contains only business logic (no dependencies on frameworks)
- Application contains use cases (MediatR handlers, interfaces)
- Infrastructure implements Application interfaces
- API controllers are thin (delegate to MediatR)

### Testing Requirements

- **Unit tests** for Domain and Application logic
- **Integration tests** for API endpoints and database operations
- **Architecture tests** to enforce dependency rules
- Aim for **80%+ code coverage**
- Use meaningful test names: `MethodName_Scenario_ExpectedResult`

Example:
```csharp
[Fact]
public void Create_WithValidAmount_ShouldReturnMoney()
{
    // Arrange
    var amount = 100m;
    var currency = "USD";

    // Act
    var result = Money.Create(amount, currency);

    // Assert
    result.IsSuccess.Should().BeTrue();
    result.Value.Amount.Should().Be(amount);
    result.Value.Currency.Should().Be(currency);
}
```

### Feature Organization

Use vertical slices for Application features:

```
Features/
└── Catalog/
    ├── Commands/
    │   └── CreateProduct/
    │       ├── CreateProductCommand.cs
    │       ├── CreateProductHandler.cs
    │       └── CreateProductValidator.cs
    └── Queries/
        └── GetProduct/
            ├── GetProductQuery.cs
            └── GetProductHandler.cs
```

## Setting Up Development Environment

```bash
# Clone your fork
git clone https://github.com/YOUR_USERNAME/ECAP.git
cd ECAP

# Add upstream remote
git remote add upstream https://github.com/gadigehussain9/ECAP.git

# Create feature branch
git checkout -b feature/my-feature develop

# Restore packages
dotnet restore

# Build
dotnet build

# Run tests
dotnet test

# Run the API
dotnet run --project src/Presentation/ECAP.Api
```

## Need Help?

- Check the [documentation](docs/)
- Open an issue with the `question` label
- Contact maintainers

## Recognition

Contributors will be acknowledged in:
- CHANGELOG.md for their contributions
- README.md contributors section
- GitHub's contributor graph

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
