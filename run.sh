#!/bin/bash

set -e

if ! command -v kubectl &> /dev/null; then
    echo "Error: Kubernetes CLI (kubectl) is not installed or not in PATH."
    exit 1
fi

if ! command -v minikube &> /dev/null; then
    echo "Error: Minikube (minikube) is not installed or not in PATH."
    exit 1
fi

if ! command -v argocd &> /dev/null; then
    echo "Error: ArgoCD CLI (argocd) is not installed or not in PATH."
    exit 1
fi

if ! command -v docker &> /dev/null; then
    echo "Error: Docker CLI (docker) is not installed or not in PATH."
    exit 1
fi

if ! minikube status | grep -q "Running"; then
    echo "Starting Minikube..."
    minikube start --driver=docker
fi

MINIKUBE_IP=$(minikube ip)

if ! command -v helm &> /dev/null; then
    echo "Installing Helm..."
    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
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

ARGOCD_URL="$MINIKUBE_IP:30080"
echo "ArgoCD URL: [$ARGOCD_URL]"

if ! kubectl get deployment git-server -n argocd &> /dev/null; then
    echo "Installing Git Server..."
    kubectl apply -n argocd -f kubernetes/git-server-deployment.yaml
    kubectl wait --for=condition=ready pod -l app=git-server -n argocd --timeout=300s
fi

GIT_REMOTE="git://$MINIKUBE_IP:9418/git"
echo "Git Remote: [$GIT_REMOTE]"

echo "Building Docker images..."
docker build -t wtech-api:latest -f src/WTech.API/Dockerfile .

echo "Pushing Git Branch..."
if ! git remote get-url minikube-git &> /dev/null; then
    git remote add minikube-git "$GIT_REMOTE"
fi
git push minikube-git --all

echo "Syncing Deployments..."
argocd app sync wtech-api || true

echo "Done."
