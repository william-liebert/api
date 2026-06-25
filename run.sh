#!/bin/bash

set -ex

echo "Starting Minikube..."
minikube start --driver=docker
MINIKUBE_IP=$(minikube ip)

echo ""
echo "Installing Helm..."
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

echo ""
echo "Installing ArgoCD via Helm..."
helm repo add argo https://argoproj.github.io/argo-helm
helm upgrade --install argo-cd argo/argo-cd
ARGOCD_URL="$MINIKUBE_IP:30080"
echo "ArgoCD URL: [$ARGOCD_URL]"

echo ""
echo "Installing Gitea via Helm..."
helm repo add gitea-charts https://dl.gitea.com/charts/
helm upgrade --install gitea gitea-charts/gitea
GIT_REMOTE="git://$MINIKUBE_IP:9418/git"
echo "Git Remote: [$GIT_REMOTE]"

echo ""
echo "Building Docker images..."
docker build -t wtech-api:latest -f src/WTech.API/Dockerfile .

echo ""
echo "Pushing Git Branch..."
if ! git remote get-url minikube-git &> /dev/null; then
    git remote add minikube-git "$GIT_REMOTE"
fi
git push minikube-git --all

echo ""
echo "Syncing Deployments..."
argocd app sync wtech-api || true

echo ""
echo "Done."
