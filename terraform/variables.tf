variable "s3_bucket_name" {
  description = "The S3 bucket name to store Lambda artifacts and metrics"
  type        = string
  default     = "serverless-metrics-collector-130823"
}

variable "lambda_collector_filename" {
  description = "Filename of the collector Lambda artifact"
  type        = string
  default     = "/lambda/collector/handler.zip"
}

variable "lambda_processor_filename" {
  description = "Filename of the processor Lambda artifact"
  type        = string
  default     = "/lambda/processor/handler.zip"
}

variable "lambda_processor_configurations" {
  default = [
    {
      lambda_name = "example-lambda1",
      handler     = "index.handler",
      runtime     = "nodejs14.x",
      source_code = "path/to/lambda1.zip",
      s3_bucket   = "my-bucket",
      s3_key      = "lambda1.zip",

      role_name   = "example-lambda-role1",
      policy_name = "example-lambda-policy1",
      policy      = jsonencode({
        Version = "2012-10-17",
        Statement = [
          {
            Action   = "s3:GetObject",
            Effect   = "Allow",
            Resource = "arn:aws:s3:::serverless-metrics-collector-130823//metrics/*"
          }
        ]
      })
    },
    // Add more configurations as needed
  ]
}

variable "lambda_collector_configurations" {
  default = [
    {
      lambda_name = "LambdaCollector",
      handler     = "handler.collector_handler",
      runtime     = "nodejs14.x",
      source_code = "path/to/lambda1.zip",
      s3_bucket   = "my-bucket",
      s3_key      = "lambda1.zip",

      role_name   = "example-lambda-role1",
      policy_name = "example-lambda-policy1",
      policy      = jsonencode({
        Version = "2012-10-17",
        Statement = [
          {
            Action   = ["ec2:DescribeVolumes", "ec2:DescribeSnapshots"],
            Effect   = "Allow",
            Resource = "*"
          },
          {
            Action   = "s3:PutObject",
            Effect   = "Allow",
            Resource = "arn:aws:s3:::serverless-metrics-collector-130823/metrics/*"
          }
        ]
      })
    },
    // Add more configurations as needed
  ]
}