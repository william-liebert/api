resource "helm_release" "argocd" {
  name            = "argocd"
  repository      = "https://argoproj.github.io/argo-helm"
  chart           = "argo-cd"
  version         = "10.0.0"
  take_ownership  = true
  replace         = true

  values = [
    file("${path.module}/values/argocd.yaml")
  ]
}

resource "helm_release" "gitea" {
  name            = "gitea"
  repository      = "https://dl.gitea.com/charts/"
  chart           = "gitea"
  version         = "12.6.0"
  take_ownership  = true
  replace         = true
  
  values = [
    file("${path.module}/values/gitea.yaml")
  ]
}

resource "helm_release" "gitea_actions" {
  name            = "gitea-actions"
  repository      = "https://dl.gitea.com/charts/"
  chart           = "actions"
  version         = "0.1.1"
  take_ownership  = true
  replace         = true
  
  values = [
    file("${path.module}/values/gitea-actions.yaml")
  ]

  depends_on = [
    helm_release.gitea
  ]
}

resource "helm_release" "prometheus" {
  name            = "prometheus"
  repository      = "https://prometheus-community.github.io/helm-charts"
  chart           = "prometheus"
  version         = "15.0.1"
  take_ownership  = true
  replace         = true

  values = [
    templatefile("${path.module}/values/prometheus.yaml", {
      node_port = 30090
    })
  ]
}

resource "helm_release" "development" {
  name            = "development"
  chart           = "${path.module}/../../charts/development"
  version         = "0.1.0"
  take_ownership  = true
  replace         = true

  values = [
    file("${path.module}/values/development.yaml")
  ]

  depends_on = [
    helm_release.argocd,
    helm_release.gitea,
    helm_release.prometheus
  ]
}
