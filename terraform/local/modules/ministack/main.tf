resource "helm_release" "ministack" {
  name            = "ministack"
  chart           = "${path.module}/../../../charts/ministack"
  version         = "0.1.0"
  take_ownership  = true
  replace         = true

  values = [
    file("${path.module}/values/ministack.yaml")
  ]
}