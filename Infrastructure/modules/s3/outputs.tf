output "invoice_bucket_arn" {
  value       = aws_s3_bucket.invoice_bucket.arn
  description = "ARN des Invoice-Buckets"
}

output "picture_bucket_name" {
  value       = aws_s3_bucket.my_bucket.bucket
  description = "Name des Picture-Buckets"
}

output "bucket_arn" {
  description = "ARN des Invoice Buckets"
  value       = aws_s3_bucket.invoice_bucket.arn
}