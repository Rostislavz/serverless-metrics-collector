# Check for existing IAM Policies
data "aws_iam_policy" "existing_lambda_collector_policy" {
  name = "LambdaCollectorPolicy"
  count = 1
}

data "aws_iam_policy" "existing_lambda_processor_policy" {
  name = "LambdaProcessorPolicy"
  count = 1
}

# Check for existing IAM Roles
data "aws_iam_role" "existing_lambda_collector_role" {
  name = "LambdaCollectorRole"
  count = 1
}

data "aws_iam_role" "existing_lambda_processor_role" {
  name = "LambdaProcessorRole"
  count = 1
}

# Create IAM Policies if they do not exist
resource "aws_iam_policy" "lambda_collector_policy" {
  count       = length(data.aws_iam_policy.existing_lambda_collector_policy) > 0 ? 0 : 1
  name        = "LambdaCollectorPolicy"
  description = "Allows Lambda collector to get metrics and store in S3"
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
}

resource "aws_iam_policy" "lambda_processor_policy" {
  count       = length(data.aws_iam_policy.existing_lambda_processor_policy) > 0 ? 0 : 1
  name        = "LambdaProcessorPolicy"
  description = "Allows Lambda processor to read metrics from S3"
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
}

# Create IAM Roles if they do not exist
resource "aws_iam_role" "lambda_collector_role" {
  count       = length(data.aws_iam_role.existing_lambda_collector_role) > 0 ? 0 : 1
  name        = "LambdaCollectorRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Effect = "Allow"
      }
    ]
  })
}

resource "aws_iam_role" "lambda_processor_role" {
  count       = length(data.aws_iam_role.existing_lambda_processor_role) > 0 ? 0 : 1
  name        = "LambdaProcessorRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Effect = "Allow"
      }
    ]
  })
}

# Attach policies to roles
resource "aws_iam_role_policy_attachment" "lambda_collector_attach" {
  policy_arn = length(data.aws_iam_policy.existing_lambda_collector_policy) > 0 ? data.aws_iam_policy.existing_lambda_collector_policy[0].arn : aws_iam_policy.lambda_collector_policy[0].arn
  role       = length(data.aws_iam_role.existing_lambda_collector_role) > 0 ? data.aws_iam_role.existing_lambda_collector_role[0].name : aws_iam_role.lambda_collector_role[0].name
}

resource "aws_iam_role_policy_attachment" "lambda_processor_attach" {
  policy_arn = length(data.aws_iam_policy.existing_lambda_processor_policy) > 0 ? data.aws_iam_policy.existing_lambda_processor_policy[0].arn : aws_iam_policy.lambda_processor_policy[0].arn
  role       = length(data.aws_iam_role.existing_lambda_processor_role) > 0 ? data.aws_iam_role.existing_lambda_processor_role[0].name : aws_iam_role.lambda_processor_role[0].name
}

# Lambda function configurations
resource "aws_lambda_function" "collector_lambda" {
  function_name = var.function_name
  s3_bucket     = var.bucket_name
  s3_key        = var.filename
  handler       = var.handler
  role          = coalesce(
                     join("", aws_iam_role.lambda_collector_role.*.arn),
                     join("", data.aws_iam_role.existing_lambda_collector_role.*.arn)
                   )
  runtime       = "python3.8"
}

resource "aws_lambda_function" "processor_lambda" {
  function_name = var.function_name
  s3_bucket     = var.bucket_name
  s3_key        = var.filename
  handler       = var.handler
  role          = coalesce(
                     join("", aws_iam_role.lambda_processor_role.*.arn),
                     join("", data.aws_iam_role.existing_lambda_processor_role.*.arn)
                   )
  runtime       = "python3.8"
}
