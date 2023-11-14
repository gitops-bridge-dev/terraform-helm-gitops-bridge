output "argocd" {
  description = "Argocd helm release"
  value       = try(helm_release.argocd[0], null)
}
output "cluster" {
  description = "ArgoCD cluster"
  value       = try(kubernetes_secret_v1.cluster[0], null)
}
output "apps" {
  description = "ArgoCD apps"
  value       = try(helm_release.bootstrap, null)
}
