# ECAP - Enterprise Commerce AI Platform

[![CI](https://github.com/gadigehussain9/ECAP/actions/workflows/ci.yml/badge.svg)](https://github.com/gadigehussain9/ECAP/actions/workflows/ci.yml)
[![codecov](https://codecov.io/gh/gadigehussain9/ECAP/branch/main/graph/badge.svg)](https://codecov.io/gh/gadigehussain9/ECAP)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Enterprise-grade e-commerce platform with AI capabilities, built with **.NET 10** following **Clean Architecture** principles and enterprise best practices.

## 🏛️ Architecture

ECAP follows Clean Architecture with clear separation of concerns:

```
┌─────────────────────────────────────────┐
│         Presentation (API)              │
│  ASP.NET Core Web API, Controllers      │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│         Application Layer               │
│   CQRS, MediatR, Vertical Slices       │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│          Domain Layer                   │
│  Entities, Value Objects, Interfaces    │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│         SharedKernel                    │
│   Domain Primitives, Result Pattern     │
└─────────────────────────────────────────┘

Infrastructure Layer (implements Application interfaces)
├── Persistence (EF Core, SQL Server)
├── Identity (JWT, Authentication)
├── ExternalServices (Email, Payment)
└── Messaging (Event Bus)
```

## 🚀 Features

- ✅ **Clean Architecture** with proper dependency direction
- ✅ **Vertical Slice Architecture** for feature organization
- ✅ **CQRS** with MediatR (ready to integrate)
- ✅ **Domain-Driven Design** patterns
- ✅ **Repository & Unit of Work** patterns
- ✅ **Result Pattern** for error handling
- ✅ **Entity Framework Core** with SQL Server
- ✅ **Swagger/OpenAPI** documentation
- ✅ **xUnit** for testing
- ✅ **Architecture Tests** with NetArchTest
- ✅ **Docker** support
- ✅ **Kubernetes** manifests
- ✅ **Terraform** for IaC
- ✅ **GitHub Actions** CI/CD

## 📋 Prerequisites

- [.NET 10 SDK](https://dotnet.microsoft.com/download/dotnet/10.0)
- SQL Server (LocalDB, Express, or full version)
- [Docker Desktop](https://www.docker.com/products/docker-desktop) (optional)
- [Visual Studio 2026](https://visualstudio.microsoft.com/) or [Visual Studio Code](https://code.visualstudio.com/)

## 🏃 Quick Start

```bash
# Clone the repository
git clone https://github.com/gadigehussain9/ECAP.git
cd ECAP

# Restore dependencies
dotnet restore

# Run database migrations
dotnet ef database update --project src/Infrastructure/ECAP.Infrastructure.Persistence --startup-project src/Presentation/ECAP.Api

# Run the API
dotnet run --project src/Presentation/ECAP.Api

# API will be available at https://localhost:5001
# Swagger UI: https://localhost:5001/swagger
```

## 🧪 Running Tests

```bash
# Run all tests
dotnet test

# Run with code coverage
dotnet test --collect:"XPlat Code Coverage"

# Run specific test project
dotnet test tests/ECAP.UnitTests
dotnet test tests/ECAP.ArchitectureTests
```

## 📁 Project Structure

```
ECAP/
├── src/
│   ├── Core/
│   │   ├── ECAP.SharedKernel/        # Domain primitives (Entity, ValueObject, Result)
│   │   ├── ECAP.Domain/              # Business entities, interfaces
│   │   └── ECAP.Application/         # Use cases, CQRS handlers
│   ├── Infrastructure/
│   │   ├── ECAP.Infrastructure.Persistence/      # EF Core, DbContext, Repositories
│   │   ├── ECAP.Infrastructure.Identity/         # JWT, Authentication
│   │   ├── ECAP.Infrastructure.ExternalServices/ # Email, Payment integrations
│   │   └── ECAP.Infrastructure.Messaging/        # Event Bus (RabbitMQ, Azure Service Bus)
│   └── Presentation/
│       └── ECAP.Api/                 # ASP.NET Core Web API
├── tests/
│   ├── ECAP.UnitTests/               # Unit tests (Domain, Application)
│   ├── ECAP.IntegrationTests/        # Integration tests (API, Database)
│   ├── ECAP.ArchitectureTests/       # Clean Architecture enforcement
│   └── ECAP.PerformanceTests/        # Load testing with NBomber
├── docs/                             # Documentation
│   ├── architecture/adr/             # Architecture Decision Records
│   ├── development/                  # Developer guides
│   └── deployment/                   # Deployment guides
├── infrastructure/                   # Infrastructure as Code
│   ├── terraform/                    # Terraform for Azure
│   ├── kubernetes/                   # K8s manifests
│   └── helm/                         # Helm charts
├── scripts/                          # Automation scripts
│   ├── build/                        # Build & test scripts
│   ├── deploy/                       # Deployment scripts
│   └── database/                     # Database migration scripts
└── .github/                          # GitHub Actions workflows
```

## 🛠️ Technology Stack

| Layer | Technology |
|-------|------------|
| **Runtime** | .NET 10 |
| **API** | ASP.NET Core Web API |
| **ORM** | Entity Framework Core 10 |
| **Database** | SQL Server |
| **Testing** | xUnit, Moq, FluentAssertions, Bogus |
| **Architecture Testing** | NetArchTest |
| **Performance Testing** | NBomber |
| **Containerization** | Docker |
| **Orchestration** | Kubernetes, Helm |
| **IaC** | Terraform (Azure) |
| **CI/CD** | GitHub Actions |
| **Documentation** | Swagger/OpenAPI |

## 📖 Documentation

- [Getting Started](docs/development/getting-started.md)
- [Coding Standards](docs/development/coding-standards.md)
- [Architecture Decision Records](docs/architecture/adr/)
- [API Documentation](docs/api/)
- [Deployment Guide](docs/deployment/)

## 🤝 Contributing

Contributions are welcome! Please read [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🔒 Security

For security vulnerabilities, please see [SECURITY.md](SECURITY.md).

## 👥 Authors

- **Hussain Gadige** - *Initial work* - [@gadigehussain9](https://github.com/gadigehussain9)

## 🙏 Acknowledgments

- Clean Architecture by Robert C. Martin
- Domain-Driven Design by Eric Evans
- Vertical Slice Architecture by Jimmy Bogard
- .NET Community for excellent tools and libraries

---

**Built with ❤️ using .NET 10**
