#!/bin/bash

set -ex

# Disabling for now, fix later. Don't worry about it for now.
# if minikube status > /dev/null 2>&1; then
#     minikube start --driver=docker &
#     while ! minikube status > /dev/null 2>&1; do
#         sleep 15
#     done
# fi

echo "Installing Helm..."
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

echo "Installing ArgoCD via Helm..."
helm repo add argo https://argoproj.github.io/argo-helm
helm upgrade --install argo-cd argo/argo-cd -f kubernetes/helm/argo-cd/values.yaml
ARGOCD_ENDPOINT=$((minikube service argo-cd-argocd-server --url &) | grep -m 1 -o 'http://[^ ]*')
ARGOCD_ADMIN_PASSWORD=$(kubectl get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)

echo "Installing Gitea via Helm with NodePort..."
helm repo add gitea-charts https://dl.gitea.com/charts/
helm upgrade --install gitea gitea-charts/gitea -f kubernetes/helm/gitea/values.yaml
GITEA_ENDPOINT=$((minikube service gitea-http --url &) | grep -m 1 -o 'http://[^ ]*')

echo "Installing Prometheus Stack via Helm..."
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm upgrade --install prometheus prometheus-community/kube-prometheus-stack -f kubernetes/helm/prometheus/values.yaml
GRAFANA_ENDPOINT=$((minikube service prometheus-kube-prometheus-prometheus --url &) | grep -m 1 -o 'http://[^ ]*')

echo "Building Docker images..."
for dockerfile in src/*/Dockerfile ; do
    docker_image_name=$(basename "$(dirname "$dockerfile")" | tr '[:upper:]' '[:lower:]' | tr '.' '-')
    docker build -t "$docker_image_name:latest" -f "$dockerfile" .
done

echo "Pushing Git Branch..."
git remote add minikube-git "$GITEA_ENDPOINT/git/" || git remote set-url minikube-git "$GITEA_ENDPOINT/git/"
git push minikube-git --all -vvv

echo "Syncing Deployments..."
argocd app sync wtech-api || true

echo "Done."
echo "ArgoCD Credentials: [Username: \"admin\", Password: \"$ARGOCD_ADMIN_PASSWORD\"]"
echo "ArgoCD endpoint: [$ARGOCD_ENDPOINT]"
echo "Gitea endpoint: [$GITEA_ENDPOINT]"
echo "Grafana endpoint: [$GRAFANA_ENDPOINT]"

# wait forever to keep the script running
while true; do sleep 1; done
