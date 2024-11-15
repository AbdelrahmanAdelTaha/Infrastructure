provider "aws" {
  region = var.aws_default_region
}

# terraform backend

terraform {
  backend "s3" {
    region  = "eu-west-1"
    encrypt = true
  }
}


# network

module "network" {
  source       = "./modules/network"
  environment  = var.environment
  project_name = var.project_name
  aws_region   = var.aws_default_region
}


# database

module "database" {
  depends_on          = [module.network]
  source              = "./modules/database"
  environment         = var.environment
  project_name        = var.project_name
  rds_private_subnets = module.network.private_subnets
  security_group      = module.network.security_group_rds_id
  vpc_id              = module.network.vpc_id
}

module "ec2" {
  depends_on     = [module.network]
  source         = "./modules/ec2-machine"
  environment    = var.environment
  security_group = module.network.security_group_ec2_id
  subnet         = module.network.public_subnets
}
