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

resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/${aws_lambda_function.invoice_lambda.function_name}"
  retention_in_days = 7
}

resource "aws_cloudwatch_event_rule" "order_event" {
  name = "order_placed_event"
  event_pattern = jsonencode({
    source      = ["ecommerce.app"],
    detail-type = ["OrderPlaced"]
  })
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule = aws_cloudwatch_event_rule.order_event.name
  arn  = aws_lambda_function.invoice_lambda.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.invoice_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.order_event.arn
}
