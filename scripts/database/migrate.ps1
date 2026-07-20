# Database Migration Script for ECAP

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("dev", "staging", "production")]
    [string]$Environment,

    [Parameter(Mandatory=$false)]
    [string]$MigrationName
)

$ErrorActionPreference = "Stop"

Write-Host "ECAP Database Migration - Environment: $Environment" -ForegroundColor Green

$projectPath = "../../src/Infrastructure/ECAP.Infrastructure.Persistence/ECAP.Infrastructure.Persistence.csproj"
$startupPath = "../../src/Presentation/ECAP.Api/ECAP.Api.csproj"

# Set connection string based on environment
switch ($Environment) {
    "dev" {
        $connectionString = "Server=(localdb)\mssqllocaldb;Database=ECAP_Dev;Trusted_Connection=True;"
    }
    "staging" {
        # Load from environment variable or Azure Key Vault
        $connectionString = $env:ECAP_STAGING_DB
    }
    "production" {
        # Load from environment variable or Azure Key Vault
        $connectionString = $env:ECAP_PRODUCTION_DB
    }
}

if ($MigrationName) {
    Write-Host "Adding new migration: $MigrationName" -ForegroundColor Yellow
    dotnet ef migrations add $MigrationName --project $projectPath --startup-project $startupPath
} else {
    Write-Host "Applying migrations..." -ForegroundColor Yellow
    dotnet ef database update --project $projectPath --startup-project $startupPath
}

if ($LASTEXITCODE -eq 0) {
    Write-Host "Database operation completed successfully!" -ForegroundColor Green
} else {
    Write-Host "Database operation failed!" -ForegroundColor Red
    exit 1
}
