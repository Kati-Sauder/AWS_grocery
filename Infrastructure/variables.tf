variable "aws_region" {
  description = "AWS Region to deploy resources"
  type        = string
  default     = "eu-central-1"
}

variable "ami_id" {
  description = "AMI ID for EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
}

variable "ssh_cidr" {
  description = "CIDR block allowed to SSH"
  type        = string
  default     = "0.0.0.0/0"
}

variable "rds_instance_class" {
  description = "RDS instance type"
  type        = string
  default     = "db.t3.micro"
}

variable "rds_db_name" {
  description = "Database name"
  type        = string
}

variable "rds_username" {
  description = "Master username"
  type        = string
}

variable "rds_password" {
  description = "Master password"
  type        = string
  sensitive   = true
}

variable "invoice_bucket_name" {
  type        = string
  description = "Name des Invoice-Buckets"
}

variable "picture_bucket_name" {
  type        = string
  description = "Name des Avatare-Buckets"
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "Deployment Umgebung"
}

variable "sender_email" {
  description = "Verifizierte Absenderadresse für SES"
  type        = string
}