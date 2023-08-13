# serverless-metrics-collector
This repository contains the essential components for a serverless application designed to collect and manage metrics for AWS-based infrastructure. Utilizing AWS Serverless services like EventBridge and Lambda, it offers a streamlined approach to monitoring and managing infrastructure metrics.

# Contents:

**Application Code**: The core logic for collecting infrastructure metrics, implemented using AWS Lambda functions and integrated with EventBridge for event-driven processing.

**Application Setup Code**: Scripts and configuration files to facilitate the deployment and management of the application within AWS, including Terraform scripts for provisioning and setup.

**Sandbox Setup Code**: This includes the code and scripts to set up the development and testing environment, with provisions for disks, snapshots, and other essential resources.

The application leverages Terraform for provisioning, allowing for seamless deployment and scalability. Whether you're looking to monitor your own AWS infrastructure or build on this foundation for more extensive monitoring capabilities, "serverless-metrics-collector" offers a robust starting point.

# Repo structure:

```
/serverless-metrics-collector
│
├── src/: Main application code.
│ ├── lambda/: AWS Lambda function code.
│ │ ├── collect_metrics/
│ │ │ └── handler.py: Lambda handler for metric collection.
│ │ └── process_metrics/
│ │ └── handler.py: Lambda handler for metric processing.
│ │
│ └── events/: EventBridge rules and configurations.
│ └── eventbridge_rule.json
│
├── terraform/: Terraform code for provisioning the main application.
│ ├── modules/: Reusable Terraform modules.
│ │ ├── lambda/
│ │ └── eventbridge/
│ │
│ ├── main.tf
│ ├── variables.tf
│ └── outputs.tf
│
├── sandbox/: Terraform files and scripts for sandbox setup.
│ ├── terraform/: Terraform configurations specific to sandbox.
│ │ ├── disks/
│ │ │ ├── main.tf
│ │ │ ├── variables.tf
│ │ │ └── outputs.tf
│ │ └── snapshots/
│ │ ├── main.tf
│ │ ├── variables.tf
│ │ └── outputs.tf
│ │
│ └── setup.sh: General setup script for the sandbox environment.
│
├── scripts/: Utility scripts for deployment and teardown.
│ ├── deploy.sh
│ └── destroy.sh
│
├── tests/: Unit and integration tests.
│ ├── unit/
│ └── integration/
│
├── README.md: Repository description and guidelines.
└── .gitignore: Files and directories to ignore in git.
```