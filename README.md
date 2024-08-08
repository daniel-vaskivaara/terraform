# Terraform Sandbox

## Pre-requisites:
aws cli (ensure logged in via `aws sso login` or similar)
terraform cli (>=1.3)

## running:
  sample sequence for using module eks, followed by gitlab_runners:
 
 - check for any module-specific setup (see below)
 - `terraform init`
 - `terraform apply -target=module.eks`
 - update local .kubeconfig file via:
   `aws eks update-kubeconfig --name tes-global --region eu-north-1`
 - `terraform apply -target=module.eks -target=module.gitlab_runners`

## module specific setup

### modules/runners/gitlab

  ### pre-requisites:
    - kubectl

  - set the runner token secret either via local env:
    `export TF_VAR_gitlab_runner_registration_token="secret-token"`
    or by adding `gitlab_runner_registration_token="secret-token"` to a terraform.tfvars file in the repo root (.gitignore will ensure it is not added to version control)