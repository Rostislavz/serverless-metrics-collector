output "collector_lambda_arn" {
  description = "The ARN of the collector Lambda function"
  value       = aws_lambda_function.collector_lambda.arn
}

output "processor_lambda_arn" {
  description = "The ARN of the processor Lambda function"
  value       = aws_lambda_function.processor_lambda.arn
}
