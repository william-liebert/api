# Deploy Gitea using Helm chart
resource "helm_release" "gitea" {
  name       = "gitea"
  repository = "https://dl.gitea.io/charts"
  chart      = "gitea"
  version    = var.helm_chart_version

  values = [
    file("${path.module}/helm/values.yaml")
  ]
}