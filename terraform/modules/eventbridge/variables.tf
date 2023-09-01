variable "function_arn" {
  description = "ARN of the Lambda function to be triggered"
  type        = string
}

variable "schedule" {
  description = "Schedule in cron or rate format for EventBridge"
  type        = string
}
