.PHONY: build_collector build_processor validate_sandbox validate_app deploy_s3 deploy_sandbox deploy_collector deploy_processor deploy_app destroy_sandbox destroy_app clean

# Variables
S3_BUCKET_NAME = "serverless-metrics-collector-130823"
SANDBOX_TF_DIR = sandbox/terraform
APPLICATION_TF_DIR = terraform

# Build Lambda handlers into individual zip archives
build_collector:
	@echo "Building collect_metrics lambda..."
	cd src/lambda/collect_metrics && zip handler.zip handler.py

build_processor:
	@echo "Building process_metrics lambda..."
	cd src/lambda/process_metrics && zip handler.zip handler.py

# Validate terraform for sandbox and application
validate_sandbox:
	@echo "Validating sandbox Terraform configuration..."
	cd $(SANDBOX_TF_DIR) && terraform init && terraform validate

validate_app:
	@echo "Validating application Terraform configuration..."
	cd $(APPLICATION_TF_DIR) && terraform init && terraform validate

# Deploy the application components individually
deploy_s3:
	@echo "Uploading lambda artifacts to S3..."
	aws s3 cp src/lambda/collect_metrics/handler.zip s3://$(S3_BUCKET_NAME)/lambda/collector/
	aws s3 cp src/lambda/process_metrics/handler.zip s3://$(S3_BUCKET_NAME)/lambda/processor/

deploy_sandbox:
	@echo "Deploying sandbox infrastructure with Terraform..."
	cd $(SANDBOX_TF_DIR) && terraform init && terraform apply

deploy_collector: build_collector deploy_s3
	@echo "Deploying collect_metrics with Terraform..."
	cd $(APPLICATION_TF_DIR) && terraform init && terraform apply -target=module.lambda.aws_lambda_function.collect_metrics

deploy_processor: build_processor deploy_s3
	@echo "Deploying process_metrics with Terraform..."
	cd $(APPLICATION_TF_DIR) && terraform init && terraform apply -target=module.lambda.aws_lambda_function.process_metrics

# Deploy the entire application
deploy_app: build_collector build_processor deploy_s3
	@echo "Deploying the entire application with Terraform..."
	cd $(APPLICATION_TF_DIR) && terraform init && terraform apply

# Destroy the sandbox and application
destroy_sandbox:
	@echo "Destroying sandbox infrastructure with Terraform..."
	cd $(SANDBOX_TF_DIR) && terraform destroy

destroy_app:
	@echo "Destroying application with Terraform..."
	cd $(APPLICATION_TF_DIR) && terraform destroy

# Clean up generated artifacts
clean:
	@echo "Cleaning up artifacts..."
	rm -f src/lambda/collect_metrics/handler.zip
	rm -f src/lambda/process_metrics/handler.zip
