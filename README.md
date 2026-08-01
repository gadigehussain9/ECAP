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

### Architecture & Patterns
- ✅ **Clean Architecture** with proper dependency direction
- ✅ **Vertical Slice Architecture** for feature organization
- ✅ **CQRS** with MediatR (implemented)
- ✅ **Domain-Driven Design** patterns (Aggregates, Value Objects, Domain Events)
- ✅ **Repository & Unit of Work** patterns
- ✅ **Result Pattern** for error handling
- ✅ **FluentValidation** for input validation

### Technology Stack
- ✅ **Entity Framework Core 10** with SQL Server
- ✅ **MediatR 13.0.1** for CQRS
- ✅ **Mapster 7.4.0** for object mapping
- ✅ **Swagger/OpenAPI** documentation
- ✅ **xUnit** for testing (ready)
- ✅ **Architecture Tests** with NetArchTest (ready)

### Infrastructure
- ✅ **Docker** support with docker-compose
- ✅ **Kubernetes** manifests
- ✅ **Terraform** for IaC
- ✅ **GitHub Actions** CI/CD
- ✅ **Azure Key Vault** integration
- ✅ **Health Checks** for SQL Server

### ECAP Bicep Foundation (Sprint 2)

The reusable Azure foundation is documented in [`infrastructure/bicep/README.md`](infrastructure/bicep/README.md). Sprint 2 provisions RBAC-enabled Azure Key Vault and Azure App Configuration with enterprise naming, standard tags, Log Analytics diagnostics, environment parameter files, and optional future workload RBAC. No standalone managed identity is deployed; Sprint 3 will use the App Service system-assigned identity as the primary workload identity.

### Implemented Modules (Sprint 1)
- ✅ **Product Catalog** - Complete CRUD, Brand & Category management, SKU validation, Product lifecycle
  - 8 REST API endpoints
  - Rich domain model with value objects
  - Soft delete, audit fields, SEO support
  - Pagination and filtering

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

# API will be available at https://localhost:7001
# Swagger UI: https://localhost:7001/swagger
```

### Available API Endpoints (Sprint 1)

**Product Catalog**
- `GET /api/products` - List products (with pagination & filters)
- `GET /api/products/{id}` - Get product by ID
- `GET /api/products/sku/{sku}` - Get product by SKU
- `POST /api/products` - Create product
- `PUT /api/products/{id}` - Update product
- `DELETE /api/products/{id}` - Soft delete product
- `POST /api/products/{id}/activate` - Activate product
- `POST /api/products/{id}/deactivate` - Deactivate product

## 🧪 Running Tests

```bash
# Run all tests (when test projects are implemented)
dotnet test

# Run with code coverage
dotnet test --collect:"XPlat Code Coverage"

# Run specific test project
dotnet test tests/ECAP.UnitTests
dotnet test tests/ECAP.IntegrationTests
dotnet test tests/ECAP.ArchitectureTests
```

**Note:** Test projects ready for Sprint 2 implementation.

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
| **CQRS** | MediatR 13.0.1 |
| **Validation** | FluentValidation 11.11.1 |
| **Mapping** | Mapster 7.4.0 |
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
- **Module Documentation**
  - [Product Catalog](docs/modules/ProductCatalog.md) ✅ Sprint 1
- **Sprint Summaries**
  - [Sprint 1 - Product Catalog](docs/sprint-summaries/Sprint-1-ProductCatalog-Summary.md) ✅ Complete

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
