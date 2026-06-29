module "gitea" {
  source          = "./modules/gitea"

  gitea_admin_username = var.gitea_admin_username

  depends_on = [
    module.helm
  ]
}

module "argocd" {
  source          = "./modules/argocd"

  depends_on = [
    module.helm,
    module.gitea
  ]
}
