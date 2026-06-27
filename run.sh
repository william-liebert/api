#!/bin/bash

set -ex

trap 'kill $(jobs -p) 2>/dev/null' EXIT INT TERM

if ! minikube status > /dev/null 2>&1; then
    minikube start --driver=docker --memory=4096 --cpus=2
fi

echo "Building Docker images..."
for dockerfile in src/*/Dockerfile ; do
    docker_image_name=$(basename "$(dirname "$dockerfile")" | tr '[:upper:]' '[:lower:]' | tr '.' '-')
    docker build -t "$docker_image_name:latest" -f "$dockerfile" .
done

echo "Applying Terraform..."
terraform -chdir=terraform/local/helm init
terraform -chdir=terraform/local/helm apply -auto-approve
kubectl port-forward svc/gitea-http 3000:3000 > /dev/null 2>&1 &
terraform -chdir=terraform/local/gitea init
terraform -chdir=terraform/local/gitea apply -auto-approve
kubectl port-forward svc/argo-cd-argocd-server 30080:80 > /dev/null 2>&1 &
ARGOCD_ADMIN_PASSWORD=$(kubectl get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
terraform -chdir=terraform/local/argocd init
terraform -chdir=terraform/local/argocd apply -auto-approve
kubectl port-forward svc/prometheus-kube-prometheus-stack-grafana 9090:9090 > /dev/null 2>&1 &

echo "Pushing Git Branch..."
GIT_REPO_ENDPOINT="http://developer:password@127.0.0.1:3000/developer/wtech-api.git"
git remote add minikube-git "$GIT_REPO_ENDPOINT" || git remote set-url minikube-git "$GIT_REPO_ENDPOINT"
git push minikube-git --all

set +x

echo "Done. Waiting for interrupt..."
echo ""
echo "ArgoCD Credentials: [Username: \"admin\", Password: \"$ARGOCD_ADMIN_PASSWORD\"]"
echo "ArgoCD endpoint: [http://127.0.0.1:30080]"
echo "Gitea Credentials: [Username: \"developer\", Password: \"password\"]"
echo "Gitea endpoint: [http://127.0.0.1:3000]"
echo "Grafana endpoint: [http://127.0.0.1:9090]"
echo ""

wait
