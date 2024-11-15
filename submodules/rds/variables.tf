variable "project_name" {
  description = "Project name the will be used to create resources and tags"
}

variable "module" {
  description = "Module name that is used to label resources"
}

variable "environment" {
  description = "Environment name, e.g. \"staging\""
}

variable "db_user" {
  description = "Database default user"
  default     = "username"
}

variable "subnets" {
  description = "Subnets where RDS is hosted"
}

variable "security_groups" {
  description = "Security groups to secure RDS access"
}

variable "instance_class" {
  description = "Instance class"
}

variable "db_engine" {
  description = "Database engine"
}

variable "db_version" {
  description = "Database version"
}

variable "publicly_accessible" {
  description = "If database is publicly accessible"
  type        = bool
}

variable "storage_size_gb" {
  description = "Database storage size"
}

variable "db_name" {
  description = "Database name"
}