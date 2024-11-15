variable "project_name" {
  description = "Project name the will be used to create resources and tags"
}

variable "module" {
  description = "Module name that is used to label resources"
}

variable "submodule" {
  description = "Submodule name that is used to label resources"
  default     = "vpc"
}

variable "environment" {
  description = "Environment name, e.g. \"staging\""
}

variable "cidr" {
  description = "The CIDR block for the VPC"
}

variable "public_subnets" {
  description = "List of public subnets, must be of same length as private subnets with NAT GW and IP"
}

variable "private_subnets" {
  description = "List of private subnets"
}

variable "private_nat_subnets" {
  description = "List of private subnets with NAT gateway, must be of same length as public subnets"
}

variable "availability_zones" {
  description = "List of availability zones"
}