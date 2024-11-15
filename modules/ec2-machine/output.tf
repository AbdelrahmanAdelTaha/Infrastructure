output "instance_public_ips" {
  value = { for key, instance in module.ec2_instance : key => instance.public_ip }
}