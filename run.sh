#!/bin/bash

set -ex

trap 'kill $(jobs -p) 2>/dev/null' EXIT

if ! minikube status > /dev/null 2>&1; then
    minikube start --driver=docker
fi

echo "Installing Helm..."
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

echo "Installing ArgoCD via Helm..."
helm repo add argo https://argoproj.github.io/argo-helm
helm upgrade --install argo-cd argo/argo-cd

echo "Exposing ArgoCD on port 8081..."
if ! pgrep -f "kubectl port-forward deployment/argo-cd-server 8081:8080" > /dev/null; then
    kubectl port-forward deployment/argo-cd-server 8081:8080 || true &
fi

echo "Installing Gitea via Helm..."
helm repo add gitea-charts https://dl.gitea.com/charts/
helm upgrade --install gitea gitea-charts/gitea

echo "Exposing Gitea on port 3000..."
if ! pgrep -f "kubectl port-forward svc/gitea-http 3000:3000" > /dev/null; then
    kubectl port-forward svc/gitea-http 3000:3000 || true &
fi

echo "Installing Prometheus Stack via Helm..."
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm upgrade --install prometheus prometheus-community/kube-prometheus-stack

echo "Exposing Grafana on port 3002..."
if ! pgrep -f "kubectl port-forward svc/prometheus-grafana 3002:80" > /dev/null; then
    kubectl port-forward svc/prometheus-grafana 3002:80 -n default > /dev/null 2>&1 &
fi

echo "Building Docker images..."
for dir in src/* ; do
    if [ -d "$dir" ]; then
        project_name=$(basename "$dir" | tr '[:upper:]' '[:lower:]' | tr -cd '[:alnum:]-')
        # docker build -t "$project_name:latest" -f "$dir/Dockerfile" .
    fi
done

echo "Pushing Git Branch..."
MINIKUBE_GIT_URL=$(minikube service gitea-http --url 2>/dev/null | head -1)
git remote add minikube-git "$MINIKUBE_GIT_URL" || git remote set-url minikube-git "$MINIKUBE_GIT_URL"
git push minikube-git --all

echo "Syncing Deployments..."
argocd app sync wtech-api || true

echo "Done."
