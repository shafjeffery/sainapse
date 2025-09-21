import '../config/aws_credentials.dart';

class AWSConfig {
  // AWS Configuration - Uses credentials from environment variables
  static String get region => AWSCredentials.region;
  static String get accessKeyId => AWSCredentials.accessKeyId;
  static String get secretAccessKey => AWSCredentials.secretAccessKey;
  static String get bucketName => AWSCredentials.bucketName;

  // AWS Service Endpoints
  static String get s3Endpoint => 'https://s3.$region.amazonaws.com';
  static String get textractEndpoint =>
      'https://textract.$region.amazonaws.com';
  static String get bedrockEndpoint =>
      'https://bedrock-runtime.$region.amazonaws.com';

  // S3 Configuration
  static const String s3Prefix = 'flashnotes/';
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB

  // Supported file types
  static const List<String> supportedImageTypes = [
    'image/jpeg',
    'image/png',
    'image/tiff',
    'image/webp',
  ];

  static const List<String> supportedDocumentTypes = [
    'application/pdf',
    'application/msword',
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
  ];

  static const List<String> supportedVideoTypes = [
    'video/mp4',
    'video/avi',
    'video/mov',
    'video/wmv',
  ];

  // Textract Configuration
  static const String textractApiVersion = '2018-06-27';

  // Bedrock Configuration
  static const String bedrockModelId =
      'anthropic.claude-3-sonnet-20240229-v1:0';
  static const int maxTokens = 4000;
  static const double temperature = 0.7;
}
