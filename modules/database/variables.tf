variable "project_name" {
  description = "Project name the will be used to create resources and tags"
}

variable "module" {
  description = "Module name that is used to label resources"
  default     = "database"
}

variable "environment" {
  description = "Environment name, e.g. \"staging\""
}

variable "vpc_id" {
  description = "VPC ID"
}

variable "rds_private_subnets" {
  description = "RDS private subnets"
}

variable "environment_map" {
  type = map(any)
  default = {
    "production" = "production"
  }
}

variable "security_group" {
  description = "security group"
}