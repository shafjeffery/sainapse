import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../services/camera_service.dart';
import '../../services/ml_service.dart';
import '../../widgets/bounding_box_painter.dart';
import 'scan_visualize_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class LookoutScreen extends StatefulWidget {
  const LookoutScreen({super.key});

  @override
  State<LookoutScreen> createState() => _LookoutScreenState();
}

class _LookoutScreenState extends State<LookoutScreen> {
  CameraController? _cameraController;
  final FlutterTts _flutterTts = FlutterTts();
  final MLService _mlService = MLService();
  final CameraService _cameraService = CameraService();

  bool _isBusy = false;
  List<Map<String, dynamic>> _objects = [];
  List<Map<String, dynamic>> _texts = [];
  String _lastSpokenLabel = '';
  String _detectedObject = '';

  @override
  void initState() {
    super.initState();
    _initCameraAndML();
    _initTts();
  }

  Future<void> _initTts() async {
    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
  }

  Future<void> _initCameraAndML() async {
    try {
      // Request camera permission
      final cameraStatus = await Permission.camera.request();
      if (cameraStatus != PermissionStatus.granted) {
        print('Camera permission denied');
        return;
      }

      // Request microphone permission
      final micStatus = await Permission.microphone.request();
      if (micStatus != PermissionStatus.granted) {
        print('Microphone permission denied');
      }

      final controller = await _cameraService.initializeCamera();
      if (!mounted) return;

      setState(() {
        _cameraController = controller;
      });
      _cameraController?.startImageStream(_processImage);
    } catch (e) {
      print('Error initializing camera: $e');
      // Show error to user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to initialize camera: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _processImage(CameraImage image) async {
    if (_isBusy || _cameraController == null) return;
    _isBusy = true;

    final result = await _mlService.processCameraImage(
      image: image,
      camera: _cameraController!.description,
      deviceOrientation: _cameraController!.value.deviceOrientation.index,
    );

    _objects = (result['objects'] as List<Map<String, dynamic>>?) ?? [];
    _texts = (result['texts'] as List<Map<String, dynamic>>?) ?? [];
    final newLabel = result['lastSpokenLabel'] as String? ?? '';
    final announcement = result['announcement'] as String? ?? '';
    final detectedObject = result['detectedObject'] as String? ?? '';

    if (announcement.isNotEmpty && newLabel != _lastSpokenLabel) {
      _lastSpokenLabel = newLabel;
      await _flutterTts.speak(announcement);
    }

    if (detectedObject == 'heart' && _detectedObject != 'heart') {
      _detectedObject = detectedObject;
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ScanVisualizeScreen()),
        );
      }
    }

    if (mounted) {
      setState(() {});
    }
    _isBusy = false;
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _mlService.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return Scaffold(
        backgroundColor: const Color(0xFF8B4513),
        body: const Center(
          child: CircularProgressIndicator(color: Color(0xFFFFF9DB)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF8B4513),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8B4513),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFFFF9DB)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Live Camera Scan',
          style: GoogleFonts.museoModerno(
            color: const Color(0xFFFFF9DB),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          CameraPreview(_cameraController!),
          CustomPaint(
            painter: BoundingBoxPainter(
              objects: _objects,
              texts: _texts,
              imageSize: _cameraController!.value.previewSize!,
            ),
          ),
          if (_lastSpokenLabel.isNotEmpty)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Detected: $_lastSpokenLabel',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          // AI Scan Button
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ScanVisualizeScreen(),
                  ),
                );
              },
              backgroundColor: const Color(0xFF6B8E23),
              icon: const Icon(Icons.radar, color: Colors.white),
              label: Text(
                'AI Scan',
                style: GoogleFonts.museoModerno(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              tooltip: 'Start AI Scan',
            ),
          ),
        ],
      ),
    );
  }
}
