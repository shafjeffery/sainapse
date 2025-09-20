import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'aws_scan_service.dart';

class MLService {
  final AWSService _awsService = AWSService();

  Future<Map<String, dynamic>> processCameraImage({
    required CameraImage image,
    required CameraDescription camera,
    required int deviceOrientation,
  }) async {
    try {
      final imageBytes = _convertCameraImageToBytes(image);
      final result = await _awsService.analyzeImage(imageBytes);
      return result;
    } catch (e) {
      print('Error processing image: $e');
      return {
        'objects': <Map<String, dynamic>>[],
        'texts': <Map<String, dynamic>>[],
        'detectedObject': '',
        'announcement': '',
        'lastSpokenLabel': '',
      };
    }
  }

  Uint8List _convertCameraImageToBytes(CameraImage image) {
    return image.planes[0].bytes;
  }

  void dispose() {
    // AWS service cleanup if needed
  }
}
