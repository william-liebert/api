# Deploy Argo CD using Helm chart
resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.helm_chart_version

  values = [
    file("${path.module}/helm/values.yaml")
  ]
}