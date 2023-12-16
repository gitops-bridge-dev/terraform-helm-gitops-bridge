# gitops-bridge-argocd-bootstrap-terraform
Terraform module for gitops-bridge argocd bootstrap

It handles three aspect of ArgoCD bootstrap
1. Installs an intial deployment of argocd, this deployment (gets replaced by argocd applicationset)
2. Creates the ArgoCD cluster secret (including in-cluster)
3. Creates the intial set App of Apps (addons, workloads, etc.)

To be use with [gitops-bridge](https://github.com/gitops-bridge-dev/) project, see example [here](https://github.com/gitops-bridge-dev/gitops-bridge/blob/main/argocd/iac/terraform/examples/eks/hello-world/main.tf)

## Usage

```hcl

locals {
  name                   = "ex-${replace(basename(path.cwd), "_", "-")}"
  environment            = "dev"
  cluster_version        = "1.27"
  gitops_addons_url      = "https://github.com/gitops-bridge-dev/gitops-bridge-argocd-control-plane-template"
  gitops_addons_basepath = ""
  gitops_addons_path     = "bootstrap/control-plane/addons"
  gitops_addons_revision = "HEAD"

  oss_addons = {
    enable_argo_workflows = true
    enable_foo                                   = true # you can add any addon here, make sure to update the gitops repo with the corresponding application set
  }
  addons = merge(local.oss_addons, { kubernetes_version = local.cluster_version })

  addons_metadata = merge(
    {
      addons_repo_url      = local.gitops_addons_url
      addons_repo_basepath = local.gitops_addons_basepath
      addons_repo_path     = local.gitops_addons_path
      addons_repo_revision = local.gitops_addons_revision
    }
  )

  argocd_apps = {
    addons = file("${path.module}/bootstrap/addons.yaml")
    workloads = file("${path.module}/bootstrap/workloads.yaml")
  }

}

################################################################################
# GitOps Bridge: Bootstrap
################################################################################
module "gitops_bridge_bootstrap" {
  source = "gitops-bridge-dev/gitops-bridge/helm"

  cluster = {
    cluster_name = local.name
    environment  = local.environment
    metadata     = local.addons_metadata
    addons       = local.addons
  }
  apps = local.argocd_apps
}

```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.10.1 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.22.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | >= 2.10.1 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.22.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.argocd](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.bootstrap](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_secret_v1.cluster](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret_v1) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_apps"></a> [apps](#input\_apps) | argocd app of apps to deploy | `any` | `{}` | no |
| <a name="input_argocd"></a> [argocd](#input\_argocd) | argocd helm options | `any` | `{}` | no |
| <a name="input_cluster"></a> [cluster](#input\_cluster) | argocd cluster secret | `any` | `null` | no |
| <a name="input_create"></a> [create](#input\_create) | Create terraform resources | `bool` | `true` | no |
| <a name="input_install"></a> [install](#input\_install) | Deploy argocd helm | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_apps"></a> [apps](#output\_apps) | ArgoCD apps |
| <a name="output_argocd"></a> [argocd](#output\_argocd) | Argocd helm release |
| <a name="output_cluster"></a> [cluster](#output\_cluster) | ArgoCD cluster |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
