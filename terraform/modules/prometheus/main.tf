# Deploy Prometheus using Helm chart
resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"
  version    = var.helm_chart_version

  values = [
    file("${path.module}/helm/values.yaml")
  ]
}