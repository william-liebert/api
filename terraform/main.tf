# Configure the Kubernetes provider
provider "kubernetes" {
  config_path = var.kubeconfig_path
}

# Configure the Helm provider
provider "helm" {
  kubernetes {
    config_path = var.kubeconfig_path
  }
}

# Deploy Argo CD
resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argocd"
  version    = var.argocd_version

  set {
    name  = "server.service.type"
    value = "NodePort"
  }

  set {
    name  = "server.service.nodePort"
    value = var.argocd_server_port
  }
}