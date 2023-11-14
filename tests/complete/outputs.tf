output "argocd" {
  description = "test argocd output"
  value       = module.gitops_bridge_bootstrap.argocd
  sensitive   = true
}
output "cluster" {
  description = "test cluster output"
  value       = module.gitops_bridge_bootstrap.cluster
  sensitive   = true
}
output "apps" {
  description = "test apps output"
  value       = module.gitops_bridge_bootstrap.apps
  sensitive   = true
}



output "configure_argocd" {
  description = "Terminal Setup"
  value       = <<-EOT
    export ARGOCD_OPTS="--port-forward --port-forward-namespace argocd --grpc-web"
    kubectl config set-context --current --namespace argocd
    argocd login --port-forward --username admin --password $(argocd admin initial-password | head -1)
    echo "ArgoCD Username: admin"
    echo "ArgoCD Password: $(kubectl get secrets argocd-initial-admin-secret -n argocd --template="{{index .data.password | base64decode}}")"
    echo Port Forward: http://localhost:8080
    kubectl port-forward -n argocd svc/argo-cd-argocd-server 8080:80
    EOT
}
