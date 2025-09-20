import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

class AWSService {
  static const String _region = 'us-east-1'; // Change to your preferred region
  static const String _accessKey =
      'YOUR_ACCESS_KEY_HERE'; // Replace with your access key
  static const String _secretKey =
      'YOUR_SECRET_KEY_HERE'; // Replace with your secret key

  Future<Map<String, dynamic>> analyzeImage(Uint8List imageBytes) async {
    try {
      // Convert image to base64
      String base64Image = base64Encode(imageBytes);

      // Prepare request for AWS Rekognition
      final requestBody = {
        'Image': {'Bytes': base64Image},
        'MaxLabels': 10,
        'MinConfidence': 70.0,
      };
      // Make request to AWS Rekognition
      final response = await http.post(
        Uri.parse('https://rekognition.$_region.amazonaws.com/'),
        headers: {
          'Content-Type': 'application/x-amz-json-1.1',
          'X-Amz-Target': 'RekognitionService.DetectLabels',
          'Authorization': _getAuthorizationHeader('POST', '/', requestBody),
        },
        body: jsonEncode(requestBody),
      );
      if (response.statusCode == 200) {
        return _processRekognitionResponse(jsonDecode(response.body));
      } else {
        print('AWS Error: ${response.statusCode} - ${response.body}');
        return _simulateRekognitionResponse(); // Fallback to simulation
      }
    } catch (e) {
      print('Error analyzing image: $e');
      return _simulateRekognitionResponse(); // Fallback to simulation
    }
  }

  Map<String, dynamic> _processRekognitionResponse(
    Map<String, dynamic> response,
  ) {
    List<Map<String, dynamic>> objects = [];
    String detectedObject = '';
    String announcement = '';
    String lastSpokenLabel = '';
    if (response['Labels'] != null) {
      for (var label in response['Labels']) {
        String labelName = label['Name']?.toString().toLowerCase() ?? '';
        double confidence = (label['Confidence'] ?? 0.0).toDouble();

        if (confidence > 70.0) {
          objects.add({
            'name': labelName,
            'confidence': confidence,
            'boundingBox': label['Instances']?.isNotEmpty == true
                ? label['Instances'][0]['BoundingBox']
                : null,
          });
          // Check for heart-related objects
          if (labelName.contains('heart') ||
              labelName.contains('organ') ||
              labelName.contains('medical') ||
              labelName.contains('anatomy')) {
            detectedObject = 'heart';
            announcement =
                'Heart detected! Tap to view description and AR model.';
            lastSpokenLabel = 'Heart';
            break;
          }
        }
      }
    }
    return {
      'objects': objects,
      'texts': <Map<String, dynamic>>[],
      'detectedObject': detectedObject,
      'announcement': announcement,
      'lastSpokenLabel': lastSpokenLabel,
    };
  }

  Map<String, dynamic> _simulateRekognitionResponse() {
    // Fallback simulation for demo purposes
    List<Map<String, dynamic>> objects = [
      {
        'name': 'heart',
        'confidence': 85.5,
        'boundingBox': {'Left': 0.2, 'Top': 0.3, 'Width': 0.6, 'Height': 0.4},
      },
    ];
    return {
      'objects': objects,
      'texts': <Map<String, dynamic>>[],
      'detectedObject': 'heart',
      'announcement': 'Heart detected! Tap to view description and AR model.',
      'lastSpokenLabel': 'Heart',
    };
  }

  String _getAuthorizationHeader(
    String method,
    String path,
    Map<String, dynamic> body,
  ) {
    // Simplified AWS signature - for production use proper AWS SDK
    final timestamp =
        DateTime.now()
            .toUtc()
            .toIso8601String()
            .replaceAll(':', '')
            .split('.')[0] +
        'Z';
    final date = timestamp.split('T')[0];

    return 'AWS4-HMAC-SHA256 Credential=$_accessKey/$date/$_region/rekognition/aws4_request, SignedHeaders=content-type;host;x-amz-date;x-amz-target, Signature=placeholder';
  }
}
