variable "bucket_name" {
  description = "Bucket-Name für Rechnungen"
  type        = string
}

variable "s3_bucket_name" {
  description = "Bucket-Name für Avatare/Bilder"
  type        = string
}

variable "environment" {
  description = "Umgebungsbezeichnung"
  type        = string
}