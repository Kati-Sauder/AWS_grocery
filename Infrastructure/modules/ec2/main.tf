resource "aws_instance" "grocery_ec2" {
  ami                         = "ami-0b74f796d330ab49c"
  instance_type               = "t2.micro"
  subnet_id                   = var.subnet_id
  associate_public_ip_address = true
  vpc_security_group_ids      = var.vpc_security_group_ids
  key_name                    = var.key_name
  iam_instance_profile        = var.iam_instance_profile

  tags = {
    Name = "EC2-Public"
  }
}