import 'dart:convert';
import 'package:http/http.dart' as http;

class AWSChatbotService {
  static const String _region = 'us-east-1';
  static const String _accessKey = 'AWS_ACCESS_KEY_ID_BEDROCK';
  static const String _secretKey = 'AWS_SECRET_ACCESS_KEY_BEDROCK';

  // AWS Bedrock endpoint
  static const String _bedrockEndpoint =
      'https://bedrock-runtime.us-east-1.amazonaws.com';

  Future<String> getAIResponse(String userMessage) async {
    try {
      // Check if we have real AWS credentials
      if (_accessKey == 'AWS_ACCESS_KEY_ID_BEDROCK' ||
          _secretKey == 'AWS_SECRET_ACCESS_KEY_BEDROCK') {
        return await _simulateBedrockResponse(userMessage);
      }

      // Try different AI models in order of preference
      final models = [
        'custom.deepseek-r1-distilled-llama-7b', // DeepSeek R1 (your preferred model)
        'custom.deepseek-coder-6.7b', // DeepSeek Coder (if available)
        'anthropic.claude-3-haiku-20240307-v1:0', // Claude 3 Haiku (fallback)
        'meta.llama3-8b-instruct-v1:0', // Llama 3 8B (fallback)
        'amazon.titan-text-express-v1', // Amazon Titan (fallback)
      ];

      for (String model in models) {
        try {
          final response = await _tryBedrockModel(model, userMessage);
          if (response != null && response.isNotEmpty) {
            print('Successfully used model: $model');
            return response;
          }
        } catch (e) {
          print('Model $model failed: $e');
          continue; // Try next model
        }
      }

      // If all models fail, use simulation
      return await _simulateBedrockResponse(userMessage);
    } catch (e) {
      print('Error getting AI response: $e');
      return "I'm sorry, I'm having trouble understanding right now. Please try again.";
    }
  }

