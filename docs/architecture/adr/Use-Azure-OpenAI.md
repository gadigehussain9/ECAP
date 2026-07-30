# ADR-006: Adopt Azure OpenAI as the Enterprise LLM Platform

| Item | Value |
|------|-------|
| ADR | 006 |
| Title | Adopt Azure OpenAI as the Enterprise LLM Platform |
| Status | Accepted |
| Date | 2026-07-30 |
| Decision Makers | Principal Architect, AI Architect |
| Supersedes | None |

---

# Context

Enterprise Commerce & AI Platform (ECAP) requires enterprise-grade Large Language Model (LLM) capabilities to support current and future AI features.

Planned capabilities include:

- AI Shopping Assistant
- Product Recommendations
- Semantic Product Search
- Retrieval-Augmented Generation (RAG)
- AI-powered Customer Support
- Product Content Generation
- Order Summarisation
- AI Agents
- Knowledge Search
- Future Copilot Experiences

The platform requires:

- Enterprise security
- Identity integration
- Compliance
- High availability
- Cost management
- Monitoring
- Responsible AI controls
- Integration with Azure-native services

---

# Decision

ECAP will standardise on **Azure OpenAI** as the primary Large Language Model (LLM) platform.

Azure OpenAI will be used for:

- Chat completions
- Embedding generation
- Structured outputs
- Tool/function calling
- Retrieval-Augmented Generation (RAG)
- AI assistants
- AI orchestration

The application will interact with Azure OpenAI through abstraction interfaces to avoid provider lock-in.

---

# Decision Drivers

The decision is based on the following priorities:

- Enterprise-grade security
- Microsoft ecosystem integration
- Managed Identity support
- Azure RBAC integration
- Azure networking support
- Private Endpoint support
- Azure Monitor integration
- Application Insights integration
- Responsible AI capabilities
- Content Safety integration
- High availability
- Operational maturity

---

# Alternatives Considered

## Azure OpenAI

Pros

- Native Azure integration
- Microsoft security model
- Managed Identity
- Private networking
- Azure AI Foundry integration
- Azure AI Search integration
- Enterprise support
- Compliance certifications

Cons

- Azure service availability varies by region
- Azure deployment management required

---

## OpenAI Public API

Pros

- Rapid access to latest models
- Simple setup

Cons

- Separate identity model
- Different networking model
- Additional governance considerations
- Separate billing and monitoring

Decision

Not selected as the primary provider.

---

## Self-Hosted Open Models

Examples:

- Llama
- Mistral
- Phi

Pros

- Greater deployment flexibility
- Potential cost optimisation for some workloads
- Full infrastructure control

Cons

- Infrastructure management
- GPU requirements
- Model lifecycle management
- Operational complexity
- Performance tuning responsibility

Decision

Not selected for the initial implementation.

---

# Architecture

```
Application

        │

        ▼

IChatModelProvider

        │

        ▼

AzureOpenAIProvider

        │

        ▼

Azure OpenAI
```

Business services depend only on interfaces.

Provider implementations remain replaceable.

---

# Integration

Azure OpenAI integrates with:

- Azure AI Search
- Azure AI Foundry
- Azure Key Vault
- Azure App Configuration
- Azure API Management
- Azure Monitor
- Application Insights
- Microsoft Entra ID
- Azure Blob Storage

---

# Security

Authentication should use:

- Managed Identity where supported
- Microsoft Entra ID
- Azure RBAC
- Private Endpoints for production deployments
- Azure Key Vault for secrets when Managed Identity is not applicable

Security controls include:

- Prompt injection protection
- Output validation
- Content Safety
- Security trimming for RAG
- Audit logging

---

# Configuration

Configuration values should be externalised.

Examples include:

- Endpoint
- Deployment Name
- API Version
- Chat Model
- Embedding Model
- Temperature
- Max Tokens
- Retry Policy
- Timeout

Configuration should not be hard-coded.

---

# Provider Abstraction

Business code must not reference Azure OpenAI SDKs directly.

Recommended interfaces include:

```
IChatModelProvider

IEmbeddingProvider

IRerankerProvider

IContentSafetyProvider
```

Dependency Injection should resolve provider implementations.

---

# Observability

Capture:

- Model name
- Deployment name
- Prompt version
- Token usage
- Latency
- Finish reason
- Retry count
- Error rate
- Correlation ID

Integrate with:

- Application Insights
- Azure Monitor
- OpenTelemetry

---

# Performance

Performance objectives:

| Metric | Target |
|--------|--------|
| Chat Response | <5 seconds |
| Embedding Generation | <2 seconds |
| Availability | >99.9% |
| Error Rate | <1% |

These targets should be monitored continuously.

---

# Risks

Potential risks include:

- Service quota limitations
- Increased operational costs
- Regional availability constraints
- Provider-specific features
- Model lifecycle changes

Mitigations include:

- Monitoring
- Quota management
- Retry policies
- Cost alerts
- Provider abstraction

---

# Consequences

Positive

- Enterprise-ready AI platform
- Strong Azure integration
- Secure identity model
- Easier operations
- Unified monitoring
- Scalable AI architecture

Negative

- Azure dependency
- Need to track model updates
- Azure resource governance required

---

# Future Considerations

Future enhancements may include:

- Multiple LLM providers
- Intelligent model routing
- Cost-aware model selection
- AI Gateway
- Local model support
- Enterprise AI Agents
- Multi-modal AI
- Automated model evaluation

The architecture should evolve without requiring business-layer changes.

---

# Related Documents

- ADR-002 – Adopt Clean Architecture
- ADR-005 – Adopt Bicep for Infrastructure as Code
- Prompt Engineering Standards
- RAG Standards
- Vector Search Standards
- AI Evaluation Standards
- LLM Security Standards
- Model Governance Standards
- Security Standards
