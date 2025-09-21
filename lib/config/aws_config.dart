class AWSConfig {
  // API Gateway Configuration (No AWS keys needed - using presigned URLs)
  static const String apiGatewayUrl = 'https://o814sfjzrk.execute-api.ap-southeast-1.amazonaws.com/prod';
  
  // S3 Configuration
  static const String s3BucketName = 'sainapse-documents';
  
  // DynamoDB Configuration
  static const String quizTableName = 'sainapse-quizzes';
  static const String userTableName = 'sainapse-users';
  
  // Bedrock Configuration
  static const String bedrockModelId = 'anthropic.claude-3-sonnet-20240229-v1:0';
  
  // Region (for reference only)
  static const String region = 'ap-southeast-1';
}
