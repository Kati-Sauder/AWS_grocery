# Specifies the name of the IAM instance profile that is assigned to EC2 instances at startup.
# Is used in the EC2 module or Auto Scaling to transfer the IAM role to instances.
output "ec2_profile_name" { value = aws_iam_instance_profile.ec2_profile.name }

# Returns the ARN (Amazon Resource Name) of the IAM role that is assigned to the Lambda function.
# Enables the Lambda function to access S3, SES and CloudWatch in accordance with the assigned policy.
output "lambda_role_arn" {
  value = aws_iam_role.lambda_role.arn
}