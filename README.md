# WTech API

This repository contains a .NET 8 ASP.NET Core API plus supporting infrastructure automation for local and cloud deployment. The application is intentionally lightweight and is paired with Terraform and Kubernetes assets used to provision and operate a local development environment.

## Overview

- API project: `src/WTech.API`
- Solution file: `WTech.API.sln`
- Local bootstrap script: `run.sh`
- Terraform infrastructure: `terraform/`
- Helm/Kubernetes assets: `charts/`

The sample app exposes a minimal API endpoint and is configured for local development with Swagger enabled in development mode.

## Prerequisites

Before running the app or the local environment, install the following tools:

- .NET 8 SDK
- Docker
- Minikube
- kubectl
- Terraform
- Git

## Quick start

### Build the API

```bash
dotnet restore
dotnet build
dotnet run --project src/WTech.API
```

### Run the full local environment

```bash
./run.sh
```

This script starts Minikube, loads the app image, applies Terraform configuration, and configures the local Git and cluster environment for the project.

## Project structure

```text
.
├── src/
│   └── WTech.API/
│       ├── Program.cs
│       ├── WTech.API.csproj
│       └── appsettings*.json
├── terraform/
│   ├── local/
│   ├── infra/
│   ├── cicd/
│   └── wtech-api/
├── charts/
├── run.sh
├── WTech.API.sln
├── CLAUDE.md
├── Directory.Build.props
├── Directory.Packages.props
├── NuGet.config
├── .gitignore
└── .github/
```

## Development notes

- Keep secrets and credentials out of source control.
- Prefer the existing project structure and conventions over broad refactors.
- Validate both the application and any infrastructure changes before merging.
- Use `dotnet build` and `dotnet test` when changing .NET code.

## GitHub Wiki

Wiki pages are maintained in `docs/wiki/` and automatically mirrored to the GitHub Wiki when changes are pushed to `main`. Enable and initialize the repository's Wiki, and allow GitHub Actions to create and approve content changes in repository settings. The workflow uses the default `GITHUB_TOKEN` and can also be run manually from the Actions tab.

## Useful commands

```bash
# build the solution
dotnet build

# run the API locally
dotnet run --project src/WTech.API

# validate Terraform formatting
terraform fmt -check -recursive

# local bootstrap environment
./run.sh
```

## Deployment model

This repository combines:

- a .NET API application
- Docker-based image workflows
- local Kubernetes orchestration via Minikube
- Terraform for provisioning and environment state

The intent is to provide a simple, reproducible local platform setup for experimentation and service deployment.
