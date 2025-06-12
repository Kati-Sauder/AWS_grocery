variable "bucket_name" {
  type        = string
  description = "Ziel-S3-Bucket für Rechnungen"
}

variable "sender_email" {
  type        = string
  description = "SES-verifizierte Absenderadresse"
}

variable "lambda_role_arn" {
  type        = string
  description = "IAM Role ARN für die Lambda-Funktion"
}