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

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-instance-profile"
  role = aws_iam_role.ec2_connect_role.name
}

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

resource "aws_iam_policy" "lambda_policy" {
  name = "lambda_invoice_policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = ["s3:PutObject"],
        Effect = "Allow",
        Resource = "${var.bucket_arn}/*"
      },
      {
        Action = ["ses:SendEmail", "ses:SendRawEmail"],
        Effect = "Allow",
        Resource = "*"
      },
      {
        Action = ["logs:*"],
        Effect = "Allow",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}
