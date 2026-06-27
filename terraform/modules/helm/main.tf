resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.argocd_helm_chart_version

  values = [
    file("${path.module}/argocd/values.yaml")
  ]
}

resource "helm_release" "gitea" {
  name       = "gitea"
  repository = "https://dl.gitea.io/charts"
  chart      = "gitea"
  version    = var.gitea_helm_chart_version

  values = [
    file("${path.module}/gitea/values.yaml")
  ]
}

resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"
  version    = var.prometheus_helm_chart_version

  values = [
    file("${path.module}/prometheus/values.yaml")
  ]
}