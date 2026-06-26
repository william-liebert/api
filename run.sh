#!/bin/bash

set -ex

if ! minikube status > /dev/null 2>&1; then
    minikube start --driver=docker &
    while ! minikube status > /dev/null 2>&1; do
        sleep 1
    done
fi

echo "Installing Helm..."
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

echo "Installing ArgoCD via Helm..."
helm repo add argo https://argoproj.github.io/argo-helm
helm upgrade --install argo-cd argo/argo-cd
ARGOCD_PORT=$(kubectl get service argo-cd-argocd-server -o jsonpath='{.spec.ports[0].nodePort}')
ARGOCD_ADMIN_PASSWORD=$(kubectl get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)

echo "Installing Gitea via Helm with NodePort..."
helm repo add gitea-charts https://dl.gitea.com/charts/
helm upgrade --install gitea gitea-charts/gitea
GITEA_PORT=$(kubectl get service gitea-http -o jsonpath='{.spec.ports[0].nodePort}')

echo "Installing Prometheus Stack via Helm..."
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm upgrade --install prometheus prometheus-community/kube-prometheus-stack
GRAFANA_PORT=$(kubectl get service prometheus-grafana -o jsonpath='{.spec.ports[0].nodePort}')

echo "Building Docker images..."
for dockerfile in src/*/Dockerfile ; do
    docker_image_name=$(basename "$(dirname "$dockerfile")" | tr '[:upper:]' '[:lower:]' | tr '.' '-')
    docker build -t "$docker_image_name:latest" -f "$dockerfile" .
done

echo "Pushing Git Branch..."
MINIKUBE_IP=$(minikube ip)
MINIKUBE_GIT_URL="http://$MINIKUBE_IP:$GITEA_PORT/wtech-api.git"
git remote add minikube-git "$MINIKUBE_GIT_URL" || git remote set-url minikube-git "$MINIKUBE_GIT_URL"
git push minikube-git --all -vvv

echo "Syncing Deployments..."
argocd app sync wtech-api || true

echo "Gitea is now accessible via NodePort:"
echo "  HTTP: $MINIKUBE_GIT_URL"
echo "  SSH: ssh://git@$(minikube ip):30022"

echo "Done."
echo "ArgoCD Credentials: [Username: \"admin\", Password: \"$ARGOCD_ADMIN_PASSWORD\"]"
echo "ArgoCD endpoint: [http://$MINIKUBE_IP:$ARGOCD_PORT]"
echo "Gitea endpoint: [$MINIKUBE_GIT_URL]"
echo "Grafana endpoint: [http://$MINIKUBE_IP:$GRAFANA_PORT]"
