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

require_local_image() {
  if ! docker image inspect "$1" >/dev/null 2>&1; then
    echo "Missing required local image: $1" >&2
    exit 1
  fi
}

require docker
require git
require kubectl
require minikube
require terraform

PHASE="minikube"
minikube delete || true
minikube start --driver=docker

MINIKUBE_IP="$(minikube ip)"
GITEA_HOST="${MINIKUBE_IP}:33000"
GITEA_URL="http://${GITEA_HOST}"
GITEA_USERNAME="${GITEA_USERNAME:-developer}"
GITEA_PASSWORD="${GITEA_PASSWORD:-password}"
GIT_REPO_ENDPOINT="http://${GITEA_USERNAME}:${GITEA_PASSWORD}@${GITEA_HOST}/developer/wtech-api.git"
export TF_VAR_kubeconfig_path="${KUBECONFIG:-$HOME/.kube/config}"
export TF_VAR_gitea_admin_username="${GITEA_USERNAME}"
export TF_VAR_gitea_admin_password="${GITEA_PASSWORD}"
export TF_VAR_api_image_repository="${MINIKUBE_IP}:5000/wtech-api"

PHASE="docker-registry"
require_local_image registry:2
REGISTRY_IMAGE_ARCHIVE="$(mktemp /tmp/local-registry-image.XXXXXX.tar)"
docker save registry:2 -o "${REGISTRY_IMAGE_ARCHIVE}"
eval "$(minikube docker-env)"
if ! docker image inspect registry:2 >/dev/null 2>&1; then
  docker load -i "${REGISTRY_IMAGE_ARCHIVE}" >/dev/null
fi
rm -f "${REGISTRY_IMAGE_ARCHIVE}"
docker rm -f local-registry >/dev/null 2>&1 || true
docker run -d --name local-registry --restart=always -p 5000:5000 registry:2

PHASE="minikube-registry-config"
minikube ssh "sudo mkdir -p /etc/docker && printf '%s\n' '{\"insecure-registries\":[\"${MINIKUBE_IP}:5000\"]}' | sudo tee /etc/docker/daemon.json >/dev/null && sudo systemctl restart docker" >/dev/null
kubectl wait --for=condition=Ready node/minikube --timeout=180s >/dev/null

PHASE="docker-registry"
REGISTRY_URL="${MINIKUBE_IP}:5000"

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

PHASE="push-git-repository"
GIT_REPO_ENDPOINT="http://${GITEA_USERNAME}:${GITEA_PASSWORD}@${GITEA_HOST}/developer/wtech-api.git"
git remote add minikube-git "$GIT_REPO_ENDPOINT" || git remote set-url minikube-git "$GIT_REPO_ENDPOINT"
git push minikube-git --all

PHASE="build-api-image"
docker build -t "${REGISTRY_URL}/wtech-api:latest" -f src/WTech.API/Dockerfile .
docker push "${REGISTRY_URL}/wtech-api:latest"

PHASE="terraform-wtech-api"
terraform -chdir=terraform/wtech-api init
terraform -chdir=terraform/wtech-api apply -auto-approve

set +x

echo ""
echo "Done."
echo ""
echo "ArgoCD Credentials: [Username: \"admin\", Password: \"$ARGOCD_ADMIN_PASSWORD\"]"
echo "ArgoCD endpoint: [http://${MINIKUBE_IP}:30002]"
echo "Gitea Credentials: [Username: \"${GITEA_USERNAME}\", Password: \"${GITEA_PASSWORD}\"]"
echo "Gitea endpoint: [${GITEA_URL}]"
echo "Grafana endpoint: [http://${MINIKUBE_IP}:30003]"
echo "API endpoint: [http://${MINIKUBE_IP}:30080]"
echo "Local registry: [${REGISTRY_URL}]"
echo ""
echo "Waiting for interrupt..."
echo ""

wait
