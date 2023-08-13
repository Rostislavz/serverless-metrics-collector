#!/bin/bash

# Prompt for user input
read -p "Enter the desired S3 bucket name: " BUCKET_NAME
read -p "Enter the AWS region (e.g., us-west-1): " REGION

# Ensure bucket name and region are provided
if [[ -z "$BUCKET_NAME" || -z "$REGION" ]]; then
    echo "Both bucket name and region are required!"
    exit 1
fi

# Create S3 Bucket
aws s3api create-bucket --bucket $BUCKET_NAME --region $REGION --create-bucket-configuration LocationConstraint=$REGION

# Enable versioning for the bucket
aws s3api put-bucket-versioning --bucket $BUCKET_NAME --versioning-configuration Status=Enabled

# Enable server-side encryption using Amazon S3-Managed Keys (SSE-S3)
aws s3api put-bucket-encryption --bucket $BUCKET_NAME --server-side-encryption-configuration '{
    "Rules": [
        {
            "ApplyServerSideEncryptionByDefault": {
                "SSEAlgorithm": "AES256"
            }
        }
    ]
}'

# Setup folder structure within the bucket
aws s3api put-object --bucket $BUCKET_NAME --key "lambda/"
aws s3api put-object --bucket $BUCKET_NAME --key "terraform/sandbox_infrastructure/"
aws s3api put-object --bucket $BUCKET_NAME --key "terraform/application/"
aws s3api put-object --bucket $BUCKET_NAME --key "metrics/"

echo "S3 Bucket $BUCKET_NAME provisioned and prepared successfully."
