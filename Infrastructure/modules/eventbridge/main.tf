resource "aws_cloudwatch_event_rule" "order_event" {
  name = "order_placed_event"

  event_pattern = jsonencode({
    source      = ["ecommerce.app"],
    "detail-type" = ["OrderPlaced"]
  })
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule = aws_cloudwatch_event_rule.order_event.name
  arn  = var.lambda_arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.order_event.arn
}
