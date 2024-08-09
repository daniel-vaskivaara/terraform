# platform-tf-gitlab-runners

## description
  Sample configuration for having a GitLab custom runner pool in EKS. Two sample OPA policies have been created which force non-priviledged runners in the gitlab-runners namespace, as well as the K8s best practice of having at least one label associated with manifests.

## disclaimer
  As the word sample implies, this is not to be considered a production-ready template, but rather a proof of concept.

## Pre-requisites:
  - aws cli (ensure logged in via `aws sso login` or similar)
  - kubectl
  - terraform cli (>=1.3)
  - set GitLab runner token and GitLab server address (if different than https://gitlab.com):

    example via local environment (Linux/MacOS):
    ```
      export TF_VAR_gitlab_runner_registration_token="keep_it_secret-keep_it_safe"
      export TF_VAR_gitlab_server="https://gitlab.com"
    ```

    example of adding to terraform.tfvars file in repo root (.gitignore will ensure it is not added to version control)
    ```
    gitlab_runner_registration_token = "glrt-random-char-sequence-from-gitlab"
    gitlab_server = "https://gitlab.com"
    ```

## Recommended
  - Some sort of K8s visualization tool, for example [k9s](https://github.com/derailed/k9s)

## running:
 - `terraform init`
 - `terraform apply -target=module.eks`
 - update local .kubeconfig file via:
   `aws eks update-kubeconfig --name tes-global --region <region_close_to_GitLab_instance>`
 - `terraform apply -target=module.gitlab_runners` 
 - WiP: `terraform apply --target=module.opa`
