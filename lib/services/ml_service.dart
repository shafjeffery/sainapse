import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  Future<Map<String, dynamic>> processAssetImage(String assetPath) async {
    try {
      final imageBytes = await _loadAssetImage(assetPath);
      final result = await _awsService.analyzeImage(imageBytes);
      return result;
    } catch (e) {
      print('Error processing asset image: $e');
      return {
        'objects': <Map<String, dynamic>>[],
        'texts': <Map<String, dynamic>>[],
        'detectedObject': '',
        'announcement': '',
        'lastSpokenLabel': '',
      };
    }
  }

  Future<Uint8List> _loadAssetImage(String assetPath) async {
    final ByteData data = await rootBundle.load(assetPath);
    return data.buffer.asUint8List();
  }

  Uint8List _convertCameraImageToBytes(CameraImage image) {
    return image.planes[0].bytes;
  }

  void dispose() {
    // AWS service cleanup if needed
  }
}
