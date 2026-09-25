
resource "helm_release" "development" {
  name           = "development"
  chart          = var.chart_repository_url
  version        = "0.1.0"
  take_ownership = true
  replace        = true

  values = [
    file("${path.module}/resources/values.yaml")
  ]
}
