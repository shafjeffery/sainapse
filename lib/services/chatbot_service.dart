import 'aws_chatbot_service.dart';

class ChatbotService {
  final AWSChatbotService _awsService = AWSChatbotService();
  bool _useAWS = false; // Toggle between AWS and local responses

  Future<String> getAIResponse(String userMessage) async {
    try {
      if (_useAWS) {
        // Use AWS Bedrock for production
        return await _awsService.getRealBedrockResponse(userMessage);
      } else {
        // Use simulated responses for hackathon
        return await _awsService.getAIResponse(userMessage);
      }
    } catch (e) {
      print('Error getting AI response: $e');
      return "I'm sorry, I'm having trouble understanding right now. Please try again.";
    }
  }

  // Toggle between AWS and local responses
  void toggleAWSMode(bool useAWS) {
    _useAWS = useAWS;
  }

  // Get current mode
  bool get isUsingAWS => _useAWS;
}
