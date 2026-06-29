#!/bin/bash

set -ex

trap 'kill $(jobs -p) 2>/dev/null' EXIT INT TERM

#minikube delete || true
#minikube start --driver=docker
eval $(minikube docker-env) # Set docker env to minikube

minikube image load wtech-api:latest # temporary until Gitea Actions

echo "Applying Terraform..."
# helm uninstall argocd || true
# helm uninstall gitea || true
# helm uninstall prometheus || true
# helm uninstall wtech-api || true
terraform -chdir=terraform/helm init
terraform -chdir=terraform/helm apply -auto-approve
# Port-forwarding is now handled by the Helm chart with NodePort services
# kubectl port-forward svc/gitea-http 3000:3000 > /dev/null 2>&1 &
terraform -chdir=terraform/gitea init
terraform -chdir=terraform/gitea apply -auto-approve
# kubectl port-forward svc/argo-cd-argocd-server 30080:80 > /dev/null 2>&1 &
ARGOCD_ADMIN_PASSWORD=$(kubectl get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
terraform -chdir=terraform/argocd init
terraform -chdir=terraform/argocd apply -auto-approve
# kubectl port-forward svc/prometheus-kube-prometheus-stack-grafana 9090:9090 > /dev/null 2>&1 &

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
