# Creates an EventBridge rule that reacts to a user-defined event with the type “OrderPlaced”
# and the source “ecommerce.app”. This event could be triggered, for example, when a customer
# places an order in the Grocery-Mate app.
# As of now, this is a theoretical approach.
resource "aws_cloudwatch_event_rule" "order_event" {
  name = "order_placed_event"

  event_pattern = jsonencode({
    source      = ["grocery-mate.app"],
    "detail-type" = ["OrderPlaced"]
  })
}

# Links the EventBridge rule defined above with a Lambda function.
# When the event is triggered, this function is called automatically.
resource "aws_cloudwatch_event_target" "lambda_target" {
  rule = aws_cloudwatch_event_rule.order_event.name
  arn  = var.lambda_arn
}

# Gives EventBridge the authorization to execute the specified Lambda function.
# Without this explicit permission, EventBridge cannot call the function.
resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.order_event.arn
}
