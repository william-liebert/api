# WTech API

A modern .NET 8 web API built with ASP.NET Core, containerized with Docker, and deployed to Kubernetes using Terraform and Minikube.

## Overview

This repository contains a complete web API project that demonstrates:
- Modern .NET 8 ASP.NET Core application
- Containerization with Docker
- Deployment automation using Docker Compose
- Infrastructure as Code with Terraform
- Kubernetes deployment with Minikube

## Project Structure

```
.
├── src/                 # Source code directory
│   └── WTech.API        # Main API project
├── tests/               # Test files
├── docker-compose.yml   # Docker Compose configuration
├── Dockerfile           # Docker build configuration
├── run.sh               # Startup script for local development
├── terraform/           # Terraform infrastructure configurations
├── kubernetes/          # Kubernetes deployment manifests
└── README.md            # This file
```

## Prerequisites

Before running this project, ensure you have the following installed:
- Docker
- kubectl
- Terraform
- Minikube
- .NET 8 SDK

## Getting Started

### Running Locally

Execute the run script to start the API with all required services:
```bash
./run.sh
```

This script will:
1. Start Docker containers using docker-compose
2. Initialize and apply Terraform configurations
3. Deploy Kubernetes resources to Minikube

### Manual Setup

If you prefer to set up manually:

1. **Start Minikube:**
   ```bash
   minikube start --driver=docker
   ```

2. **Build and run Docker containers:**
   ```bash
   docker-compose up -d
   ```

3. **Initialize Terraform:**
   ```bash
   cd terraform
   terraform init
   terraform apply -auto-approve
   ```

4. **Deploy to Kubernetes:**
   ```bash
   kubectl apply -f kubernetes/
   ```

## API Endpoints

The API exposes the following endpoints:
- `GET /api/health` - Health check endpoint
- `GET /api/values` - Sample data endpoint

## Development

### Building

```bash
dotnet build
```

### Testing

```bash
dotnet test
```

### Running

```bash
dotnet run
```

## Deployment

The application is designed to be deployed to Kubernetes. The deployment process includes:
- Docker image building and pushing
- Terraform infrastructure provisioning
- Kubernetes manifest application

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License.
