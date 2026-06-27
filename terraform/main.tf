module "helm" {
  source = "./modules/helm"

  argocd_helm_chart_version     = var.argocd_helm_chart_version
  gitea_helm_chart_version      = var.gitea_helm_chart_version
  prometheus_helm_chart_version = var.prometheus_helm_chart_version
}

module "gitea" {
  source = "./modules/gitea"

  gitea_admin_username = var.gitea_admin_username
}