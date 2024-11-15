variable "aws_region" {
  description = "AWS region to provision resources"
}

variable "project_name" {
  description = "Project name the will be used to create resources and tags"
}

variable "module" {
  description = "Module name that is used to label resources"
  default     = "network"
}

variable "environment" {
  description = "Environment name, e.g. \"staging\""
}

