
resource "helm_release" "development" {
  name            = "development"
  chart           = "https://127.0.0.1:33000/git/wtech-api/charts/development"
  version         = "0.1.0"
  take_ownership  = true
  replace         = true

  values = [
    file("${path.module}/resources/values.yaml")
  ]
}
