#!/bin/bash

set -e

if ! command -v kubectl &> /dev/null; then
    echo "Error: kubectl is not installed or not in PATH."
    exit 1
fi

if ! command -v minikube &> /dev/null; then
    echo "Error: Minikube is not installed or not in PATH."
    exit 1
fi

if ! minikube status | grep -q "Running"; then
    echo "Starting Minikube..."
    minikube start --driver=docker
fi

if ! kubectl get namespace argocd &> /dev/null; then
    echo "Creating ArgoCD namespace..."
    kubectl create namespace argocd
fi

if ! kubectl get deployment argocd-server -n argocd &> /dev/null; then
    echo "Installing ArgoCD..."
    kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
    kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=argocd-server -n argocd --timeout=300s
fi

if ! kubectl get deployment git-server -n argocd &> /dev/null; then
    echo "Installing Git Server..."
    kubectl apply -n argocd -f kubernetes/git-server-deployment.yaml
    kubectl wait --for=condition=ready pod -l app=git-server -n argocd --timeout=300s
fi

echo "Building Docker images..."
docker build -t wtech-API:latest -f src/WTech.API/Dockerfile src/WTech.API

echo "Pushing Git Branch..."
GIT_SERVER_IP=$(kubectl get service git-server-service -o jsonpath='{.spec.clusterIP}')
GIT_REMOTE="git://$GIT_SERVER_IP:9418/git"
if ! git remote get-url minikube-git &> /dev/null; then
    git remote add minikube-git "$GIT_REMOTE"
fi
git push minikube-git --all

ARGOCD_URL=$(minikube service argocd-server -n argocd --url)
echo "Deployed successfully!"
echo "ArgoCD URL: $ARGOCD_URL"
echo "Git Remote: $GIT_REMOTE"
