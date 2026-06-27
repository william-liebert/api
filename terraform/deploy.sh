#!/bin/bash

# Deploy Argo CD to Minikube cluster
echo "Deploying Argo CD to Minikube..."

# Add Argo Helm repository if not already added
helm repo add argo https://argoproj.github.io/argo-helm || true
helm repo update

# Deploy Argo CD with NodePort on port 30080
echo "Installing Argo CD..."
helm install argocd argo/argo-cd \
  --set server.service.type=NodePort \
  --set server.service.nodePort=30080 \
  --namespace argocd \
  --create-namespace

echo "Argo CD deployment completed!"
echo "Access Argo CD at: http://127.0.0.1:30080"