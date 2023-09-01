import boto3
import json
import os

# Initialize clients
ec2_client = boto3.client('ec2')
s3_client = boto3.client('s3')

S3_BUCKET_NAME = os.environ['S3_BUCKET_NAME']  # The S3 bucket where metrics will be stored

def lambda_handler(event, context):
    try:
        # Collect metrics for unattached volumes
        unattached_volumes = ec2_client.describe_volumes(
            Filters=[
                {'Name': 'status', 'Values': ['available']}
            ]
        )

        unattached_volumes_count = len(unattached_volumes['Volumes'])
        unattached_volumes_size = sum([volume['Sipipze'] for volume in unattached_volumes['Volumes']])
        
        # Collect metrics for non-encrypted volumes
        non_encrypted_volumes = ec2_client.describe_volumes(
            Filters=[
                {'Name': 'encrypted', 'Values': ['false']}
            ]
        )

        non_encrypted_volumes_count = len(non_encrypted_volumes['Volumes'])
        
        # Collect metrics for non-encrypted snapshots
        non_encrypted_snapshots = ec2_client.describe_snapshots(
            Filters=[
                {'Name': 'encrypted', 'Values': ['false']}
            ],
            OwnerIds=['self']
        )
        
        non_encrypted_snapshots_count = len(non_encrypted_snapshots['Snapshots'])

        # Prepare data for storage
        metrics_data = {
            'unattached_volumes_count': unattached_volumes_count,
            'unattached_volumes_size': unattached_volumes_size,
            'non_encrypted_volumes_count': non_encrypted_volumes_count,
            'non_encrypted_snapshots_count': non_encrypted_snapshots_count
        }

        # Convert data to JSON string
        json_data = json.dumps(metrics_data)

        # Store metrics data in S3 bucket
        response = s3_client.put_object(
            Bucket=S3_BUCKET_NAME,
            Key=f'metrics/{context.aws_request_id}.json',
            Body=json_data,
            ContentType='application/json',
            ServerSideEncryption='AES256'  # Server-side encryption
        )

        print(f"Metrics stored in S3 with key: metrics/{context.aws_request_id}.json")

    except Exception as e:
        print(f"Error collecting metrics: {str(e)}")
        raise

    return {
        'statusCode': 200,
        'body': json.dumps('Metrics collection and storage successful!')
    }
