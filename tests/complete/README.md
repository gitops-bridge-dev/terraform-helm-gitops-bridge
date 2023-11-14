# Test argocd bootstrap

## Requirements
1. helm
2. kubernetes kubeconfig setup

Create kubernetes cluster you can use `kind`
```shell
kind create cluster
```

## Bootstrap ArgoCD

```shell
terraform init
terraform apply
```

Access Terraform output to configure `kubectl` and `argocd`
```shell
terraform output
```

Destroy
```shell
terraform destroy
```
