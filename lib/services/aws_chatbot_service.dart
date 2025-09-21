import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

class AWSChatbotService {
  static const String _region = 'us-east-1';
  static const String _accessKey = 'YOUR_ACCESS_KEY_HERE';
  static const String _secretKey = 'YOUR_SECRET_KEY_HERE';
  
  // AWS Bedrock endpoint
  static const String _bedrockEndpoint = 'https://bedrock-runtime.us-east-1.amazonaws.com';
  
  Future<String> getAIResponse(String userMessage) async {
    try {
      // For hackathon, we'll simulate AWS Bedrock response
      // In production, you would make actual AWS Bedrock API calls
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
    } 
    else if (message.contains('cell') || message.contains('cellular')) {
      return "Cells are the basic structural and functional units of all living organisms. They contain organelles like the nucleus (genetic material), mitochondria (energy production), and ribosomes (protein synthesis). The human body has about 37 trillion cells!";
    }
    else if (message.contains('dna') || message.contains('genetic')) {
      return "DNA (Deoxyribonucleic Acid) is the genetic material that carries instructions for development, functioning, and reproduction. It's a double helix structure made of nucleotides. Human DNA contains about 3 billion base pairs!";
    }
    else if (message.contains('brain') || message.contains('neural')) {
      return "The brain is the control center of the nervous system. It contains about 86 billion neurons that communicate through electrical and chemical signals. The brain uses about 20% of the body's energy despite being only 2% of body weight.";
    }
    else if (message.contains('photosynthesis')) {
      return "Photosynthesis is the process by which plants convert sunlight, carbon dioxide, and water into glucose and oxygen. It occurs in chloroplasts and is essential for life on Earth. The chemical equation is: 6CO₂ + 6H₂O + light energy → C₆H₁₂O₆ + 6O₂";
    }
    else if (message.contains('evolution')) {
      return "Evolution is the process by which species change over time through natural selection. Charles Darwin proposed that organisms with favorable traits are more likely to survive and reproduce, leading to gradual species change over generations.";
    }
    else if (message.contains('ecosystem')) {
      return "An ecosystem is a community of living organisms interacting with their physical environment. It includes producers (plants), consumers (animals), and decomposers (bacteria, fungi). Biodiversity refers to the variety of life in an ecosystem.";
    }
    else if (message.contains('hello') || message.contains('hi')) {
      return "Hello! I'm your AI Biology and Science tutor powered by AWS Bedrock. I can help you learn about human anatomy, cellular biology, genetics, ecosystems, and much more. What scientific topic would you like to explore?";
    }
    else {
      return "That's an interesting question! I specialize in biology and science education. Could you tell me more about which specific biological process, organ system, or scientific concept you'd like to learn about?";
    }
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
                "text": "You are a biology and science tutor. Answer this question: $userMessage"
              }
            ]
          }
        ],
        "maxTokens": 1000,
        "temperature": 0.7,
        "topP": 0.9
      };

      final response = await http.post(
        Uri.parse('$_bedrockEndpoint/model/anthropic.claude-3-sonnet-20240229-v1:0/invoke'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': _getAuthorizationHeader('POST', '/model/anthropic.claude-3-sonnet-20240229-v1:0/invoke', requestBody),
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['content'][0]['text'] ?? 'Sorry, I could not generate a response.';
      } else {
        print('AWS Bedrock Error: ${response.statusCode} - ${response.body}');
        return _simulateBedrockResponse(userMessage); // Fallback
      }
    } catch (e) {
      print('Error calling AWS Bedrock: $e');
      return _simulateBedrockResponse(userMessage); // Fallback
    }
  }

  String _getAuthorizationHeader(String method, String path, Map<String, dynamic> body) {
    final timestamp = DateTime.now().toUtc().toIso8601String().replaceAll(':', '').split('.')[0] + 'Z';
    final date = timestamp.split('T')[0];
    
    // Simplified AWS signature for demo - use proper AWS SDK in production
    return 'AWS4-HMAC-SHA256 Credential=$_accessKey/$date/$_region/bedrock/aws4_request, SignedHeaders=content-type;host;x-amz-date, Signature=placeholder';
  }
}
