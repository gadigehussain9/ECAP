# Build stage
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

# Copy solution and project files
COPY ["Directory.Build.props", "./"]
COPY ["Directory.Packages.props", "./"]
COPY ["ECAP.sln", "./"]

# Copy project files for restore
COPY ["src/Core/ECAP.SharedKernel/ECAP.SharedKernel.csproj", "src/Core/ECAP.SharedKernel/"]
COPY ["src/Core/ECAP.Domain/ECAP.Domain.csproj", "src/Core/ECAP.Domain/"]
COPY ["src/Core/ECAP.Application/ECAP.Application.csproj", "src/Core/ECAP.Application/"]
COPY ["src/Infrastructure/ECAP.Infrastructure.Persistence/ECAP.Infrastructure.Persistence.csproj", "src/Infrastructure/ECAP.Infrastructure.Persistence/"]
COPY ["src/Infrastructure/ECAP.Infrastructure.Identity/ECAP.Infrastructure.Identity.csproj", "src/Infrastructure/ECAP.Infrastructure.Identity/"]
COPY ["src/Infrastructure/ECAP.Infrastructure.ExternalServices/ECAP.Infrastructure.ExternalServices.csproj", "src/Infrastructure/ECAP.Infrastructure.ExternalServices/"]
COPY ["src/Infrastructure/ECAP.Infrastructure.Messaging/ECAP.Infrastructure.Messaging.csproj", "src/Infrastructure/ECAP.Infrastructure.Messaging/"]
COPY ["src/Presentation/ECAP.Api/ECAP.Api.csproj", "src/Presentation/ECAP.Api/"]

# Restore dependencies
RUN dotnet restore "src/Presentation/ECAP.Api/ECAP.Api.csproj"

# Copy all source files
COPY . .

# Build and publish
WORKDIR "/src/src/Presentation/ECAP.Api"
RUN dotnet build "ECAP.Api.csproj" -c Release -o /app/build --no-restore
RUN dotnet publish "ECAP.Api.csproj" -c Release -o /app/publish --no-restore --no-build

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS runtime
WORKDIR /app

# Create non-root user
RUN addgroup --system --gid 1001 ecapgroup && \
    adduser --system --uid 1001 --ingroup ecapgroup ecapuser

# Copy published files
COPY --from=build /app/publish .

# Set ownership
RUN chown -R ecapuser:ecapgroup /app

# Switch to non-root user
USER ecapuser

# Configure environment
ENV ASPNETCORE_URLS=http://+:8080
ENV ASPNETCORE_ENVIRONMENT=Production

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8080/health || exit 1

EXPOSE 8080

ENTRYPOINT ["dotnet", "ECAP.Api.dll"]
