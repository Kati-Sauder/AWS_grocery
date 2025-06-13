# Creates the Lambda function “generate_invoice”
resource "aws_lambda_function" "invoice_lambda" {
  function_name = "generate_invoice"
  role          = var.lambda_role_arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.11"
  timeout       = 10

  filename         = "${path.module}/../../lambda_function_payload.zip"
  source_code_hash = filebase64sha256("${path.module}/../../lambda_function_payload.zip")

  environment {
    variables = {
      BUCKET_NAME  = var.bucket_name
      SENDER_EMAIL = var.sender_email
    }
  }
}

# Log group for lambda outputs in CloudWatch
resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/${aws_lambda_function.invoice_lambda.function_name}"
  retention_in_days = 7  # Logs are kept for 7 days
}

# EventBridge rule: listens for events of type “OrderPlaced” from the source “ecommerce.app”
resource "aws_cloudwatch_event_rule" "order_event" {
  name = "order_placed_event"
  event_pattern = jsonencode({
    source      = ["grocery-mate.app"],
    detail-type = ["OrderPlaced"]
  })
}

# Links the rule with the lambda function
resource "aws_cloudwatch_event_target" "lambda_target" {
  rule = aws_cloudwatch_event_rule.order_event.name
  arn  = aws_lambda_function.invoice_lambda.arn
}

# Allows EventBridge to call the Lambda function
resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.invoice_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.order_event.arn
}
