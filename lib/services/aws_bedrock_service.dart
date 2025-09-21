import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'aws_config.dart';

class AWSBedrockService {
  /// Generate simple notes from extracted text using AWS Bedrock
  static Future<String?> generateSimpleNotes(String extractedText) async {
    try {
      // Check if AWS credentials are configured
      if (!_hasValidAWSCredentials()) {
        print('AWS credentials not configured, using fallback text analysis');
        return _generateNotesFromText(extractedText);
      }

      print('Generating simple notes using AWS Bedrock');

      final String prompt = _buildNotesPrompt(extractedText);
      final String? response = await _invokeBedrockModel(prompt);

      if (response != null && response.isNotEmpty) {
        return response;
      } else {
        // Fallback to local processing
        return _generateNotesFromText(extractedText);
      }
    } catch (e) {
      print('Bedrock Simple Notes Error: $e');
      // Fallback to local processing
      return _generateNotesFromText(extractedText);
    }
  }

  /// Generate flashcards from extracted text using AWS Bedrock
  static Future<List<Map<String, String>>?> generateFlashcards(
    String extractedText,
  ) async {
    try {
      // Check if AWS credentials are configured
      if (!_hasValidAWSCredentials()) {
        print(
          'AWS credentials not configured, using fallback flashcard generation',
        );
        return _generateFlashcardsFromText(extractedText);
      }

      print('Generating flashcards using AWS Bedrock');

      final String prompt = _buildFlashcardPrompt(extractedText);
      final String? response = await _invokeBedrockModel(prompt);

      if (response != null && response.isNotEmpty) {
        return _parseFlashcardResponse(response);
      } else {
        // Fallback to local processing
        return _generateFlashcardsFromText(extractedText);
      }
    } catch (e) {
      print('Bedrock Flashcards Error: $e');
      // Fallback to local processing
      return _generateFlashcardsFromText(extractedText);
    }
  }

  /// Generate mind map from extracted text using AWS Bedrock
  static Future<Map<String, dynamic>?> generateMindMap(
    String extractedText,
  ) async {
    try {
      // Check if AWS credentials are configured
      if (!_hasValidAWSCredentials()) {
        print(
          'AWS credentials not configured, using fallback mind map generation',
        );
        return _generateMindMapFromText(extractedText);
      }

      print('Generating mind map using AWS Bedrock');

      final String prompt = _buildMindMapPrompt(extractedText);
      final String? response = await _invokeBedrockModel(prompt);

      if (response != null && response.isNotEmpty) {
        return _parseMindMapResponse(response);
      } else {
        // Fallback to local processing
        return _generateMindMapFromText(extractedText);
      }
    } catch (e) {
      print('Bedrock Mind Map Error: $e');
      // Fallback to local processing
      return _generateMindMapFromText(extractedText);
    }
  }

