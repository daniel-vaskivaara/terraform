variable "default_suffix" {
  description = "Used to label all the things"
  type        = string
}

variable "gitlab_runner_namespace" {
  description = "Dedicated namespace to isolate the runners"
  type        = string
  default     = "gitlab-runners"
}

variable "gitlab_runner_registration_token" {
  description = "The GitLab Runner registration token"
  type        = string
  sensitive   = true
}

variable "idle_runner_pool_size" {
  description = "Dedicated namespace to isolate the runners"
  type        = number
  default     = 1
}

variable "poll_new_job_interval" {
  description = "Number of seconds to wait before polling for a new GitLab job"
  type        = number
  default     = 3
}