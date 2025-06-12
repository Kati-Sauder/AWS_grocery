output "lambda_function_name" {
  description = "Name der Lambda-Funktion"
  value       = aws_lambda_function.invoice_lambda.function_name
}

output "lambda_function_arn" {
  description = "ARN der Lambda-Funktion"
  value       = aws_lambda_function.invoice_lambda.arn
}