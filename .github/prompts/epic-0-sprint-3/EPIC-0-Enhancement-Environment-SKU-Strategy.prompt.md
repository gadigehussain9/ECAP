# ECAP Enhancement – Centralized Environment Configuration & SKU Strategy

## Role

You are a Principal Azure Cloud Architect, Enterprise Platform Architect, and DevSecOps Lead.

Review the existing ECAP infrastructure implementation.

Enhance the Bicep architecture by introducing a centralized Environment Configuration Strategy.

Do NOT redesign working infrastructure.

Do NOT duplicate logic.

The solution must remain modular, maintainable, reusable, and production-ready.

---

# Objective

Currently, Azure resources define their own SKUs and configuration independently.

Refactor the infrastructure so that every environment-specific setting is managed from a single location.

The root deployment should define the environment once.

All child modules must inherit their configuration.

This should include (but not be limited to):

- Resource SKUs
- Storage redundancy
- SQL sizing
- App Service sizing
- Azure AI Search sizing
- Azure OpenAI deployment capacity
- Log Analytics retention
- Application Insights retention
- Diagnostic Settings
- Future scaling configuration

The design should follow the DRY principle.

---

# Existing Architecture

Review the repository.

Reuse existing modules.

Examples:

main.bicep

platform.bicep

globals.bicep

naming.bicep

tags.bicep

Do not change orchestration.

---

# Environment Configuration Module

Create a reusable module.

Recommended name:

environment-settings.bicep

or

environment-config.bicep

This module becomes the single source of truth.

Every infrastructure module must consume values from it.

No module should hardcode environment-specific SKUs.

---

# Supported Environments

Support:

- dev
- qa
- stage
- prod

Environment is specified only once in the root deployment.

Every module inherits the environment.

---

# Environment Configuration

Centralize the following settings.

## Azure SQL

Configure environment-specific sizing.

Development

- Lowest supported development SKU

QA

- Moderate SKU

Stage

- Production-like SKU

Production

- Enterprise production SKU

---

## App Service Plan

Development

- Lowest supported development SKU

QA

- Moderate SKU

Stage

- Production-like SKU

Production

- Enterprise production SKU

---

## Azure AI Search

Development

- Lowest practical SKU

QA

- Moderate SKU

Stage

- Production-like SKU

Production

- Enterprise SKU

---

## Azure OpenAI

Parameterize:

- Model deployment capacity
- Deployment scale (where supported)

Do not hardcode capacity.

---

## Storage

Configure redundancy.

Development

- LRS

Production

- ZRS or GRS

---

## Log Analytics

Configure retention.

Development

- Short retention

Production

- Long retention

---

## Application Insights

Configure:

- Sampling
- Retention

---

## Diagnostics

Allow environment-specific diagnostic verbosity.

Development

- Lower retention

Production

- Long retention

---

# Future Environment Settings

Prepare the module for future settings.

Examples:

Private Endpoints

Network Isolation

Zone Redundancy

Backup Policies

Geo Replication

Availability Zones

Autoscaling

Do not implement these features.

Only design for future extensibility.

---

# Parameter Files

Review parameter files.

Support:

dev.parameters.json

qa.parameters.json

stage.parameters.json

prod.parameters.json

Parameter files should contain only values that differ by environment.

Avoid duplication.

---

# Root Deployment

main.bicep

Should only define:

Environment

Location

Application Name

Resource Group

Everything else should come from environment configuration.

---

# Child Modules

Every child module should receive:

Environment Configuration Object

rather than many individual parameters.

Reduce parameter count.

Improve readability.

---

# Outputs

Expose the selected configuration.

Example:

Environment

SQL SKU

App Service SKU

Storage Redundancy

AI Search SKU

Azure OpenAI Capacity

Log Retention

Application Insights Retention

This simplifies validation.

---

# Cost Optimization

Development should minimize Azure consumption.

Production should maximize:

Availability

Performance

Reliability

Scalability

Avoid changing resource code between environments.

Only parameter files should differ.

---

# CI/CD Integration

Ensure the design works with:

GitHub Actions

Azure DevOps

Future deployment pipelines

Deployment pipelines should simply select:

dev

qa

stage

prod

No code changes required.

---

# Documentation

Update where appropriate.

08-Infrastructure-Strategy.md

09-Bicep-Standards.md

10-Azure-Resource-Standards.md

Document:

Environment Configuration

Promotion Strategy

SKU Strategy

Cost Optimization

Deployment Strategy

Do not duplicate documentation.

---

# Validation

Generate:

Azure CLI deployment examples

PowerShell deployment examples

Bicep validation commands

What-If examples

Environment comparison examples

---

# Deliverables

Generate:

environment-settings.bicep

Required updates to:

main.bicep

platform.bicep

parameter files

resource modules

documentation

Reuse existing modules.

Do not introduce breaking changes.

---

# Quality Checklist

Verify:

✓ Azure Well-Architected Framework

✓ Cloud Adoption Framework

✓ Cost Optimization

✓ Operational Excellence

✓ Reliability

✓ Performance Efficiency

✓ Security

✓ Maintainability

✓ DRY Principle

✓ Environment Independence

✓ Layered Architecture

✓ Modular Bicep Design

✓ GitHub Actions Ready

✓ Azure DevOps Ready

✓ Future Production Ready

Before generating code:

1. Review the current ECAP infrastructure.
2. Explain the proposed environment configuration architecture.
3. Explain how child modules inherit configuration.
4. Explain how this reduces Azure costs.
5. Explain how this simplifies Dev → QA → Stage → Production promotion.
6. Explain why this design is preferable to hardcoded SKUs.

Generate enterprise-grade production-quality infrastructure only.

Do not generate tutorial code.
