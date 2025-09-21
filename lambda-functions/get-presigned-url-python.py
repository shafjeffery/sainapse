import boto3
import json
import os
import time

# Initialize S3 client
s3 = boto3.client("s3", region_name="ap-southeast-1")
BUCKET = os.environ.get("BUCKET_NAME", "sainapse-documents")

def lambda_handler(event, context):
    try:
        print(f"Event: {json.dumps(event)}")
        
        # Parse request body
        if 'body' in event:
            body = json.loads(event['body'])
        else:
            body = event
            
        s3_key = body.get('s3Key')
        content_type = body.get('contentType', 'application/octet-stream')
        user_id = body.get('userId')
        
        if not s3_key or not user_id:
            return {
                "statusCode": 400,
                "headers": {
                    "Content-Type": "application/json",
                    "Access-Control-Allow-Origin": "*",
                    "Access-Control-Allow-Headers": "Content-Type",
                    "Access-Control-Allow-Methods": "POST, OPTIONS"
                },
                "body": json.dumps({
                    "error": "Missing required parameters: s3Key, userId"
                })
            }
        
        # Generate presigned URL for S3 upload
        key = f"uploads/{user_id}/{int(time.time())}-{s3_key.split('/')[-1]}"
        
        url = s3.generate_presigned_url(
            ClientMethod="put_object",
            Params={
                "Bucket": BUCKET, 
                "Key": key, 
                "ContentType": content_type
            },
            ExpiresIn=300  # 5 minutes
        )
        
        print(f"Generated presigned URL for key: {key}")
        
        return {
            "statusCode": 200,
            "headers": {
                "Content-Type": "application/json",
                "Access-Control-Allow-Origin": "*",
                "Access-Control-Allow-Headers": "Content-Type",
                "Access-Control-Allow-Methods": "POST, OPTIONS"
            },
            "body": json.dumps({
                "uploadUrl": url,
                "key": key,
                "expiresIn": 300
            })
        }
        
    except Exception as e:
        print(f"Error: {str(e)}")
        return {
            "statusCode": 500,
            "headers": {
                "Content-Type": "application/json",
                "Access-Control-Allow-Origin": "*",
                "Access-Control-Allow-Headers": "Content-Type",
                "Access-Control-Allow-Methods": "POST, OPTIONS"
            },
            "body": json.dumps({
                "error": "Failed to generate presigned URL",
                "details": str(e)
            })
        }
