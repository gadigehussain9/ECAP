# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Planned
- MediatR integration for CQRS
- Authentication & Authorization (JWT)
- Product Catalog domain implementation
- Order Management domain
- Shopping Cart functionality
- Payment gateway integration
- Email notifications
- RabbitMQ event bus integration

## [1.0.0] - 2026-07-20

### Added
- Initial project structure following Clean Architecture
- SharedKernel project with domain primitives:
  - Entity base class
  - ValueObject base class
  - DomainEvent base class
  - Result pattern for error handling
  - Guard clauses for validation
- Domain layer with repository interfaces and sample value objects
- Application layer with feature-based organization ready for CQRS
- Infrastructure layers:
  - Persistence (EF Core with SQL Server)
  - Identity (Authentication/Authorization preparation)
  - ExternalServices (Email service placeholder)
  - Messaging (Event bus preparation)
- API layer with Swagger/OpenAPI documentation
- Test projects:
  - Unit tests
  - Integration tests
  - Architecture tests (NetArchTest)
  - Performance tests (NBomber)
- Documentation:
  - Architecture Decision Records (ADR)
  - Getting Started guide
  - Coding Standards
- Infrastructure as Code:
  - Terraform for Azure
  - Kubernetes manifests
  - Helm charts
- Automation:
  - Build & test scripts (PowerShell)
  - Database migration scripts
  - Local development setup
- GitHub configuration:
  - CI workflow (build, test, coverage, security scan)
  - CD workflows (staging, production with blue-green deployment)
  - Security scanning (CodeQL, dependency-check)
  - CODEOWNERS file
  - PR template
  - Issue templates
- Central Package Management
- EditorConfig for consistent coding style

### Changed
- N/A (initial release)

### Deprecated
- N/A

### Removed
- N/A

### Fixed
- N/A

### Security
- Integrated CodeQL security scanning in CI
- Trivy container scanning
- Dependabot vulnerability alerts enabled

---

## Release Notes Template

Use this template for future releases:

## [Version] - YYYY-MM-DD

### Added
- New features

### Changed
- Changes in existing functionality

### Deprecated
- Soon-to-be removed features

### Removed
- Removed features

### Fixed
- Bug fixes

### Security
- Security improvements
