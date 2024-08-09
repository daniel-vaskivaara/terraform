variable "default_suffix" {
  description = "Used to label all the things"
  type        = string
  default     = "tes-global"
}

variable "gitlab_server" {
  description = "Server address of GitLab"
  type        = string
  default     = "https://gitlab.com"
}