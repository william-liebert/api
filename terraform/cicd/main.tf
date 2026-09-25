module "gitea" {
  source = "./modules/gitea"

  gitea_admin_username = var.gitea_admin_username
}

module "argocd" {
  source = "./modules/argocd"
}
