# ADR-004: Adopt Azure AI Foundry and Azure OpenAI

| Item | Value |
|------|-------|
| ADR Number | ADR-004 |
| Title | Adopt Azure AI Foundry and Azure OpenAI |
| Status | Accepted |
| Date | 2026-07-30 |
| Decision Makers | Principal Architect, AI Architect, Development Team |
| Epic | Enterprise Commerce & AI Platform (ECAP) |
| Related Documents | AI-Platform-Roadmap.md, 06-Architecture.md, 15-Implementation-Guide.md |

---

# 1. Context

The Enterprise Commerce & AI Platform (ECAP) aims to provide intelligent capabilities across multiple business domains.

Planned AI features include:

- AI Shopping Assistant
- Product Recommendations
- Product Description Generation
- SEO Metadata Generation
- Semantic Product Search
- Image Understanding
- Review Summarisation
- Chat-based Customer Support
- AI Agents
- Retrieval-Augmented Generation (RAG)

The AI platform must:

- Integrate with enterprise identity.
- Support multiple AI models.
- Be secure and governed.
- Support prompt engineering.
- Be observable.
- Avoid vendor lock-in where practical.

---

# 2. Decision

ECAP will adopt **Azure AI Foundry** as its primary AI development platform and **Azure OpenAI** as the initial Large Language Model (LLM) provider.

The application will never communicate directly with AI services from business logic.

Instead, all AI interactions will be abstracted through provider interfaces defined in the Application layer.

---

# 3. Architecture Overview

```
                API

                 │

                 ▼

          Application Layer

                 │

      IChatCompletionProvider
      IEmbeddingProvider
      IImageAnalysisProvider

                 │

                 ▼

        Infrastructure Layer

                 │

      Azure AI Foundry SDK

                 │

        Azure OpenAI Models

                 │

      GPT / Embeddings / Vision
```

This allows the AI provider to change without impacting business logic.

---

# 4. Decision Drivers

This decision supports:

- Enterprise governance
- Security
- Responsible AI
- Scalability
- Model flexibility
- AI observability
- Future AI capabilities
- Microsoft Azure ecosystem alignment

---

# 5. Benefits

## Enterprise AI Platform

Azure AI Foundry provides:

- Centralised AI project management
- Prompt management
- Model catalog
- Evaluation tools
- AI governance
- Security integration

---

## Azure OpenAI Models

Initial ECAP implementation will use Azure OpenAI models for:

- Chat completion
- Text generation
- Embedding generation
- Image understanding (multimodal models where available)

---

## Security

Authentication will use:

- Managed Identity
- Microsoft Entra ID
- Azure Key Vault

No API keys will be stored in source code.

---

## Responsible AI

The platform supports:

- Content filtering
- Abuse monitoring
- Safety policies
- Prompt governance
- Auditability

---

## Scalability

Future AI capabilities can be introduced without changing application architecture.

Examples:

- Product Recommendation Engine
- AI Order Assistant
- Vendor Copilot
- Inventory Optimisation
- AI Pricing Assistant

---

# 6. Consequences

## Positive

- Enterprise-ready AI platform.
- Secure model access.
- Strong governance.
- Excellent Azure integration.
- AI features remain modular.

## Negative

- Azure service dependency.
- AI service costs.
- Additional operational monitoring.
- Rapidly evolving AI ecosystem.

These trade-offs are acceptable given ECAP's strategic AI direction.

---

# 7. Alternatives Considered

## Alternative 1 — Direct Azure OpenAI SDK Usage

Advantages

- Simple implementation.
- Fewer abstraction layers.

Disadvantages

- Tight coupling to a specific SDK.
- Difficult to replace providers.
- Business logic becomes AI-aware.

Decision

Rejected.

---

## Alternative 2 — OpenAI Public API

Advantages

- Broad model availability.
- Fast experimentation.

Disadvantages

- Data residency considerations.
- Enterprise governance limitations.
- Separate authentication model.

Decision

Rejected for enterprise production workloads.

---

## Alternative 3 — Self-Hosted Open Source Models

Examples:

- Llama
- Mistral
- Phi

Advantages

- Full control.
- No external API dependency.

Disadvantages

- Infrastructure complexity.
- Model hosting responsibility.
- Performance tuning effort.

Decision

Deferred.

May be evaluated for specific workloads in the future.

---

# 8. AI Provider Abstraction

The Application layer defines provider interfaces.

Examples:

- IChatCompletionProvider
- IEmbeddingProvider
- IImageAnalysisProvider
- IContentModerationProvider
- IAudioTranscriptionProvider

Infrastructure provides Azure implementations.

Business logic depends only on interfaces.

---

# 9. Prompt Management

Prompts shall:

- Be version controlled.
- Be reusable.
- Be reviewed.
- Be documented.
- Avoid hard-coded values.

Future enhancements include:

- Prompt templates
- Prompt evaluation
- Prompt version history

---

# 10. Retrieval-Augmented Generation (RAG)

Future AI assistants will use RAG.

Architecture:

```
User Question

      │

      ▼

Embedding Generation

      │

      ▼

Azure AI Search

      │

      ▼

Relevant Documents

      │

      ▼

Azure OpenAI

      │

      ▼

Grounded Response
```

This reduces hallucinations and improves response accuracy.

---

# 11. AI Observability

Capture:

- Prompt execution time
- Model latency
- Token usage
- Completion latency
- Error rates
- Content filter events
- Correlation IDs

Telemetry will integrate with Application Insights and Azure Monitor.

---

# 12. Security

The AI platform shall:

- Use Managed Identity where supported.
- Store secrets in Azure Key Vault.
- Enforce least privilege.
- Protect prompts containing sensitive business information.
- Prevent sensitive data from being logged.

---

# 13. Performance

Monitor:

- Response latency
- Token consumption
- Concurrent requests
- Retry rates
- Throughput
- Cost per request

Caching strategies may be introduced where appropriate.

---

# 14. Future Evolution

Future AI capabilities may include:

- Multi-agent workflows
- AI orchestration
- Function calling
- Tool calling
- MCP integration
- Autonomous business agents
- Document intelligence
- Speech services
- AI model evaluation pipelines

---

# 15. Risks

Potential risks:

- Hallucinations
- Prompt injection
- AI service outages
- Cost overruns
- Model behaviour changes

Mitigation:

- RAG
- Content filtering
- Prompt validation
- Monitoring
- Human oversight for high-risk actions

---

# 16. Compliance

This decision aligns with:

- Microsoft Responsible AI principles
- Azure AI Foundry guidance
- Azure Well-Architected Framework
- Clean Architecture
- SOLID Principles

---

# 17. Review Criteria

This ADR should be reviewed if:

- Azure AI Foundry introduces significant architectural changes.
- ECAP adopts additional model providers.
- New governance or regulatory requirements emerge.
- AI capabilities expand beyond the current scope.

---

# 18. Status History

| Date | Status | Notes |
|------|--------|-------|
| 2026-07-30 | Accepted | Initial AI platform decision for ECAP |

---

# 19. Related ADRs

- ADR-001 – Use CQRS
- ADR-002 – Adopt Clean Architecture
- ADR-003 – Adopt Azure SQL Database
- ADR-005 – Use Bicep for Infrastructure as Code

---

# 20. Summary

ECAP adopts **Azure AI Foundry** as the enterprise AI platform and **Azure OpenAI** as the initial LLM provider.

AI capabilities are isolated behind provider abstractions, ensuring the core business logic remains independent of any specific AI SDK or model. This architecture supports secure, governed, observable and scalable AI development while enabling future adoption of additional models, agentic AI patterns and Retrieval-Augmented Generation (RAG).
