output "ec2_profile_name" { value = aws_iam_instance_profile.ec2_profile.name }

output "lambda_role_arn" {
  value = aws_iam_role.lambda_role.arn
}