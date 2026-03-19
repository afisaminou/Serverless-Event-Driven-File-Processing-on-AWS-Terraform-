import json
import boto3
import uuid
import os
from datetime import datetime

dynamodb = boto3.resource('dynamodb')
sns = boto3.client('sns')

TABLE_NAME = os.environ['TABLE_NAME']
SNS_TOPIC_ARN = os.environ['SNS_TOPIC_ARN']

table = dynamodb.Table(TABLE_NAME)

def lambda_handler(event, context):
    try:
        # Extract S3 details
        record = event['Records'][0]
        bucket_name = record['s3']['bucket']['name']
        object_key = record['s3']['object']['key']
        file_size = record['s3']['object']['size']

        # Generate metadata
        file_id = str(uuid.uuid4())
        timestamp = datetime.utcnow().isoformat()

        # Store metadata in DynamoDB
        table.put_item(
            Item={
                'file_id': file_id,
                'bucket': bucket_name,
                'file_name': object_key,
                'file_size': file_size,
                'uploaded_at': timestamp
            }
        )

        # Send SNS notification
        message = (
            f"New file uploaded:\n"
            f"Bucket: {bucket_name}\n"
            f"File: {object_key}\n"
            f"Size: {file_size} bytes\n"
            f"Time: {timestamp}"
        )

        sns.publish(
            TopicArn=SNS_TOPIC_ARN,
            Message=message,
            Subject="New File Uploaded"
        )

        return {
            'statusCode': 200,
            'body': json.dumps('File processed successfully')
        }

    except Exception as e:
        print("Error:", str(e))
        raise e
