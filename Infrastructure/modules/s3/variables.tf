variable "bucket_name" {
  description = "Bucket-name for invoices"
  type        = string
}

variable "s3_bucket_name" {
  description = "Bucket-name for avatars/pictures"
  type        = string
}

variable "environment" {
  description = "environment name"
  type        = string
}

variable "lambda_role_arn" {
  type        = string
  description = "ARN of the Lambda execution role that needs access to the S3 invoice bucket"
}