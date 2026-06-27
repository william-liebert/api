#!/bin/bash

set -ex

# trap 'kill $(jobs -p)' EXIT INT TERM

if ! minikube status > /dev/null 2>&1; then
    minikube start --driver=docker &
    while ! minikube status > /dev/null 2>&1; do
        sleep 15
    done
fi
MINIKUBE_IP=$(minikube ip)

echo "Installing Helm..."
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

echo "Installing ArgoCD via Helm..."
helm repo add argo https://argoproj.github.io/argo-helm
helm upgrade --install argo-cd argo/argo-cd -f kubernetes/helm/argo-cd/values.yaml
ARGOCD_PORT=30080
kubectl port-forward svc/argo-cd-argocd-server $ARGOCD_PORT:80 &
ARGOCD_ENDPOINT="http://$MINIKUBE_IP:$ARGOCD_PORT"
ARGOCD_ADMIN_PASSWORD=$(kubectl get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)

echo "Installing Gitea via Helm with NodePort..."
helm repo add gitea-charts https://dl.gitea.com/charts/
helm upgrade --install gitea gitea-charts/gitea -f kubernetes/helm/gitea/values.yaml
GITEA_PORT=3000
kubectl port-forward svc/gitea-http $GITEA_PORT:3000 &
kubectl port-forward svc/gitea-ssh $GITEA_PORT:22 &
GITEA_ENDPOINT="git@$MINIKUBE_IP:$GITEA_PORT:admin/wtech-api.git"

echo "Installing Prometheus Stack via Helm..."
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm upgrade --install prometheus prometheus-community/kube-prometheus-stack -f kubernetes/helm/prometheus/values.yaml
GRAFANA_PORT=9090
kubectl port-forward svc/prometheus-kube-prometheus-stack-grafana $GRAFANA_PORT:9090 &
GRAFANA_ENDPOINT="http://$MINIKUBE_IP:$GRAFANA_PORT"

echo "Building Docker images..."
for dockerfile in src/*/Dockerfile ; do
    docker_image_name=$(basename "$(dirname "$dockerfile")" | tr '[:upper:]' '[:lower:]' | tr '.' '-')
    docker build -t "$docker_image_name:latest" -f "$dockerfile" .
done

echo "Pushing Git Branch..."
git remote add minikube-git "$GITEA_ENDPOINT" || git remote set-url minikube-git "$GITEA_ENDPOINT"
git push minikube-git --all -vvv

echo "Syncing Deployments..."
argocd app sync wtech-api || true

echo "Done."
echo "ArgoCD Credentials: [Username: \"admin\", Password: \"$ARGOCD_ADMIN_PASSWORD\"]"
echo "ArgoCD endpoint: [$ARGOCD_ENDPOINT]"
echo "Gitea endpoint: [$GITEA_ENDPOINT]"
echo "Grafana endpoint: [$GRAFANA_ENDPOINT]"

wait
