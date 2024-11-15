resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-${var.module}-${var.environment}"
  subnet_ids = var.subnets.*.id
  tags = {
    Name = "${var.project_name}-${var.module}-${var.environment}"
  }
}

resource "random_password" "db_password" {
  length = 10
}

resource "random_integer" "snapshot_id" {
  max = 1000000
  min = 0
}

resource "aws_db_instance" "main" {
  lifecycle {
    prevent_destroy = false
  }
  apply_immediately         = true
  depends_on                = [aws_db_subnet_group.main]
  deletion_protection       = false
  identifier                = "${var.project_name}-${var.module}-${var.db_name}-${var.environment}"
  backup_retention_period   = 35
  instance_class            = var.instance_class
  allocated_storage         = var.storage_size_gb
  engine                    = var.db_engine
  engine_version            = var.db_version
  username                  = var.db_user
  password                  = random_password.db_password.result
  db_subnet_group_name      = aws_db_subnet_group.main.name
  vpc_security_group_ids    = var.security_groups
  publicly_accessible       = var.publicly_accessible
  skip_final_snapshot       = false
  storage_encrypted         = true
  final_snapshot_identifier = "${var.project_name}-${var.module}-${var.db_name}-${var.environment}-${random_integer.snapshot_id.result}"
}