# rds
module "rds" {
  source              = "../../submodules/rds"
  environment         = var.environment
  module              = var.module
  project_name        = var.project_name
  security_groups     = [var.security_group]
  subnets             = var.rds_private_subnets
  db_engine           = "mysql"
  db_version          = "8.0"
  instance_class      = "db.t3.micro"
  publicly_accessible = false
  storage_size_gb     = 30
  db_name             = "task-db"
}

