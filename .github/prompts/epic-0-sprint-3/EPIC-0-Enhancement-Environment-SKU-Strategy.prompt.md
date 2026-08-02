# ECAP Enhancement - Environment-Based SKU Strategy

## Role

You are a Principal Azure Cloud Architect and Enterprise Platform Architect.

Review the existing ECAP Bicep implementation.

Implement an enterprise-grade environment-specific SKU strategy.

Do NOT rewrite working infrastructure.

Enhance the existing architecture.

Maintain backward compatibility.

---

# Objective

Currently the infrastructure uses enterprise default SKUs.

Enhance the implementation so that infrastructure automatically selects appropriate SKUs based on the deployment environment.

Supported environments:

- dev
- qa
- stage
- prod

The goal is:

- Reduce Azure costs during development
- Maintain production-ready architecture
- Avoid changing resource modules when promoting environments

Environment should drive sizing.

---

# Current Architecture

Review existing modules.

Reuse:

- globals.bicep
- naming.bicep
- tags.bicep
- main.bicep
- platform.bicep

Do not redesign orchestration.

---

# Environment Strategy

Support:

dev

qa

stage

prod

Environment should be passed once from the root deployment.

Child modules should inherit configuration.

Avoid duplicate parameters.

---

# Environment Configuration Module

If appropriate, create a reusable module:

environment-config.bicep

or

environment-settings.bicep

This module should centralize environment-specific configuration.

Avoid scattering SKU logic throughout resource modules.

---

# Resource Sizing Strategy

Implement sensible defaults.

## Azure SQL

Dev

- Small development SKU

QA

- Medium SKU

Stage

- Production-like SKU

Production

- Enterprise production SKU

---

## App Service Plan

Dev

- Low-cost development SKU

QA

- Medium SKU

Stage

- Production-like SKU

Production

- Enterprise production SKU

---

## Azure AI Search

Dev

- Lowest practical SKU

QA

- Medium SKU

Stage

- Production-like SKU

Production

- Enterprise SKU

---

## Azure OpenAI

Do not hardcode model capacity.

Parameterize deployment capacity where supported.

Support future production scaling.

---

## Storage

Parameterize redundancy.

Example:

Development

- LRS

Production

- ZRS or GRS depending on requirements.

---

## Log Analytics

Support configurable retention.

Example:

Development

- Short retention

Production

- Longer retention

---

## Application Insights

Support configurable sampling and retention.

---

# Cost Optimization

Development deployments should prioritize:

- Lowest supported SKUs
- Lower storage redundancy where appropriate
- Smaller SQL compute
- Lower App Service compute
- Reduced retention

Production should prioritize:

- High availability
- Performance
- Scalability
- Reliability

---

# Parameters

Review parameter files.

Support:

dev.parameters.json

qa.parameters.json

stage.parameters.json

prod.parameters.json

Each parameter file should override only environment-specific values.

Avoid duplication.

---

# Outputs

Expose selected SKUs.

Example:

App Service SKU

SQL SKU

Search SKU

Storage Redundancy

Log Retention

This simplifies validation.

---

# Validation

Generate:

Bicep validation

What-If examples

Sample deployment commands for:

Development

QA

Stage

Production

---

# Documentation

Update:

08-Infrastructure-Strategy.md

09-Bicep-Standards.md

10-Azure-Resource-Standards.md

Document:

Environment Strategy

SKU Strategy

Cost Optimization Strategy

Promotion Strategy

Environment Configuration

Do not duplicate existing documentation.

---

# Quality Checklist

Verify:

✓ Azure Well-Architected Framework

✓ Azure Cloud Adoption Framework

✓ Cost Optimization Pillar

✓ Reliability Pillar

✓ Performance Efficiency

✓ Security

✓ Operational Excellence

✓ ECAP Standards

✓ Environment Independence

✓ Reusable Modules

✓ No Breaking Changes

✓ Production Ready

Before generating code:

1. Review the existing implementation.
2. Explain the proposed environment configuration architecture.
3. Explain how child modules inherit environment settings.
4. Explain how the solution minimizes Azure costs during development.
5. Explain how the solution supports seamless promotion from Dev to Production.

Generate production-quality enterprise infrastructure enhancements only.

Do not generate tutorial examples.
