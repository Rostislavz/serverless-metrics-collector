# Serverless Metrics Collector Sandbox Infrastructure Setup

This repository contains the Terraform code to set up the necessary cloud infrastructure for the Serverless Metrics Collector sandbox. The sandbox includes EBS disks and snapshots according to the specified requirements.

## Configuration

The infrastructure setup is controlled through variables, which are defined in the `variables.tf` file. Here's a brief overview of the main configurable variables:

- `region`: The AWS region where the resources will be deployed. Default is `eu-central-1`.
- `backend_bucket`: The name of the S3 bucket used to store the Terraform state files.
- `unattached_disks_count`: Number of unattached EBS disks to create.
- `unattached_disks_size`: Size (in GB) for the unattached EBS disks.
- `non_encrypted_disks_count`: Number of non-encrypted EBS disks to create.
- `non_encrypted_disks_size`: Size (in GB) for the non-encrypted EBS disks.
- `non_encrypted_snapshots_count`: Number of non-encrypted EBS snapshots to create.

## Usage

1. **Configure AWS Credentials**: Ensure your AWS credentials are configured properly either through environment variables or the AWS CLI.

2. **Initialize Terraform**:
   ```bash
   terraform init
   ```
3. **Plan the Deployment**:
    ```bash
    terraform plan
    ```
4. **Apply the Deployment**:
    ```bash
    terraform apply
    ```

## Cleaning Up

To destroy the resources created by Terraform:

```bash
terraform destroy
```

## Support & Contribution

Feel free to fork this repository, submit PRs, or report issues.

## License

