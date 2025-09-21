import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:mime/mime.dart';
import 'package:flutter/foundation.dart';
import 'aws_s3_service_fixed.dart' as s3;
import 'aws_textract_service.dart';
import 'aws_bedrock_service.dart';
import 'aws_config.dart';

class AWSFlashnotesService {
  /// Process uploaded file and generate summaries
  static Future<FlashnotesResult?> processFile({
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

      // Step 1: Upload file to S3
      print('📤 Starting S3 upload for file: $fileName');
      print(
        '📊 File size: ${fileBytes?.length ?? file?.lengthSync() ?? 0} bytes',
      );
      print('📋 Content type: $contentType');

      final String? s3Key = await s3.AWSS3ServiceFixed.uploadFile(
        file: file,
        fileBytes: fileBytes,
        fileName: fileName,
        contentType: contentType,
      );

      if (s3Key == null) {
        print('❌ S3 upload failed - falling back to local processing');
        throw Exception('Failed to upload file to S3');
      } else {
        print('✅ S3 upload successful: $s3Key');
      }

      // Step 2: Extract text using Textract
      String? extractedText;

      // Try to extract text using AWS Textract from S3 first
      if (_hasValidAWSCredentials()) {
        print('Using AWS Textract for text extraction...');
        extractedText = await AWSTextractService.extractTextFromDocument(
          s3Key: s3Key,
          bucketName: AWSConfig.bucketName,
        );
      } else {
        print('AWS credentials not configured, using local text extraction...');
      }

      // Fallback to local text extraction if AWS Textract fails or credentials not configured
      if (extractedText == null || extractedText.isEmpty) {
        print('🔄 Using local text extraction fallback');
        final Uint8List bytes = fileBytes ?? await file!.readAsBytes();
        extractedText = await AWSTextractService.extractTextFromFile(
          fileBytes: bytes,
          fileName: fileName,
          contentType: contentType,
        );

        if (extractedText != null && extractedText.isNotEmpty) {
          print('✅ Local text extraction successful');
          print('📝 Extracted text length: ${extractedText.length} characters');
        } else {
          print('❌ Local text extraction also failed');
        }
      } else {
        print('✅ AWS Textract extraction successful');
        print('📝 Extracted text length: ${extractedText.length} characters');
      }

      if (extractedText == null || extractedText.isEmpty) {
        throw Exception('No text could be extracted from the file');
      }

      // Step 3: Generate summaries using Bedrock
      final String? simpleNotes = await AWSBedrockService.generateSimpleNotes(
        extractedText,
      );
      final List<Map<String, String>>? flashcards =
          await AWSBedrockService.generateFlashcards(extractedText);
      final Map<String, dynamic>? mindMap =
          await AWSBedrockService.generateMindMap(extractedText);

      return FlashnotesResult(
        s3Key: s3Key,
        extractedText: extractedText,
        simpleNotes: simpleNotes ?? 'Failed to generate simple notes',
        flashcards: flashcards ?? [],
        mindMap: mindMap,
        fileName: fileName,
        processedAt: DateTime.now(),
      );
    } catch (e) {
      print('AWS Flashnotes Processing Error: $e');
      return null;
    }
  }

