# Creates an S3 bucket for images (e.g. profile pictures, avatars)
resource "aws_s3_bucket" "picture-bucket" {
  bucket = var.s3_bucket_name

  tags = {
    Name        = "PictureBucket"
    Environment = var.environment
  }
}

# Blocks public access to the bucket defined above
resource "aws_s3_bucket_public_access_block" "block_public" {
  bucket = aws_s3_bucket.picture-bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Creates another S3 bucket for generated invoices
resource "aws_s3_bucket" "invoice-bucket" {
  bucket = var.bucket_name
}

# Blocks public access to the bucket defined above
resource "aws_s3_bucket_public_access_block" "invoice_block_public" {
  bucket = aws_s3_bucket.invoice-bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Creates a bucket policy for the invoice bucket,
# so that only the specified Lambda role is allowed to upload files (e.g. PDF invoices).
resource "aws_s3_bucket_policy" "invoice_bucket_policy" {
  bucket = aws_s3_bucket.invoice-bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        AWS = var.lambda_role_arn
      },
      Action = ["s3:PutObject"],
      Resource = "${aws_s3_bucket.invoice-bucket.arn}/*"
    }]
  })
}



