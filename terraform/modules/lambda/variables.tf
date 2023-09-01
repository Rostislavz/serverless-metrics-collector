variable "bucket_name" {
  description = "The S3 bucket name to store Lambda artifacts"
  type        = string
}

variable "filename" {
  description = "The filename of the Lambda artifact"
  type        = string
}

variable "handler" {
  description = "The handler for the Lambda function"
  type        = string
}

variable "function_name" {
  description = "Name of the lambda function"
  type        = string
}

variable "lambda_runtime" {
  description = "The runtime for the Lambda function"
  type        = string
  default     = "python3.10"
}
  