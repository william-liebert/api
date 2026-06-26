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

echo "Exposing ArgoCD on port 8080..."
if ! pgrep -f "kubectl port-forward service/argo-cd-server 8080:443" > /dev/null; then
    kubectl port-forward service/argo-cd-server 8080:443 || true &
fi
ARGOCD_ADMIN_PASSWORD=$(kubectl -n default get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
echo "ArgoCD Credentials: [Username: \"admin\", Password: \"$ARGOCD_ADMIN_PASSWORD\"]"

echo "Installing Gitea via Helm with NodePort..."
helm repo add gitea-charts https://dl.gitea.com/charts/
helm upgrade --install gitea gitea-charts/gitea -f kubernetes/helm/gitea/values.yaml

echo "Installing Prometheus Stack via Helm..."
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm upgrade --install prometheus prometheus-community/kube-prometheus-stack

echo "Exposing Grafana on port 8081..."
if ! pgrep -f "kubectl port-forward service/prometheus-grafana 8081:80" > /dev/null; then
    kubectl port-forward service/prometheus-grafana 8081:80 -n default > /dev/null 2>&1 &
fi

echo "Building Docker images..."
for dir in src/* ; do
    if [ -d "$dir" ]; then
        project_name=$(basename "$dir" | tr '[:upper:]' '[:lower:]' | tr -cd '[:alnum:]-')
        # docker build -t "$project_name:latest" -f "$dir/Dockerfile" .
    fi
done

echo "Pushing Git Branch..."
if [ -z "$MINIKUBE_GIT_URL" ]; then
    # Fallback to minikube IP if minikube service command doesn't work
    MINIKUBE_IP=$(minikube ip)
    MINIKUBE_GIT_URL="http://$MINIKUBE_IP:30000"
fi
git remote add minikube-git "$MINIKUBE_GIT_URL" || git remote set-url minikube-git "$MINIKUBE_GIT_URL"
git push minikube-git --all

echo "Syncing Deployments..."
argocd app sync wtech-api || true

echo "Gitea is now accessible via NodePort:"
echo "  HTTP: http://$(minikube ip):30000"
echo "  SSH: ssh://git@$(minikube ip):30022"
echo "Done."
