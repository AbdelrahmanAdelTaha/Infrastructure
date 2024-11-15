module "ec2_instance" {
  source = "../../submodules/ec2"

  for_each = toset(["FrontEnd", "BackEnd"])

  name = "instance-${each.key}"
  ami = "ami-0a422d70f727fe93e"
  instance_type          = "t2.micro"
  monitoring             = true
  vpc_security_group_ids = [var.security_group]
  subnet_id              = var.subnet[0].id

  tags = {
    Environment = var.environment
  }
}