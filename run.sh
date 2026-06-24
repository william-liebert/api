#!/bin/bash

set -e

echo "Building and deploying to local Minikube instance..."

if ! command -v minikube &> /dev/null; then
    echo "Error: Minikube is not installed or not in PATH."
    exit 1
fi

if ! minikube status | grep -q "Running"; then
    echo "Starting Minikube with Docker driver..."
    minikube start --driver=docker
fi

if ! command -v kubectl &> /dev/null; then
    echo "Error: kubectl is not installed or not in PATH."
    exit 1
fi

if ! kubectl get namespace argocd &> /dev/null; then
    echo "Installing ArgoCD..."
    kubectl create namespace argocd
    kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
    kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=argocd-server -n argocd --timeout=300s
fi

ARGOCD_URL=$(minikube service argocd-server -n argocd --url)
echo "ArgoCD URL: $ARGOCD_URL"

echo "Building Docker images..."
docker build -t wtech-API:latest -f src/WTech.API/Dockerfile src/WTech.API

echo "Deploying to Minikube..."
kubectl apply -f kubernetes/webapi-deployment.yaml
kubectl apply -f kubernetes/webapi-hpa.yaml
kubectl apply -f kubernetes/webapi-ingress.yaml

echo "Deployed successfully!"