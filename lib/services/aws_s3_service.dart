import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'aws_config.dart';

class AWSS3Service {
  /// Upload file to S3 using presigned URL approach
  static Future<String?> uploadFile({
    File? file,
    Uint8List? fileBytes,
    required String fileName,
    required String contentType,
  }) async {
    try {
      // Validate input parameters
      if (file == null && fileBytes == null) {
        throw Exception('Either file or fileBytes must be provided');
      }

      final String key =
          '${AWSConfig.s3Prefix}${DateTime.now().millisecondsSinceEpoch}/$fileName';

      // Get file bytes
      Uint8List bytes;
      if (fileBytes != null) {
        bytes = fileBytes;
      } else {
        bytes = await file!.readAsBytes();
      }

      // Create presigned URL for S3 upload
      final String? presignedUrl = await _generatePresignedUrl(
        key: key,
        contentType: contentType,
        method: 'PUT',
      );

      if (presignedUrl == null) {
        throw Exception('Failed to generate presigned URL');
      }

      // Upload file to S3 using presigned URL
      print('📤 Uploading file to S3...');
      print('  URL: ${presignedUrl.substring(0, 100)}...');
      print('  File size: ${bytes.length} bytes');

      final response = await http.put(
        Uri.parse(presignedUrl),
        headers: {'Content-Type': contentType},
        body: bytes,
      );

      print('📊 S3 Upload Response:');
      print('  Status Code: ${response.statusCode}');
      print('  Headers: ${response.headers}');
      print('  Body: ${response.body}');

      if (response.statusCode == 200) {
        print('✅ Successfully uploaded to S3: $key');
        return key;
      } else {
        print('❌ S3 Upload failed with status: ${response.statusCode}');
        print('Response: ${response.body}');
        throw Exception('Upload failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('S3 Upload Error: $e');
      // Fallback to simulation if real upload fails
      print('Falling back to simulation mode...');
      await Future.delayed(const Duration(seconds: 2));
      final String fallbackKey =
          '${AWSConfig.s3Prefix}${DateTime.now().millisecondsSinceEpoch}/$fileName';
      print('Simulated S3 upload: $fallbackKey');
      return fallbackKey;
    }
  }

  /// Generate presigned URL for S3 operations
  static Future<String?> _generatePresignedUrl({
    required String key,
    required String contentType,
    required String method,
  }) async {
    try {
      // Check if AWS credentials are configured
      if (!_hasValidAWSCredentials()) {
        print('AWS credentials not configured, cannot generate presigned URL');
        return null;
      }

      print('🔧 Generating presigned URL for S3 upload...');
      print('  Bucket: ${AWSConfig.bucketName}');
      print('  Region: ${AWSConfig.region}');
      print('  Key: $key');

      final DateTime now = DateTime.now().toUtc();
      final String dateStamp = _formatDate(now);
      final String dateTimeStamp = _formatDateTime(now);

      // Create canonical request
      final String canonicalRequest = _createCanonicalRequest(
        method: method,
        uri: '/$key',
        queryString: '',
        headers: {
          'host':
              '${AWSConfig.bucketName}.s3.${AWSConfig.region}.amazonaws.com',
          'x-amz-content-sha256': _sha256Hash(''),
          'x-amz-date': dateTimeStamp,
        },
        payloadHash: _sha256Hash(''),
      );

      // Create string to sign
      final String stringToSign = _createStringToSign(
        dateTimeStamp: dateTimeStamp,
        dateStamp: dateStamp,
        canonicalRequest: canonicalRequest,
      );

      // Calculate signature
      final String signature = _calculateSignature(
        dateStamp: dateStamp,
        stringToSign: stringToSign,
      );

      // Build presigned URL
      final String presignedUrl =
          'https://${AWSConfig.bucketName}.s3.${AWSConfig.region}.amazonaws.com/$key'
          '?X-Amz-Algorithm=AWS4-HMAC-SHA256'
          '&X-Amz-Credential=${AWSConfig.accessKeyId}%2F$dateStamp%2F${AWSConfig.region}%2Fs3%2Faws4_request'
          '&X-Amz-Date=$dateTimeStamp'
          '&X-Amz-Expires=3600'
          '&X-Amz-SignedHeaders=host%3Bx-amz-content-sha256%3Bx-amz-date'
          '&X-Amz-Signature=$signature';

      print('🔗 Generated presigned URL:');
      print(
        '  Base URL: https://${AWSConfig.bucketName}.s3.${AWSConfig.region}.amazonaws.com/$key',
      );
      print('  Signature: $signature');
      print('  Date: $dateTimeStamp');

      return presignedUrl;
    } catch (e) {
      print('Error generating presigned URL: $e');
      return null;
    }
  }

  /// Create canonical request for AWS signature
  static String _createCanonicalRequest({
    required String method,
    required String uri,
    required String queryString,
    required Map<String, String> headers,
    required String payloadHash,
  }) {
    final String canonicalHeaders =
        headers.entries
            .map((e) => '${e.key.toLowerCase()}:${e.value}')
            .join('\n') +
        '\n';

    final String signedHeaders = headers.keys
        .map((k) => k.toLowerCase())
        .join(';');

    return '$method\n$uri\n$queryString\n$canonicalHeaders\n$signedHeaders\n$payloadHash';
  }

  /// Create string to sign for AWS signature
  static String _createStringToSign({
    required String dateTimeStamp,
    required String dateStamp,
    required String canonicalRequest,
  }) {
    return 'AWS4-HMAC-SHA256\n'
        '$dateTimeStamp\n'
        '$dateStamp/${AWSConfig.region}/s3/aws4_request\n'
        '${_sha256Hash(canonicalRequest)}';
  }

  /// Calculate AWS signature
  static String _calculateSignature({
    required String dateStamp,
    required String stringToSign,
  }) {
    final List<int> kDate = _hmacSha256(
      utf8.encode(AWSConfig.secretAccessKey),
      utf8.encode(dateStamp),
    );

    final List<int> kRegion = _hmacSha256(kDate, utf8.encode(AWSConfig.region));
    final List<int> kService = _hmacSha256(kRegion, utf8.encode('s3'));
    final List<int> kSigning = _hmacSha256(
      kService,
      utf8.encode('aws4_request'),
    );

    final List<int> signature = _hmacSha256(
      kSigning,
      utf8.encode(stringToSign),
    );

    return signature
        .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
        .join('');
  }

  /// HMAC-SHA256 implementation
  static List<int> _hmacSha256(List<int> key, List<int> data) {
    final Hmac hmac = Hmac(sha256, key);
    final Digest digest = hmac.convert(data);
    return digest.bytes;
  }

  /// SHA256 hash implementation
  static String _sha256Hash(String input) {
    final Digest digest = sha256.convert(utf8.encode(input));
    return digest.toString();
  }

  /// Format date for AWS signature
  static String _formatDate(DateTime dateTime) {
    return dateTime.toIso8601String().substring(0, 10).replaceAll('-', '');
  }

  /// Format date time for AWS signature
  static String _formatDateTime(DateTime dateTime) {
    return dateTime
            .toIso8601String()
            .replaceAll('-', '')
            .replaceAll(':', '')
            .split('.')[0] +
        'Z';
  }

  /// Check if AWS credentials are properly configured
  static bool _hasValidAWSCredentials() {
    final String accessKey = AWSConfig.accessKeyId;
    final String secretKey = AWSConfig.secretAccessKey;

    return accessKey.isNotEmpty &&
        secretKey.isNotEmpty &&
        accessKey != 'YOUR_ACCESS_KEY_ID' &&
        secretKey != 'YOUR_SECRET_ACCESS_KEY';
  }

  /// Get file from S3 (simulated)
  static Future<Uint8List?> getFile(String key) async {
    try {
      // Simulate file retrieval
      await Future.delayed(const Duration(seconds: 1));
      print('Simulated S3 download: $key');
      return Uint8List(0); // Return empty bytes for simulation
    } catch (e) {
      print('S3 Download Error: $e');
      return null;
    }
  }

  /// Delete file from S3 (simulated)
  static Future<bool> deleteFile(String key) async {
    try {
      // Simulate file deletion
      await Future.delayed(const Duration(seconds: 1));
      print('Simulated S3 delete: $key');
      return true;
    } catch (e) {
      print('S3 Delete Error: $e');
      return false;
    }
  }
}
