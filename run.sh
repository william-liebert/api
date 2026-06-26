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
helm upgrade --install argo-cd argo/argo-cd -f kubernetes/helm/argo-cd/values.yaml
ARGOCD_ADMIN_PASSWORD=$(kubectl -n default get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
echo "ArgoCD Credentials: [Username: \"admin\", Password: \"$ARGOCD_ADMIN_PASSWORD\"]"

echo "Installing Gitea via Helm with NodePort..."
helm repo add gitea-charts https://dl.gitea.com/charts/
helm upgrade --install gitea gitea-charts/gitea -f kubernetes/helm/gitea/values.yaml

echo "Installing Prometheus Stack via Helm..."
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm upgrade --install prometheus prometheus-community/kube-prometheus-stack
helm upgrade --install prometheus-nodeport kubernetes/helm/prometheus
helm upgrade --install grafana-nodeport kubernetes/helm/grafana

echo "Building Docker images..."
for dockerfile in src/*/Dockerfile ; do
    build_dir=$(dirname "$dockerfile")
    csproj_name=$(basename "$build_dir")
    docker_image_name=$(echo "$build_dir/$csproj_name.csproj" | tr '[:upper:]' '[:lower:]' | tr '.' '-')
    docker build -t "$docker_image_name:latest" -f "$dockerfile" .
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
