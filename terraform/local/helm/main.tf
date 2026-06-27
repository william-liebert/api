resource "helm_release" "argocd" {
  name            = "argocd"
  repository      = "https://argoproj.github.io/argo-helm"
  chart           = "argo-cd"
  version         = "10.0.0"

  values = [
    file("${path.module}/values/argocd.yaml")
  ]
}

resource "helm_release" "gitea" {
  name            = "gitea"
  repository      = "https://dl.gitea.com/charts/"
  chart           = "gitea"
  version         = "12.6.0"

  values = [
    file("${path.module}/values/gitea.yaml")
  ]
}

resource "helm_release" "prometheus" {
  name            = "prometheus"
  repository      = "https://prometheus-community.github.io/helm-charts"
  chart           = "prometheus"
  version         = "15.0.1"

  values = [
    templatefile("${path.module}/values/prometheus.yaml", {
      node_port = 30090
    })
  ]
}