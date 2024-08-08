provider "aws" {
}

variable "gitlab_runner_registration_token" {
  description = "The GitLab Runner registration token"
  type        = string
  sensitive   = true
}

module "eks" {
  source = "./modules/eks"
  default_suffix = var.default_suffix
}

module "gitlab_runners" {
  source = "./modules/runners/gitlab"
  default_suffix = var.default_suffix
  gitlab_runner_registration_token = var.gitlab_runner_registration_token
}