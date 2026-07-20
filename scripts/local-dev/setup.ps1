# Local Development Environment Setup

Write-Host "Setting up ECAP local development environment..." -ForegroundColor Green

# Check prerequisites
Write-Host "Checking prerequisites..." -ForegroundColor Yellow

# Check .NET SDK
$dotnetVersion = dotnet --version
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ .NET SDK: $dotnetVersion" -ForegroundColor Green
} else {
    Write-Host "✗ .NET SDK not found!" -ForegroundColor Red
    exit 1
}

# Check Docker
$dockerVersion = docker --version
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Docker: $dockerVersion" -ForegroundColor Green
} else {
    Write-Host "⚠ Docker not found (optional)" -ForegroundColor Yellow
}

# Restore dependencies
Write-Host "`nRestoring NuGet packages..." -ForegroundColor Yellow
dotnet restore

# Setup local database
Write-Host "`nSetting up local database..." -ForegroundColor Yellow
& "$PSScriptRoot/../database/migrate.ps1" -Environment dev

# Build solution
Write-Host "`nBuilding solution..." -ForegroundColor Yellow
& "$PSScriptRoot/../build/build.ps1" -Configuration Debug

# Run tests
Write-Host "`nRunning tests..." -ForegroundColor Yellow
& "$PSScriptRoot/../build/test.ps1"

Write-Host "`nLocal development environment is ready!" -ForegroundColor Green
Write-Host "Run 'dotnet run --project src/Presentation/ECAP.Api' to start the API" -ForegroundColor Cyan
