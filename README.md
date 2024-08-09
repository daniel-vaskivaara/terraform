# platform-tf-gitlab-runners

## description
  Sample configuration for having a GitLab custom runner pool in EKS 

## Pre-requisites:
  - aws cli (ensure logged in via `aws sso login` or similar)
  - kubectl
  - terraform cli (>=1.3)
  - set the runner token secret either via local env:
    `export TF_VAR_gitlab_runner_registration_token="secret-token"`
    or by adding `gitlab_runner_registration_token="secret-token"` to a terraform.tfvars file in the repo root (.gitignore will ensure it is not added to version control)

## Recommended
  - Some sort of K8s visualization tool, for example [k9s](https://github.com/derailed/k9s)

## running:
 - `terraform init`
 - `terraform apply -target=module.eks`
 - update local .kubeconfig file via:
   `aws eks update-kubeconfig --name tes-global-v01 --region eu-north-1`
 - `terraform apply -target=module.gitlab_runners` 
 <!-- -target=module.opa` -->