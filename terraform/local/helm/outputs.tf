output "gitea" {
  value = helm_release.gitea
}

output "argocd" {
  value = helm_release.argocd
}

output "prometheus" {
  value = helm_release.prometheus
}