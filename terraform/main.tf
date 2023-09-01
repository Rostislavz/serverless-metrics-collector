provider "aws" {
  region = "eu-central-1"
}

module "lambda_collector" {
  source      = "./modules/lambda"
  bucket_name = var.s3_bucket_name
  filename    = var.lambda_collector_filename
  handler     = "handler.collector_handler"
  function_name = var.lambda_collector_configurations.function_name
}

module "lambda_processor" {
  source      = "./modules/lambda"
  bucket_name = var.s3_bucket_name
  filename    = var.lambda_processor_filename
  handler     = "handler.processor_handler"
  function_name = "LambdaProcessor"
}

module "eventbridge" {
  source         = "./modules/eventbridge"
  function_arn   = module.lambda_collector.collector_lambda_arn
  schedule       = "cron(0 12 * * ? *)" # Every day at 12 PM UTC
}

# Setup backend
terraform {
  backend "s3" {
    bucket = "serverless-metrics-collector-130823"
    key    = "terraform/application/terraform.tfstate"
    region = "eu-central-1"
  }
}
