variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "az_public" {
  description = "Availability Zone for the public subnet"
  type        = string
}

variable "az_private_a" {
  description = "Availability Zone for private subnet A"
  type        = string
}

variable "az_private_b" {
  description = "Availability Zone for private subnet B"
  type        = string
}