output "bucket_arn" {
  value       = aws_s3_bucket.invoice-bucket.arn
  description = "ARN of Invoice-bucket"
}

output "picture_bucket_name" {
  value       = aws_s3_bucket.picture-bucket.bucket
  description = "Name of Picture-bucket"
}
