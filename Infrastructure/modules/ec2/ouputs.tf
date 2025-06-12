output "instance_id" {
  description = "ID der EC2-Instanz"
  value       = aws_instance.grocery_ec2.id
}

output "public_ip" {
  description = "Öffentliche IP der EC2-Instanz"
  value       = aws_instance.grocery_ec2.public_ip
}

output "private_ip" {
  description = "Private IP der EC2-Instanz"
  value       = aws_instance.grocery_ec2.private_ip
}
