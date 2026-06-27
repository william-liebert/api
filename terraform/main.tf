module "argocd" {
  source = "./modules/argocd"
}

module "gitea" {
  source = "./modules/gitea"
}

module "prometheus" {
  source = "./modules/prometheus"
}
