variable "default_suffix" {
  description = "Used to label all the things"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-north-1"
}
