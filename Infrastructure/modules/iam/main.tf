# IAM Instance Profile, which assigns the role of the EC2 instance (used at EC2 start)
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-instance-profile"
  role = aws_iam_role.ec2_connect_role.name
}

# IAM Role for EC2 instances to connect to EC2 Instance Connect (SSH via console)
resource "aws_iam_role" "ec2_connect_role" {
  name = "ec2-instance-connect-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "ec2.amazonaws.com" },
      Action = "sts:AssumeRole"
    }]
  })
}

# IAM policy for the EC2 Connect role, allows sending the SSH public key (EC2 Instance Connect)
resource "aws_iam_role_policy" "ec2_connect_policy" {
  name = "ec2-instance-connect-policy"
  role = aws_iam_role.ec2_connect_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = "ec2-instance-connect:SendSSHPublicKey",
      Resource = "*"
    }]
  })
}

# IAM role for Lambda function so that it can call necessary AWS services
resource "aws_iam_role" "lambda_role" {
  name = "lambda_invoice_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# IAM policy for the Lambda function:
# - Allows to write files to an S3 bucket (e.g. invoices)
# - Allows to send emails via SES
# - Allows to write logs to CloudWatch
resource "aws_iam_policy" "lambda_policy" {
  name = "lambda_invoice_policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = ["s3:PutObject"], # s3 access to the invoice bucket
        Effect = "Allow",
        Resource = "${var.bucket_arn}/*"
      },
      {
        Action = ["ses:SendEmail", "ses:SendRawEmail"], # Send Email via SES
        Effect = "Allow",
        Resource = "*"
      },
      {
        Action = ["logs:*"], # Allow CloudWatch logging
        Effect = "Allow",
        Resource = "*"
      }
    ]
  })
}

# Links the above policy with the Lambda role
resource "aws_iam_role_policy_attachment" "lambda_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}
