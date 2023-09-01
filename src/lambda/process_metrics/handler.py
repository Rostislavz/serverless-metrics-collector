import boto3
import json
import os

s3_client = boto3.client('s3')

S3_BUCKET_NAME = os.environ['S3_BUCKET_NAME']  # The S3 bucket where metrics are stored

def lambda_handler(event, context):
    try:
        # Assuming metrics are stored in a folder named 'metrics' in S3
        metrics_folder = 'metrics/'

        # List all metric files in the S3 bucket
        metric_files = s3_client.list_objects_v2(
            Bucket=S3_BUCKET_NAME,
            Prefix=metrics_folder
        )
        
        # Process each metric file
        for metric_object in metric_files.get('Contents', []):
            # Get metrics content from S3 object
            response = s3_client.get_object(
                Bucket=S3_BUCKET_NAME,
                Key=metric_object['Key']
            )
            metrics_data = json.loads(response['Body'].read().decode('utf-8'))
            
            # Processing metrics
            # (Add any processing logic needed here, e.g., sending alerts or generating reports)

            # Example: sending an alert if non-encrypted volumes count exceeds a threshold
            if metrics_data['non_encrypted_volumes_count'] > 5:
                print(f"Alert: High number of non-encrypted volumes detected! Count: {metrics_data['non_encrypted_volumes_count']}")
            
            # Similarly, you can process for other metrics, create visualizations, or integrate with third-party tools

            # Once processed, you can move the processed metrics file to a different location in S3 or delete it if necessary

    except Exception as e:
        print(f"Error processing metrics: {str(e)}")
        raise

    return {
        'statusCode': 200,
        'body': json.dumps('Metrics processing successful!')
    }
