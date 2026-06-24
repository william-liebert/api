#!/bin/bash

set -e

echo "Building and deploying to local Minikube instance..."

if ! command -v docker &> /dev/null; then
    echo "Error: Docker is not installed or not in PATH."
    exit 1
fi

# Check if the web API service is already running
if ! docker compose ps -q web-api-local | grep -q .; then
    echo "Starting web API service..."
    docker compose up -d
fi

if ! command -v kubectl &> /dev/null; then
    echo "Error: kubectl is not installed or not in PATH."
    exit 1
fi

if ! command -v minikube &> /dev/null; then
    echo "Error: Minikube is not installed or not in PATH."
    exit 1
fi

if ! minikube status | grep -q "Running"; then
    echo "Starting Minikube with Docker driver..."
    minikube start --driver=docker
fi

echo "Building Docker images..."

docker build -t wtech-API:latest -f src/WTech.API/Dockerfile src/WTech.API

echo "Deploying to Minikube..."

kubectl apply -f kubernetes/webapi-deployment.yaml
kubectl apply -f kubernetes/webapi-hpa.yaml
kubectl apply -f kubernetes/webapi-ingress.yaml

echo "Deployed successfully!"