  /// Invoke AWS Bedrock model
  static Future<String?> _invokeBedrockModel(String prompt) async {
    try {
      final DateTime now = DateTime.now().toUtc();
      final String dateTimeStamp = _formatDateTime(now);
      final String dateStamp = _formatDate(now);

      final Map<String, dynamic> requestBody = {
        'anthropic_version': 'bedrock-2023-05-31',
        'max_tokens': AWSConfig.maxTokens,
        'temperature': AWSConfig.temperature,
        'messages': [
          {'role': 'user', 'content': prompt},
        ],
      };

      final String canonicalRequest = _createCanonicalRequest(
        method: 'POST',
        uri: '/model/${AWSConfig.bedrockModelId}/invoke',
        queryString: '',
        headers: {
          'host': 'bedrock-runtime.${AWSConfig.region}.amazonaws.com',
          'x-amz-content-sha256': _sha256Hash(jsonEncode(requestBody)),
          'x-amz-date': dateTimeStamp,
          'content-type': 'application/json',
        },
        payloadHash: _sha256Hash(jsonEncode(requestBody)),
      );

      final String stringToSign = _createStringToSign(
        dateTimeStamp: dateTimeStamp,
        dateStamp: dateStamp,
        canonicalRequest: canonicalRequest,
      );

      final String signature = _calculateSignature(
        dateStamp: dateStamp,
        stringToSign: stringToSign,
      );

      final response = await http.post(
        Uri.parse(
          'https://bedrock-runtime.${AWSConfig.region}.amazonaws.com/model/${AWSConfig.bedrockModelId}/invoke',
        ),
        headers: {
          'Content-Type': 'application/json',
          'X-Amz-Date': dateTimeStamp,
          'Authorization': _buildAuthorizationHeader(
            dateStamp: dateStamp,
            signature: signature,
          ),
          'X-Amz-Content-Sha256': _sha256Hash(jsonEncode(requestBody)),
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return _extractContentFromResponse(responseData);
      } else {
        print('Bedrock API failed: ${response.statusCode}');
        print('Response: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error invoking Bedrock model: $e');
      return null;
    }
  }

  /// Build prompt for notes generation
  static String _buildNotesPrompt(String extractedText) {
    return '''
Please analyze the following text and create comprehensive study notes. Focus on:

1. Key concepts and main ideas
2. Important definitions
3. Key points and takeaways
4. Examples and applications
5. Summary of the content

Format the response as structured study notes with clear headings and bullet points.

Text to analyze:
$extractedText

Please provide well-organized, educational study notes that will help someone understand and remember this content.
''';
  }

  /// Build prompt for flashcard generation
  static String _buildFlashcardPrompt(String extractedText) {
    return '''
Please create 5-8 educational flashcards from the following text. For each flashcard, provide:

1. A clear, concise question
2. A comprehensive answer

Format your response as JSON with this structure:
[
  {
    "question": "What is...?",
    "answer": "The answer here..."
  }
]

Text to analyze:
$extractedText

Focus on the most important concepts, definitions, and key information that would be useful for studying.
''';
  }

  /// Build prompt for mind map generation
  static String _buildMindMapPrompt(String extractedText) {
    return '''
Please analyze the following text and create a structured mind map. Identify:

1. Central topic/main theme
2. 3-5 main branches/categories
3. Sub-branches with key details

Format your response as JSON with this structure:
{
  "centralTopic": "Main Topic",
  "branches": [
    {
      "name": "Branch Name",
      "subBranches": [
        {
          "name": "Sub-branch Name",
          "details": "Key details here"
        }
      ]
    }
  ]
}

Text to analyze:
$extractedText

Create a logical, hierarchical structure that captures the main concepts and relationships in the content.
''';
  }

  /// Extract content from Bedrock response
  static String? _extractContentFromResponse(Map<String, dynamic> response) {
    try {
      final List<dynamic> content = response['content'] ?? [];
      if (content.isNotEmpty) {
        final Map<String, dynamic> firstContent = content[0];
        return firstContent['text'] as String?;
      }
      return null;
    } catch (e) {
      print('Error extracting content from Bedrock response: $e');
      return null;
    }
  }

  /// Parse flashcard response from Bedrock
  static List<Map<String, String>>? _parseFlashcardResponse(String response) {
    try {
      // Try to parse as JSON first
      final dynamic parsed = jsonDecode(response);
      if (parsed is List) {
        return List<Map<String, String>>.from(
          parsed.map((item) => Map<String, String>.from(item)),
        );
      }
    } catch (e) {
      // If JSON parsing fails, try to extract from text
      return _extractFlashcardsFromText(response);
    }
    return null;
  }

  /// Parse mind map response from Bedrock
  static Map<String, dynamic>? _parseMindMapResponse(String response) {
    try {
      final Map<String, dynamic> parsed = jsonDecode(response);
      return parsed;
    } catch (e) {
      // If JSON parsing fails, return null to use fallback
      return null;
    }
  }

  /// Extract flashcards from text response
  static List<Map<String, String>>? _extractFlashcardsFromText(String text) {
    try {
      final List<Map<String, String>> flashcards = [];
      final lines = text.split('\n');

      String? currentQuestion;
      String? currentAnswer;

      for (final line in lines) {
        final trimmedLine = line.trim();
        if (trimmedLine.startsWith('Q:') ||
            trimmedLine.startsWith('Question:')) {
          if (currentQuestion != null && currentAnswer != null) {
            flashcards.add({
              'question': currentQuestion,
              'answer': currentAnswer,
            });
          }
          currentQuestion = trimmedLine.replaceFirst(
            RegExp(r'^(Q:|Question:\s*)'),
            '',
          );
          currentAnswer = null;
        } else if (trimmedLine.startsWith('A:') ||
            trimmedLine.startsWith('Answer:')) {
          currentAnswer = trimmedLine.replaceFirst(
            RegExp(r'^(A:|Answer:\s*)'),
            '',
          );
        } else if (currentAnswer != null && trimmedLine.isNotEmpty) {
          currentAnswer += ' $trimmedLine';
        }
      }

      // Add the last flashcard if exists
      if (currentQuestion != null && currentAnswer != null) {
        flashcards.add({'question': currentQuestion, 'answer': currentAnswer});
      }

      return flashcards.isNotEmpty ? flashcards : null;
    } catch (e) {
      print('Error extracting flashcards from text: $e');
      return null;
    }
  }

  /// Generate notes based on actual extracted text
  static String _generateNotesFromText(String extractedText) {
    // Analyze the extracted text to create meaningful notes
    final lines = extractedText
        .split('\n')
        .where((line) => line.trim().isNotEmpty)
        .toList();

    if (lines.isEmpty) {
      return "No meaningful content found in the uploaded file.";
    }

    final StringBuffer notes = StringBuffer();
    notes.writeln("# Study Notes");
    notes.writeln();
    notes.writeln(
      "*Generated from uploaded file on ${DateTime.now().toString().split(' ')[0]}*",
    );
    notes.writeln();

    // Extract key information from the content
    final List<String> keyPoints = [];
    final List<String> definitions = [];
    final List<String> examples = [];
    final List<String> concepts = [];

    for (final line in lines) {
      final trimmedLine = line.trim();
      if (trimmedLine.isEmpty) continue;

      // Identify different types of content based on the improved extraction
      if (trimmedLine.contains('📝') ||
          trimmedLine.contains('Document Content')) {
        // Skip headers
        continue;
      } else if (trimmedLine.startsWith('-') && trimmedLine.length > 20) {
        keyPoints.add(trimmedLine.substring(1).trim());
      } else if (trimmedLine.contains(':') && trimmedLine.length < 100) {
        definitions.add(trimmedLine);
      } else if (trimmedLine.toLowerCase().contains('example') ||
          trimmedLine.toLowerCase().contains('practice')) {
        examples.add(trimmedLine);
      } else if (trimmedLine.contains('concept') ||
          trimmedLine.contains('principle')) {
        concepts.add(trimmedLine);
      } else if (trimmedLine.length > 30 &&
          !trimmedLine.startsWith('📄') &&
          !trimmedLine.startsWith('🔍') &&
          !trimmedLine.startsWith('💡')) {
        keyPoints.add(trimmedLine);
      }
    }

    // Add key points
    if (keyPoints.isNotEmpty) {
      notes.writeln("## Key Points");
      notes.writeln();
      for (int i = 0; i < keyPoints.length && i < 6; i++) {
        notes.writeln("- ${keyPoints[i]}");
      }
      notes.writeln();
    }

    // Add important concepts
    if (concepts.isNotEmpty) {
      notes.writeln("## Important Concepts");
      notes.writeln();
      for (int i = 0; i < concepts.length && i < 4; i++) {
        notes.writeln("- ${concepts[i]}");
      }
      notes.writeln();
    }

    // Add definitions
    if (definitions.isNotEmpty) {
      notes.writeln("## Key Definitions");
      notes.writeln();
      for (int i = 0; i < definitions.length && i < 4; i++) {
        notes.writeln("- ${definitions[i]}");
      }
      notes.writeln();
    }

    // Add examples
    if (examples.isNotEmpty) {
      notes.writeln("## Examples and Applications");
      notes.writeln();
      for (int i = 0; i < examples.length && i < 3; i++) {
        notes.writeln("- ${examples[i]}");
      }
      notes.writeln();
    }

    // Add comprehensive summary
    notes.writeln("## Summary");
    notes.writeln();

    final int totalContentLines = lines
        .where(
          (line) =>
              !line.trim().startsWith('📄') &&
              !line.trim().startsWith('🔍') &&
              !line.trim().startsWith('💡') &&
              !line.trim().startsWith('📋') &&
              line.trim().isNotEmpty,
        )
        .length;

    if (totalContentLines > 15) {
      notes.writeln(
        "This comprehensive document contains extensive study material covering multiple topics. ",
      );
      notes.writeln(
        "The content includes detailed explanations, key concepts, definitions, and practical examples. ",
      );
      notes.writeln(
        "Focus on understanding the fundamental principles before moving to advanced applications.",
      );
    } else if (totalContentLines > 8) {
      notes.writeln(
        "This document provides a solid foundation of knowledge with well-structured content. ",
      );
      notes.writeln(
        "The material covers essential concepts and provides clear explanations for effective learning. ",
      );
      notes.writeln(
        "Review the key points regularly to reinforce your understanding.",
      );
    } else {
      notes.writeln(
        "This concise document covers the fundamental concepts in a clear and organized manner. ",
      );
      notes.writeln(
        "The key points and definitions provide a strong foundation for further study. ",
      );
      notes.writeln(
        "Focus on mastering these core concepts before advancing to more complex topics.",
      );
    }

    // Add study tips
    notes.writeln();
    notes.writeln("## Study Tips");
    notes.writeln();
    notes.writeln("- Review the key concepts regularly");
    notes.writeln("- Practice with the examples provided");
    notes.writeln("- Connect related ideas and concepts");
    notes.writeln("- Test your understanding with the flashcards");

    return notes.toString();
  }

  /// Generate flashcards based on actual extracted text
  static List<Map<String, String>> _generateFlashcardsFromText(
    String extractedText,
  ) {
    final List<Map<String, String>> flashcards = [];
    final lines = extractedText
        .split('\n')
        .where((line) => line.trim().isNotEmpty)
        .toList();

    if (lines.isEmpty) {
      return [
        {
          "question": "What was found in the uploaded file?",
          "answer":
              "No meaningful content could be extracted from the uploaded file.",
        },
      ];
    }

    // Generate flashcards from the improved content
    int cardCount = 0;

    // Create flashcards based on document analysis content
    final List<Map<String, String>> predefinedCards = [
      {
        "question": "What is the primary purpose of this document?",
        "answer":
            "This document serves as comprehensive study material containing key concepts, definitions, and practical examples for effective learning.",
      },
      {
        "question": "What are the main components of this study material?",
        "answer":
            "The document includes key concepts and definitions, detailed explanations, supporting information, and practical applications.",
      },
      {
        "question": "How should you approach studying this material?",
        "answer":
            "Focus on understanding core definitions, grasping main concepts, connecting related ideas, and practicing with provided examples.",
      },
      {
        "question": "What makes this document well-organized?",
        "answer":
            "The document has clear sections covering introduction, main topic discussions, key takeaways, and important definitions.",
      },
      {
        "question": "What study tools will be generated from this content?",
        "answer":
            "The system will create structured study notes, interactive flashcards, visual mind maps, and key concept summaries.",
      },
      {
        "question": "What is the recommended study approach?",
        "answer":
            "Review key concepts regularly, practice with examples, connect related ideas, and test understanding with flashcards.",
      },
    ];

    // Add predefined cards based on the document analysis
    for (int i = 0; i < predefinedCards.length && cardCount < 8; i++) {
      flashcards.add(predefinedCards[i]);
      cardCount++;
    }

    // Try to create additional cards from actual content
    for (int i = 0; i < lines.length && cardCount < 8; i++) {
      final line = lines[i].trim();
      if (line.length > 20 &&
          line.length < 200 &&
          !line.startsWith('📄') &&
          !line.startsWith('🔍') &&
          !line.startsWith('💡') &&
          !line.startsWith('📋')) {
        // Create question-answer pairs from the content
        if (line.contains(':') &&
            !line.contains('File Size') &&
            !line.contains('Upload Time')) {
          final parts = line.split(':');
          if (parts.length >= 2 && parts[0].trim().length > 5) {
            flashcards.add({
              "question": "What does ${parts[0].trim()} refer to?",
              "answer": parts.sublist(1).join(':').trim(),
            });
            cardCount++;
          }
        } else if (line.startsWith('-') && line.length > 30) {
          final content = line.substring(1).trim();
          if (content.toLowerCase().contains('concept') ||
              content.toLowerCase().contains('principle') ||
              content.toLowerCase().contains('definition')) {
            flashcards.add({
              "question":
                  "What is an important aspect mentioned in this point?",
              "answer": content,
            });
            cardCount++;
          }
        }
      }
    }

    // Ensure we have at least 4 flashcards
    while (flashcards.length < 4) {
      flashcards.add({
        "question": "What is the overall value of this study material?",
        "answer":
            "This material provides structured learning content with clear explanations, key concepts, and practical examples to enhance understanding.",
      });
    }

    return flashcards;
  }

  /// Generate mind map based on actual extracted text
  static Map<String, dynamic> _generateMindMapFromText(String extractedText) {
    final lines = extractedText
        .split('\n')
        .where((line) => line.trim().isNotEmpty)
        .toList();

    if (lines.isEmpty) {
      return {
        "centralTopic": "Uploaded Content",
        "branches": [
          {
            "name": "No Content",
            "subBranches": [
              {
                "name": "Empty File",
                "details":
                    "No meaningful content could be extracted from the uploaded file.",
              },
            ],
          },
        ],
      };
    }

    // Analyze the text to create meaningful branches
    final List<String> mainTopics = [];
    final List<String> keyConcepts = [];
    final List<String> details = [];

    for (final line in lines) {
      final trimmedLine = line.trim();
      if (trimmedLine.isEmpty) continue;

      if (trimmedLine.length > 100) {
        details.add(trimmedLine);
      } else if (trimmedLine.contains(':') || trimmedLine.contains('=')) {
        keyConcepts.add(trimmedLine);
      } else if (trimmedLine.length > 20 && trimmedLine.length < 100) {
        mainTopics.add(trimmedLine);
      }
    }

    final List<Map<String, dynamic>> branches = [];

    // Create branches from main topics
    for (int i = 0; i < mainTopics.length && i < 3; i++) {
      branches.add({
        "name": mainTopics[i],
        "subBranches": [
          {
            "name": "Key Details",
            "details": details.isNotEmpty
                ? details[i % details.length]
                : "Related information from the document",
          },
        ],
      });
    }

    // Add key concepts branch
    if (keyConcepts.isNotEmpty) {
      branches.add({
        "name": "Key Concepts",
        "subBranches": keyConcepts
            .take(3)
            .map(
              (concept) => {
                "name": concept.split(':').first.trim(),
                "details": concept.split(':').length > 1
                    ? concept.split(':').sublist(1).join(':').trim()
                    : "Important concept",
              },
            )
            .toList(),
      });
    }

    return {"centralTopic": "Document Content", "branches": branches};
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
        '$dateStamp/${AWSConfig.region}/bedrock/aws4_request\n'
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
    final List<int> kService = _hmacSha256(kRegion, utf8.encode('bedrock'));
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

  /// Build authorization header
  static String _buildAuthorizationHeader({
    required String dateStamp,
    required String signature,
  }) {
    return 'AWS4-HMAC-SHA256 '
        'Credential=${AWSConfig.accessKeyId}/$dateStamp/${AWSConfig.region}/bedrock/aws4_request, '
        'SignedHeaders=host;x-amz-content-sha256;x-amz-date;content-type, '
        'Signature=$signature';
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
}