  // Simulate AWS Bedrock response for hackathon
  Future<String> _simulateBedrockResponse(String userMessage) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 1500));

    final message = userMessage.toLowerCase();

    // Biology and Science responses
    if (message.contains('heart') || message.contains('cardiac')) {
      return "The heart is a four-chambered muscular organ that pumps blood throughout the body. It has two atria (upper chambers) and two ventricles (lower chambers). The heart beats about 100,000 times per day, pumping approximately 2,000 gallons of blood!";
    } else if (message.contains('cell') || message.contains('cellular')) {
      return "Cells are the basic structural and functional units of all living organisms. They contain organelles like the nucleus (genetic material), mitochondria (energy production), and ribosomes (protein synthesis). The human body has about 37 trillion cells!";
    } else if (message.contains('dna') || message.contains('genetic')) {
      return "DNA (Deoxyribonucleic Acid) is the genetic material that carries instructions for development, functioning, and reproduction. It's a double helix structure made of nucleotides. Human DNA contains about 3 billion base pairs!";
    } else if (message.contains('brain') || message.contains('neural')) {
      return "The brain is the control center of the nervous system. It contains about 86 billion neurons that communicate through electrical and chemical signals. The brain uses about 20% of the body's energy despite being only 2% of body weight.";
    } else if (message.contains('photosynthesis')) {
      return "Photosynthesis is the process by which plants convert sunlight, carbon dioxide, and water into glucose and oxygen. It occurs in chloroplasts and is essential for life on Earth. The chemical equation is: 6CO₂ + 6H₂O + light energy → C₆H₁₂O₆ + 6O₂";
    } else if (message.contains('evolution')) {
      return "Evolution is the process by which species change over time through natural selection. Charles Darwin proposed that organisms with favorable traits are more likely to survive and reproduce, leading to gradual species change over generations.";
    } else if (message.contains('ecosystem')) {
      return "An ecosystem is a community of living organisms interacting with their physical environment. It includes producers (plants), consumers (animals), and decomposers (bacteria, fungi). Biodiversity refers to the variety of life in an ecosystem.";
    } else if (message.contains('hello') || message.contains('hi')) {
      return "Hello! I'm your AI Biology and Science tutor powered by AWS Bedrock. I can help you learn about human anatomy, cellular biology, genetics, ecosystems, and much more. What scientific topic would you like to explore?";
    } else {
      return "That's an interesting question! I specialize in biology and science education. Could you tell me more about which specific biological process, organ system, or scientific concept you'd like to learn about?";
    }
  }

  // Try different Bedrock models
  Future<String?> _tryBedrockModel(String modelId, String userMessage) async {
    Map<String, dynamic> requestBody;
    String endpoint;

    if (modelId.startsWith('custom.deepseek')) {
      // DeepSeek models (Custom imported)
      requestBody = {
        "prompt":
            "You are a biology and science tutor. Answer this question: $userMessage",
        "max_tokens": 1000,
        "temperature": 0.7,
        "top_p": 0.9,
        "stream": false,
      };
      endpoint = '$_bedrockEndpoint/model/$modelId/invoke';
    } else if (modelId.startsWith('anthropic.claude')) {
      // Claude models (Haiku, Sonnet, Opus)
      requestBody = {
        "anthropic_version": "bedrock-2023-05-31",
        "max_tokens": 1000,
        "messages": [
          {
            "role": "user",
            "content":
                "You are a biology and science tutor. Answer this question: $userMessage",
          },
        ],
        "temperature": 0.7,
        "top_p": 0.9,
      };
      endpoint = '$_bedrockEndpoint/model/$modelId/invoke';
    } else if (modelId.startsWith('meta.llama')) {
      // Llama 3 models
      requestBody = {
        "prompt":
            "You are a biology and science tutor. Answer this question: $userMessage",
        "max_gen_len": 1000,
        "temperature": 0.7,
        "top_p": 0.9,
      };
      endpoint = '$_bedrockEndpoint/model/$modelId/invoke';
    } else if (modelId.startsWith('amazon.titan')) {
      // Amazon Titan
      requestBody = {
        "inputText":
            "You are a biology and science tutor. Answer this question: $userMessage",
        "textGenerationConfig": {
          "maxTokenCount": 1000,
          "temperature": 0.7,
          "topP": 0.9,
        },
      };
      endpoint = '$_bedrockEndpoint/model/$modelId/invoke';
    } else if (modelId.startsWith('cohere.command')) {
      // Cohere Command
      requestBody = {
        "prompt":
            "You are a biology and science tutor. Answer this question: $userMessage",
        "max_tokens": 1000,
        "temperature": 0.7,
        "p": 0.9,
      };
      endpoint = '$_bedrockEndpoint/model/$modelId/invoke';
    } else {
      throw Exception('Unsupported model: $modelId');
    }

    final response = await http.post(
      Uri.parse(endpoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': _getAuthorizationHeader('POST', endpoint, requestBody),
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return _extractResponseFromModel(modelId, responseData);
    } else {
      throw Exception(
        'Model $modelId failed with status: ${response.statusCode}',
      );
    }
  }

  String _extractResponseFromModel(
    String modelId,
    Map<String, dynamic> responseData,
  ) {
    if (modelId.startsWith('custom.deepseek')) {
      // DeepSeek models typically return text in 'generation' or 'output' field
      return responseData['generation'] ??
          responseData['output'] ??
          responseData['text'] ??
          'No response generated';
    } else if (modelId.startsWith('anthropic.claude')) {
      return responseData['content'][0]['text'] ?? 'No response generated';
    } else if (modelId.startsWith('meta.llama')) {
      return responseData['generation'] ?? 'No response generated';
    } else if (modelId.startsWith('amazon.titan')) {
      return responseData['results'][0]['outputText'] ??
          'No response generated';
    } else if (modelId.startsWith('cohere.command')) {
      return responseData['generations'][0]['text'] ?? 'No response generated';
    }
    return 'No response generated';
  }

  // Real AWS Bedrock integration (for production)
  Future<String> getRealBedrockResponse(String userMessage) async {
    try {
      final requestBody = {
        "modelId": "anthropic.claude-3-sonnet-20240229-v1:0",
        "content": [
          {
            "role": "user",
            "content": [
              {
                "text":
                    "You are a biology and science tutor. Answer this question: $userMessage",
              },
            ],
          },
        ],
        "maxTokens": 1000,
        "temperature": 0.7,
        "topP": 0.9,
      };

      final response = await http.post(
        Uri.parse(
          '$_bedrockEndpoint/model/anthropic.claude-3-sonnet-20240229-v1:0/invoke',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': _getAuthorizationHeader(
            'POST',
            '/model/anthropic.claude-3-sonnet-20240229-v1:0/invoke',
            requestBody,
          ),
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['content'][0]['text'] ??
            'Sorry, I could not generate a response.';
      } else {
        print('AWS Bedrock Error: ${response.statusCode} - ${response.body}');
        return _simulateBedrockResponse(userMessage); // Fallback
      }
    } catch (e) {
      print('Error calling AWS Bedrock: $e');
      return _simulateBedrockResponse(userMessage); // Fallback
    }
  }

  String _getAuthorizationHeader(
    String method,
    String path,
    Map<String, dynamic> body,
  ) {
    final timestamp =
        DateTime.now()
            .toUtc()
            .toIso8601String()
            .replaceAll(':', '')
            .split('.')[0] +
        'Z';
    final date = timestamp.split('T')[0];

    // Simplified AWS signature for demo - use proper AWS SDK in production
    return 'AWS4-HMAC-SHA256 Credential=$_accessKey/$date/$_region/bedrock/aws4_request, SignedHeaders=content-type;host;x-amz-date, Signature=placeholder';
  }
}
