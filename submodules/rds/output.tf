output "db_password" {
  value = nonsensitive(random_password.db_password.result)
}

output "db_instance_arn" {
  value = aws_db_instance.main.arn
}