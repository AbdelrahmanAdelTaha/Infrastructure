variable "project_name" {
  description = "Project name the will be used to create resources and tags"
}

variable "module" {
  description = "Module name that is used to label resources"
}

variable "environment" {
  description = "Environment name, e.g. \"staging\""
}

variable "vpc_id" {
  description = "The VPC ID"
}

variable "ingress_rules" {
  description = "List of ingress rules to create"
  type = set(object({
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = list(string)
    ipv6_cidr_blocks = list(string)
  }))
  default = []
}

variable "egress_rules" {
  description = "List of egress rules to create"
  type = set(object({
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = list(string)
    ipv6_cidr_blocks = list(string)
  }))
  default = []
}

variable "suffix" {
  description = "Suffix for security group name"
}