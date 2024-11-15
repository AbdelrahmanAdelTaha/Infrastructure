output "db_password" {
  value = module.database.db_password
}
output "rds_sg_id" {
  value = module.network.security_group_rds_id
}
output "ec2_sg_id" {
  value = module.network.security_group_ec2_id
}

output "vpc_id" {
  value = module.network.vpc_id
}

output "rds_private_subnet0" {
  value = module.network.private_subnets[0].id
}
output "rds_private_subnet1" {
  value = module.network.private_subnets[1].id
}
output "ec2_private_subnet1" {
  value = module.network.public_subnets[0].id
}