  /// Pick file from device
  static Future<FilePickerResult?> pickFile({required bool isDocument}) async {
    try {
      final FileType fileType = isDocument ? FileType.custom : FileType.video;
      final List<String>? allowedExtensions = isDocument
          ? ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png', 'tiff', 'webp']
          : ['mp4', 'avi', 'mov', 'wmv'];

      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: fileType,
        allowedExtensions: allowedExtensions,
        allowMultiple: false,
      );

      return result;
    } catch (e) {
      print('File Picker Error: $e');
      return null;
    }
  }

  /// Get content type from file
  static String getContentType(String filePath) {
    final String? mimeType = lookupMimeType(filePath);
    return mimeType ?? 'application/octet-stream';
  }

  /// Validate file type
  static bool isValidFileType(String contentType, bool isDocument) {
    if (isDocument) {
      return AWSConfig.supportedDocumentTypes.contains(contentType) ||
          AWSConfig.supportedImageTypes.contains(contentType);
    } else {
      return AWSConfig.supportedVideoTypes.contains(contentType);
    }
  }

  /// Validate file size
  static bool isValidFileSize(int fileSize) {
    return fileSize <= AWSConfig.maxFileSize;
  }

  /// Clean up S3 resources
  static Future<void> cleanupS3Resource(String s3Key) async {
    try {
      // S3 cleanup is handled by the fixed service
      print('S3 cleanup for key: $s3Key');
    } catch (e) {
      print('S3 Cleanup Error: $e');
    }
  }

  /// Check if AWS credentials are properly configured
  static bool _hasValidAWSCredentials() {
    final String accessKey = AWSConfig.accessKeyId;
    final String secretKey = AWSConfig.secretAccessKey;

    // Debug logging
    print('🔍 AWS Credential Check:');
    print(
      '  Access Key: ${accessKey.substring(0, accessKey.length > 8 ? 8 : accessKey.length)}...',
    );
    print(
      '  Secret Key: ${secretKey.substring(0, secretKey.length > 8 ? 8 : secretKey.length)}...',
    );
    print('  Access Key Length: ${accessKey.length}');
    print('  Secret Key Length: ${secretKey.length}');

    final bool isValid =
        accessKey.isNotEmpty &&
        secretKey.isNotEmpty &&
        accessKey != 'YOUR_ACCESS_KEY_ID' &&
        secretKey != 'YOUR_SECRET_ACCESS_KEY';

    print('  Credentials Valid: $isValid');

    return isValid;
  }
}

/// Result class for processed flashnotes
class FlashnotesResult {
  final String s3Key;
  final String extractedText;
  final String simpleNotes;
  final List<Map<String, String>> flashcards;
  final Map<String, dynamic>? mindMap;
  final String fileName;
  final DateTime processedAt;

  FlashnotesResult({
    required this.s3Key,
    required this.extractedText,
    required this.simpleNotes,
    required this.flashcards,
    this.mindMap,
    required this.fileName,
    required this.processedAt,
  });

  /// Get flashcards as formatted string for saving
  String get flashcardsAsString {
    final StringBuffer buffer = StringBuffer();
    buffer.writeln("Flashcards - $fileName");
    buffer.writeln("=" * 50);
    buffer.writeln();

    for (int i = 0; i < flashcards.length; i++) {
      final card = flashcards[i];
      buffer.writeln("Card ${i + 1}:");
      buffer.writeln("Question: ${card['question']}");
      buffer.writeln("Answer: ${card['answer']}");
      buffer.writeln();
    }

    buffer.writeln("---");
    buffer.writeln("Generated from: $fileName");
    buffer.writeln("Created: ${processedAt.toString()}");

    return buffer.toString();
  }

  /// Get mind map as formatted string for saving
  String get mindMapAsString {
    if (mindMap == null) return 'Mind map not available';

    final StringBuffer buffer = StringBuffer();
    buffer.writeln("Mind Map - $fileName");
    buffer.writeln("=" * 50);
    buffer.writeln();

    buffer.writeln("Central Topic: ${mindMap!['centralTopic'] ?? 'Unknown'}");
    buffer.writeln();

    final List<dynamic> branches = mindMap!['branches'] ?? [];
    for (int i = 0; i < branches.length; i++) {
      final branch = branches[i] as Map<String, dynamic>;
      buffer.writeln("${i + 1}. ${branch['name'] ?? 'Unnamed Branch'}");

      final List<dynamic> subBranches = branch['subBranches'] ?? [];
      for (int j = 0; j < subBranches.length; j++) {
        final subBranch = subBranches[j] as Map<String, dynamic>;
        buffer.writeln(
          "   ${j + 1}. ${subBranch['name'] ?? 'Unnamed Sub-branch'}",
        );
        if (subBranch['details'] != null) {
          buffer.writeln("      ${subBranch['details']}");
        }
      }
      buffer.writeln();
    }

    buffer.writeln("---");
    buffer.writeln("Generated from: $fileName");
    buffer.writeln("Created: ${processedAt.toString()}");

    return buffer.toString();
  }
}
