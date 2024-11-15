# vpc

module "vpc" {
  source             = "../../submodules/vpc"
  availability_zones = ["${var.aws_region}a", "${var.aws_region}b"]
  cidr               = "10.0.0.0/16"
  environment        = var.environment
  module             = var.module
  private_subnets = [
    "10.0.100.0/24", "10.0.101.0/24",
  ]
  private_nat_subnets = []
  public_subnets      = ["10.0.1.0/24"]
  project_name        = var.project_name
}

module "security_group_rds" {
  source       = "../../submodules/security_group"
  environment  = var.environment
  module       = var.module
  project_name = var.project_name
  vpc_id       = module.vpc.id
  egress_rules = []
  ingress_rules = [
    {
      from_port        = 3306
      to_port          = 3306
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      description      = "db-inbound-3306"
    },
    {
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = []
      ipv6_cidr_blocks = []
      description      = "self-https"
      self             = true
    }
  ]
  suffix = "rds"
}

module "security_group_ec2" {
  source       = "../../submodules/security_group"
  environment  = var.environment
  module       = var.module
  project_name = var.project_name
  vpc_id       = module.vpc.id
  egress_rules = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      description      = "Allow all outbound traffic"
    }
  ]
  ingress_rules = [
    {
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      description      = "Allow SSH access from anywhere"
    },
    {
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      description      = "Allow HTTP access from anywhere"
    },
    {
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      description      = "Allow HTTPS access from anywhere"
    }
  ]
  suffix = "ec2-public"
}


