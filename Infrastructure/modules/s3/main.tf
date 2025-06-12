# bucket for pictures, avatars
resource "aws_s3_bucket" "my_bucket" {
  bucket = var.s3_bucket_name

  tags = {
    Name        = "MyBucket"
    Environment = var.environment
  }
}

resource "aws_s3_bucket_public_access_block" "block_public" {
  bucket = aws_s3_bucket.my_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# bucket for generated invoices
resource "aws_s3_bucket" "invoice_bucket" {
  bucket = var.bucket_name
}





