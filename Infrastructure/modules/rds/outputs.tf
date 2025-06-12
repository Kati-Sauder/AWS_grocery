output "rds_instance_id" {
  description = "ID der RDS-Instanz"
  value       = aws_db_instance.rds_instance.id
}

output "db_endpoint" {
  description = "Endpoint der RDS-Instanz"
  value       = aws_db_instance.rds_instance.endpoint
}

output "rds_port" {
  description = "Port der RDS-Instanz"
  value       = aws_db_instance.rds_instance.port
}
