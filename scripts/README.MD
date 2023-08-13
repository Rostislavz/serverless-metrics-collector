
# Scripts usage

## provision_s3.sh

1. Ensure you have the AWS CLI installed and properly configured with the necessary access rights.
2. Provide execute permissions: ```chmod +x provision_s3.sh```.
3. Run the script: ```./provision_s3.sh```.
4. Follow the on-screen prompts to input the desired bucket name and region.

### Requirements:

1. Bucket name;
2. Region for bucket.

### Usage example:
```sh
./scripts/provision_s3.sh
Enter the desired S3 bucket name: serverless-metrics-collector-130823
Enter the AWS region (e.g., us-west-1): eu-central-1
S3 Bucket serverless-metrics-collector-130823 provisioned and prepared successfully.
```

