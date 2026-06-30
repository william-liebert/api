#!/bin/bash

set -ex

trap 'kill $(jobs -p) 2>/dev/null' EXIT INT TERM

minikube delete || true
minikube start --driver=docker
eval $(minikube docker-env) # Set docker env to minikube

minikube image load wtech-api:latest # temporary until Gitea Actions

echo "Applying Terraform..."
terraform -chdir=terraform/local init
terraform -chdir=terraform/local apply -auto-approve
ARGOCD_ADMIN_PASSWORD=$(kubectl get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
terraform -chdir=terraform/infra init
terraform -chdir=terraform/infra apply -auto-approve
terraform -chdir=terraform/cicd init
terraform -chdir=terraform/cicd apply -auto-approve
terraform -chdir=terraform/wtech-api init
terraform -chdir=terraform/wtech-api apply -auto-approve

echo "Pushing Git Branch..."
GIT_REPO_ENDPOINT="http://developer:password@127.0.0.1:33000/developer/wtech-api.git"
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
echo ""
echo "Waiting for interrupt..."
echo ""

wait
