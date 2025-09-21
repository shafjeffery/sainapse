// AWS Credentials Configuration
// Using environment variables from .env file for security

import 'package:flutter_dotenv/flutter_dotenv.dart';

class AWSCredentials {
  // Get credentials from environment variables
  static String get accessKeyId =>
      dotenv.env['AWS_ACCESS_KEY_ID'] ?? 'YOUR_ACCESS_KEY_ID';
  static String get secretAccessKey =>
      dotenv.env['AWS_SECRET_ACCESS_KEY'] ?? 'YOUR_SECRET_ACCESS_KEY';
  static String get region => dotenv.env['AWS_REGION'] ?? 'ap-southeast-1';
  static String get bucketName =>
      dotenv.env['AWS_S3_BUCKET'] ?? 'sainapse-flashnotes';

  // Instructions for setup:
  // 1. Create an AWS account at https://aws.amazon.com/
  // 2. Go to IAM (Identity and Access Management)
  // 3. Create a new user with programmatic access
  // 4. Attach the following policies:
  //    - AmazonS3FullAccess (for file uploads)
  //    - AmazonTextractFullAccess (for document processing)
  //    - AmazonBedrockFullAccess (for AI summarization)
  // 5. Copy the Access Key ID and Secret Access Key
  // 6. Create a .env file in your project root with your credentials
  // 7. Create an S3 bucket with the name specified above

  // Environment Variables Required in .env file:
  // AWS_ACCESS_KEY_ID=your_actual_access_key_id
  // AWS_SECRET_ACCESS_KEY=your_actual_secret_access_key
  // AWS_REGION=ap-southeast-1
  // AWS_S3_BUCKET=your_bucket_name

  // Security Note:
  // Never commit the .env file to version control. Add it to .gitignore.
}
