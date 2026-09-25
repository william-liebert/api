#!/bin/bash

set -Eeuo pipefail

PHASE="startup"
trap 'echo "Bootstrap failed during ${PHASE}." >&2' ERR

require() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing required tool: $1" >&2
    exit 1
  fi
}

require docker
require kubectl
require minikube
require terraform

PHASE="minikube"
minikube delete || true
minikube start --driver=docker
# Ensure the local Docker client targets the Minikube daemon when the cluster is running.
eval "$(minikube docker-env)"

PHASE="build-api-image"
docker build -t wtech-api:latest -f src/WTech.API/Dockerfile .
minikube image load wtech-api:latest

echo "Applying Terraform..."

PHASE="terraform-local"
terraform -chdir=terraform/local init
terraform -chdir=terraform/local apply -auto-approve

PHASE="terraform-infra"
terraform -chdir=terraform/infra init
terraform -chdir=terraform/infra apply -auto-approve

PHASE="argocd-admin-password"
ARGOCD_ADMIN_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)

PHASE="terraform-cicd"
terraform -chdir=terraform/cicd init
terraform -chdir=terraform/cicd apply -auto-approve

PHASE="terraform-wtech-api"
terraform -chdir=terraform/wtech-api init
terraform -chdir=terraform/wtech-api apply -auto-approve

echo "Pushing Git Branch..."
GIT_REPO_ENDPOINT="http://127.0.0.1:33000/developer/wtech-api.git"
git remote add minikube-git "$GIT_REPO_ENDPOINT" || git remote set-url minikube-git "$GIT_REPO_ENDPOINT"
git push minikube-git --all

set +x

echo ""
echo "Done."
echo ""
echo "ArgoCD Credentials: [Username: \"admin\", Password: \"$ARGOCD_ADMIN_PASSWORD\"]"
echo "ArgoCD endpoint: [http://127.0.0.1:30002]"
echo "Gitea Credentials: [Username: \"developer\", Password: \"password\"]"
echo "Gitea endpoint: [http://127.0.0.1:33000]"
echo "Grafana endpoint: [http://127.0.0.1:30003]"
echo "API endpoint: [http://127.0.0.1:30080]"
echo ""
echo "Waiting for interrupt..."
echo ""

wait
