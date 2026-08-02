# ECAP Production Readiness Checklist

## Deployment governance

- [ ] Review Bicep build and lint output with zero errors.
- [ ] Validate the selected environment parameter file.
- [ ] Approve and archive the what-if result.
- [ ] Deploy through GitHub Actions or Azure DevOps using federated identity.
- [ ] Confirm deployment outputs contain no secure values in logs.
- [ ] Test the destroy pipeline only in an isolated environment.

## Security

- [ ] App Service system-assigned identity is enabled and recorded.
- [ ] All five expected RBAC assignments exist at resource scope.
- [ ] Key Vault uses Azure RBAC and has purge protection enabled for production.
- [ ] Storage shared-key access is disabled and public blob access is disabled.
- [ ] No passwords, SQL logins, API keys, or credential-bearing settings exist.
- [ ] SQL Entra administrator and database-contained application user are provisioned.
- [ ] Production networking uses private endpoints, VNet Integration, and Private DNS.
- [ ] Production Resource Group lock is approved and set explicitly if required.

## Operations

- [ ] Application Insights and Log Analytics receive expected telemetry.
- [ ] Diagnostic settings exist for App Service, Storage, SQL, Key Vault, App Configuration, and AI resources.
- [ ] App Service health check returns successfully.
- [ ] Alerts and action groups are configured for availability, failures, throttling, and security events.
- [ ] Backup, retention, and restore procedures are tested.
- [ ] Incident ownership, escalation, and support contacts are documented.

## Acceptance

- [ ] Azure Portal verification is complete.
- [ ] Smoke tests validate managed identity access to Storage, Key Vault, App Configuration, OpenAI, Search, and SQL.
- [ ] Security review signs off the known limitations or records exceptions.
- [ ] Production readiness score is approved by the platform owner.
