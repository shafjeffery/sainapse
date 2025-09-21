import boto3
import json
import os
import base64
from datetime import datetime

# Initialize AWS clients
textract = boto3.client('textract', region_name='ap-southeast-1')
bedrock = boto3.client('bedrock-runtime', region_name='ap-southeast-1')
dynamodb = boto3.resource('dynamodb', region_name='ap-southeast-1')

# Environment variables
QUIZ_TABLE = os.environ.get('QUIZ_TABLE', 'sainapse-quizzes')
BEDROCK_MODEL_ID = os.environ.get('BEDROCK_MODEL_ID', 'anthropic.claude-3-sonnet-20240229-v1:0')

def lambda_handler(event, context):
    try:
        print(f"Event: {json.dumps(event)}")
        
        # Parse request body
        if 'body' in event:
            body = json.loads(event['body'])
        else:
            body = event
            
        s3_bucket = body.get('s3Bucket')
        s3_key = body.get('s3Key')
        user_id = body.get('userId')
        document_id = body.get('documentId')
        
        if not all([s3_bucket, s3_key, user_id, document_id]):
            return {
                "statusCode": 400,
                "headers": {
                    "Content-Type": "application/json",
                    "Access-Control-Allow-Origin": "*",
                    "Access-Control-Allow-Headers": "Content-Type",
                    "Access-Control-Allow-Methods": "POST, OPTIONS"
                },
                "body": json.dumps({
                    "error": "Missing required parameters: s3Bucket, s3Key, userId, documentId"
                })
            }
        
        # Step 1: Extract text using Textract
        print(f"Extracting text from S3://{s3_bucket}/{s3_key}")
        extracted_text = extract_text_from_s3(s3_bucket, s3_key)
        
        if not extracted_text.strip():
            return {
                "statusCode": 400,
                "headers": {
                    "Content-Type": "application/json",
                    "Access-Control-Allow-Origin": "*",
                    "Access-Control-Allow-Headers": "Content-Type",
                    "Access-Control-Allow-Methods": "POST, OPTIONS"
                },
                "body": json.dumps({
                    "error": "No text could be extracted from the document"
                })
            }
        
        print(f"Extracted text length: {len(extracted_text)} characters")
        print(f"Sample text: {extracted_text[:200]}...")
        
        # Step 2: Generate quiz using Bedrocks
        print("Generating quiz using Bedrock...")
        quiz_data = generate_quiz_with_bedrock(extracted_text, user_id, document_id)
        
        # Step 3: Save to DynamoDB
        print("Saving quiz to DynamoDB...")
        save_quiz_to_dynamodb(quiz_data)
        
        return {
            "statusCode": 200,
            "headers": {
                "Content-Type": "application/json",
                "Access-Control-Allow-Origin": "*",
                "Access-Control-Allow-Headers": "Content-Type",
                "Access-Control-Allow-Methods": "POST, OPTIONS"
            },
            "body": json.dumps({
                "success": True,
                "documentId": document_id,
                "quizId": quiz_data['id'],
                "extractedTextLength": len(extracted_text),
                "questionsCount": len(quiz_data['questions'])
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
                "error": "Failed to process document",
                "details": str(e)
            })
        }

def extract_text_from_s3(bucket, key):
    """Extract text from document in S3 using Textract"""
    try:
        response = textract.detect_document_text(
            Document={
                'S3Object': {
                    'Bucket': bucket,
                    'Name': key
                }
            }
        )
        
        # Extract text from Textract response
        text_blocks = []
        for block in response['Blocks']:
            if block['BlockType'] == 'LINE':
                text_blocks.append(block['Text'])
        
        return '\n'.join(text_blocks)
        
    except Exception as e:
        print(f"Textract error: {str(e)}")
        raise e

def generate_quiz_with_bedrock(text, user_id, document_id):
    """Generate quiz questions using Bedrock Claude"""
    try:
        # Create a strict prompt that forces the model to use only the provided text
        prompt = f"""TASK:
You are a quiz generator. Use ONLY the text below to create quiz questions. 
Do not invent facts not found in the passage. Base every question and answer on the provided text.

Output exactly 5 questions in JSON format:
{{
  "questions": [
    {{
      "id": "q1",
      "type": "mcq",
      "question": "string",
      "options": ["opt1","opt2","opt3","opt4"],
      "answer": 0,
      "explanation": "short explanation from passage"
    }}
  ]
}}

PASSAGE:
{text}

IMPORTANT: Only create questions about information that is explicitly stated in the passage above. Do not add external knowledge."""

        # Call Bedrock
        response = bedrock.invoke_model(
            modelId=BEDROCK_MODEL_ID,
            body=json.dumps({
                "anthropic_version": "bedrock-2023-05-31",
                "max_tokens": 2000,
                "messages": [
                    {
                        "role": "user",
                        "content": prompt
                    }
                ]
            })
        )
        
        # Parse response
        response_body = json.loads(response['body'].read())
        quiz_content = response_body['content'][0]['text']
        
        # Extract JSON from the response
        start_idx = quiz_content.find('{')
        end_idx = quiz_content.rfind('}') + 1
        quiz_json = json.loads(quiz_content[start_idx:end_idx])
        
        # Create quiz object
        quiz_id = f"quiz_{int(datetime.now().timestamp())}"
        quiz_data = {
            "id": quiz_id,
            "title": "Quiz from Your Document",
            "description": "Generated from the content in your uploaded image",
            "questions": quiz_json['questions'],
            "createdAt": datetime.now().isoformat(),
            "status": "completed",
            "userId": user_id,
            "documentId": document_id,
            "totalQuestions": len(quiz_json['questions'])
        }
        
        return quiz_data
        
    except Exception as e:
        print(f"Bedrock error: {str(e)}")
        raise e

def save_quiz_to_dynamodb(quiz_data):
    """Save quiz to DynamoDB"""
    try:
        table = dynamodb.Table(QUIZ_TABLE)
        
        # Convert datetime to string for JSON serialization
        quiz_data['createdAt'] = quiz_data['createdAt']
        
        table.put_item(Item=quiz_data)
        print(f"Quiz saved to DynamoDB: {quiz_data['id']}")
        
    except Exception as e:
        print(f"DynamoDB error: {str(e)}")
        raise e
