variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-north-1"
}

variable "gitlab_runner_registration_token" {
  description = "The GitLab Runner registration token"
  type        = string
  sensitive   = true
}
