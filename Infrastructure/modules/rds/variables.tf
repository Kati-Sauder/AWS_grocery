variable "rds_instance_class" {
  description = "RDS-Instanzklasse"
  type        = string
}

variable "rds_username" {
  description = "RDS-Benutzername"
  type        = string
}

variable "rds_password" {
  description = "RDS-Passwort"
  type        = string
  sensitive   = true
}

variable "subnet_ids" {
  description = "Subnetz-IDs für RDS"
  type        = list(string)
}

variable "ec2_sg_id" {
  description = "Security Group ID von EC2"
  type        = string
}

variable "vpc_id" {
  description = "ID der VPC"
  type        = string
}