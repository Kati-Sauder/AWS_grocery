variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "public_subnets" {
  type        = list(string)
  description = "List of public subnet IDs"
}

variable "alb_sg_id" {
  type        = string
  description = "Security Group ID for ALB"
}