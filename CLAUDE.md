# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a modern .NET 8 web API project built with ASP.NET Core, containerized with Docker, and deployed to Kubernetes using Terraform and Minikube. The project includes:

- A main API project (`src/WTech.API`) with basic weather forecast endpoints
- Docker containerization with multi-stage build process
- Docker Compose for local development
- Kubernetes deployment manifests
- Terraform infrastructure provisioning
- Local startup script (`run.sh`) that orchestrates the entire setup

## Development Setup

To get started with development:

1. Ensure you have installed:
   - Docker
   - kubectl
   - Terraform
   - Minikube
   - .NET 8 SDK

2. Run the local startup script to initialize all services:
   ```bash
   ./run.sh
   ```

## Key Commands

### Building
```bash
dotnet build
```

### Running
```bash
dotnet run
```

### Testing
No tests currently exist in the repository, but standard .NET testing would be:
```bash
dotnet test
```

### Development Workflow
1. Modify code in `src/WTech.API/`
2. Rebuild with `dotnet build` or `dotnet run`
3. For local container testing: `docker-compose up -d` (from root)
4. For complete build-test-deploy cycle: run `./run.sh`

## Script Overview

The repository uses a simplified single `run.sh` script that follows a fixed order of operations:
1. **Build** - Build Docker images for all projects under `src/`
2. **Test** - Run all tests in the solution (if .NET is available)
3. **Deploy** - Deploy to Kubernetes using existing manifests

The script automatically:
- Starts Minikube if not running
- Runs docker-compose up for the web API service
- Builds Docker images for all projects
- Runs tests (with graceful handling if .NET isn't installed)
- Deploys to Kubernetes using existing manifests

This streamlined approach ensures consistent and reproducible development workflows.

## Project Structure

The repository follows a standard .NET solution structure with:
- `src/` directory containing all project folders
- Each project in `src/` can have its own Dockerfile for containerization
- The build script automatically discovers and builds Docker images for all projects under `src/`

## Architecture

The project follows a standard ASP.NET Core pattern with:
- `Program.cs` as the entry point
- Minimal API endpoints (weather forecast example)
- Configuration through `appsettings.json` and environment-specific files
- Docker containerization using multi-stage builds
- Kubernetes deployment manifests for production deployment
- Terraform scripts for infrastructure provisioning

The main application is a simple weather forecast API with:
- GET `/weatherforecast` endpoint returning sample data
- Swagger/OpenAPI documentation enabled in development
- HTTPS redirection configured

## Key Files and Directories

- `src/WTech.API/Program.cs` - Main application entry point and endpoint definitions
- `Dockerfile` - Multi-stage Docker build configuration
- `compose.yaml` - Docker Compose setup for local development
- `run.sh` - Complete local development environment startup script
- `terraform/` - Infrastructure as code configurations
- `kubernetes/` - Kubernetes deployment manifests

## Testing

There are currently no tests in the repository. The standard .NET testing approach would involve:
1. Creating a test project with `dotnet new xunit`
2. Adding references to the main project
3. Writing tests for controllers and services
4. Running tests with `dotnet test`

## Deployment

The application is designed for Kubernetes deployment using:
1. Docker image building via `Dockerfile`
2. Terraform infrastructure provisioning
3. Kubernetes manifests in `kubernetes/` directory