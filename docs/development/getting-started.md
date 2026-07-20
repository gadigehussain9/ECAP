# Getting Started with ECAP

## Prerequisites

- [.NET 10 SDK](https://dotnet.microsoft.com/download/dotnet/10.0)
- [Visual Studio 2026](https://visualstudio.microsoft.com/) or [Visual Studio Code](https://code.visualstudio.com/)
- SQL Server (LocalDB is included with Visual Studio)
- [Docker Desktop](https://www.docker.com/products/docker-desktop) (optional, for containerized development)

## Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/gadigehussain9/ECAP.git
cd ECAP
```

### 2. Restore Dependencies

```bash
dotnet restore
```

### 3. Update Database

```bash
cd src/Presentation/ECAP.Api
dotnet ef database update --project ../../Infrastructure/ECAP.Infrastructure.Persistence
```

### 4. Run the Application

```bash
dotnet run --project src/Presentation/ECAP.Api/ECAP.Api.csproj
```

The API will be available at `https://localhost:5001` and Swagger UI at `https://localhost:5001/swagger`.

## Project Structure

```
ECAP/
├── src/
│   ├── Core/
│   │   ├── ECAP.SharedKernel/        # Domain primitives
│   │   ├── ECAP.Domain/              # Business entities
│   │   └── ECAP.Application/         # Use cases (CQRS)
│   ├── Infrastructure/
│   │   ├── ECAP.Infrastructure.Persistence/      # EF Core, DbContext
│   │   ├── ECAP.Infrastructure.Identity/         # Authentication
│   │   ├── ECAP.Infrastructure.ExternalServices/ # Email, Payment
│   │   └── ECAP.Infrastructure.Messaging/        # Event Bus
│   └── Presentation/
│       └── ECAP.Api/                 # ASP.NET Core Web API
├── tests/
│   ├── ECAP.UnitTests/
│   ├── ECAP.IntegrationTests/
│   ├── ECAP.ArchitectureTests/
│   └── ECAP.PerformanceTests/
├── docs/                             # Documentation
├── infrastructure/                   # IaC (Terraform, K8s, Helm)
└── scripts/                          # Automation scripts
```

## Running Tests

```bash
# Run all tests
dotnet test

# Run unit tests only
dotnet test tests/ECAP.UnitTests

# Run with coverage
dotnet test --collect:"XPlat Code Coverage"
```

## Development Workflow

1. Create a new feature branch from `main`
2. Implement your feature following vertical slice architecture
3. Add unit tests for business logic
4. Add integration tests for API endpoints
5. Ensure architecture tests pass
6. Create a pull request

## Useful Commands

```bash
# Build solution
dotnet build

# Clean solution
dotnet clean

# Run API with watch mode
dotnet watch run --project src/Presentation/ECAP.Api

# Add migration
dotnet ef migrations add MigrationName --project src/Infrastructure/ECAP.Infrastructure.Persistence --startup-project src/Presentation/ECAP.Api

# Update database
dotnet ef database update --project src/Infrastructure/ECAP.Infrastructure.Persistence --startup-project src/Presentation/ECAP.Api
```

## Next Steps

- Read [Coding Standards](coding-standards.md)
- Review [Architecture Documentation](../architecture/clean-architecture.md)
- Check [API Documentation](../api/README.md)
- Explore [Deployment Guide](../deployment/README.md)
