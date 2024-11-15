variable "aws_default_region" {
  description = "AWS region to provision resources"
  default     = "eu-west-1"
}

variable "project_name" {
  description = "Project name the will be used to create resources and tags"
  default     = "task-project"
}

variable "environment" {
  description = "Environment name, e.g. \"staging\""
}

variable "environment_map" {
  type = map(any)
  default = {
    "dev"        = "dev"
    "staging"    = "staging"
    "production" = "production"
  }
}

