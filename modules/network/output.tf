output "vpc_id" {
  value = module.vpc.id
}

output "private_subnets" {
  value = [module.vpc.private_subnets.0, module.vpc.private_subnets.1]
}
output "public_subnets" {
  value = [module.vpc.public_subnets.0]
}

output "security_group_rds_id" {
  value = module.security_group_rds.id
}
output "security_group_ec2_id" {
  value = module.security_group_ec2.id
}