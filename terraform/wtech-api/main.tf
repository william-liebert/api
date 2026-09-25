
resource "helm_release" "development" {
  name           = "development"
  chart          = var.chart_repository_url
  version        = "0.1.0"
  take_ownership = true
  replace        = true

  values = [
    templatefile("${path.module}/resources/values.yaml", {
      api_image_repository = var.api_image_repository
      api_image_tag        = var.api_image_tag
    })
  ]
}
