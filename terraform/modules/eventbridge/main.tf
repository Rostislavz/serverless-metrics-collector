resource "aws_cloudwatch_event_rule" "daily" {
  name                = "DailyMetricCollection"
  schedule_expression = var.schedule
}

resource "aws_cloudwatch_event_target" "daily_lambda" {
  rule      = aws_cloudwatch_event_rule.daily.name
  target_id = "DailyMetricCollectionLambda"
  arn       = var.function_arn
}
