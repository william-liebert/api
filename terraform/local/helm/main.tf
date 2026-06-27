resource "helm_release" "argocd" {
  name            = "argocd"
  repository      = "https://argoproj.github.io/argo-helm"
  chart           = "argo-cd"
  cleanup_on_fail = true
  version         = var.argocd_helm_chart_version

  values = [
    file("${path.module}/values/argocd.yaml")
  ]
}

resource "helm_release" "gitea" {
  name            = "gitea"
  repository      = "https://dl.gitea.io/charts"
  chart           = "gitea-charts/gitea"
  cleanup_on_fail = true
  version         = var.gitea_helm_chart_version

  values = [
    file("${path.module}/values/gitea.yaml")
  ]
}

# resource "helm_release" "prometheus" {
#   name            = "prometheus"
#   repository      = "https://prometheus-community.github.io/helm-charts"
#   chart           = "prometheus"
#   cleanup_on_fail = true
#   version         = var.prometheus_helm_chart_version

#   values = [
#     templatefile("${path.module}/values/prometheus.yaml", {
#       node_port = 30090
#     })
#   ]
# }