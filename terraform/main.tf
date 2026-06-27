# Configure the Kubernetes provider
provider "kubernetes" {
  config_path = "../kubeconfig.minikube"
}

# Configure the Helm provider
provider "helm" {
  kubernetes = {
    config_path = "../kubeconfig.minikube"
  }
}

# Deploy Argo CD
resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "7.0.1"

  values = [
    file("${path.module}/helm/argocd-values.yaml")
  ]
}