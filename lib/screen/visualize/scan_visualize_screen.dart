import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'description_screen.dart';
import 'ar_model.dart';
import '../../services/ml_service.dart';

class ScanVisualizeScreen extends StatefulWidget {
  const ScanVisualizeScreen({super.key});

  @override
  State<ScanVisualizeScreen> createState() => _ScanVisualizeScreenState();
}

class _ScanVisualizeScreenState extends State<ScanVisualizeScreen>
    with TickerProviderStateMixin {
  bool _isScanning = false;
  bool _isProcessing = false;
  String _detectedObject = '';
  String _scanningStatus = 'Ready to scan';
  late AnimationController _scanAnimationController;
  late AnimationController _pulseAnimationController;
  late Animation<double> _scanAnimation;
  late Animation<double> _pulseAnimation;
  final MLService _mlService = MLService();

  @override
  void initState() {
    super.initState();
    _scanAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _scanAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _scanAnimationController,
        curve: Curves.easeInOut,
      ),
    );
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(
        parent: _pulseAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _scanAnimationController.dispose();
    _pulseAnimationController.dispose();
    super.dispose();
  }

  Future<void> _startScanning() async {
    setState(() {
      _isScanning = true;
      _isProcessing = true;
      _scanningStatus = 'Scanning heart image...';
    });

    _scanAnimationController.repeat();
    _pulseAnimationController.repeat(reverse: true);

    try {
      // Simulate scanning delay for better UX
      await Future.delayed(const Duration(seconds: 2));

      // Process the heart.jpg image from assets
      final result = await _mlService.processAssetImage('assets/heart.jpg');

      setState(() {
        _detectedObject = result['detectedObject'] ?? 'Heart';
        _scanningStatus = 'Analysis complete!';
        _isProcessing = false;
      });

      // Show success feedback
      HapticFeedback.lightImpact();

      // Stop animations
      _scanAnimationController.stop();
      _pulseAnimationController.stop();
    } catch (e) {
      setState(() {
        _scanningStatus = 'Scan failed. Please try again.';
        _isProcessing = false;
        _isScanning = false;
      });
      _scanAnimationController.stop();
      _pulseAnimationController.stop();
    }
  }

  void _stopScanning() {
    setState(() {
      _isScanning = false;
      _isProcessing = false;
      _scanningStatus = 'Ready to scan';
    });
    _scanAnimationController.stop();
    _pulseAnimationController.stop();
  }

  @override
  Widget build(BuildContext context) {
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
          'AI Heart Scanner',
          style: GoogleFonts.museoModerno(
            color: const Color(0xFFFFF9DB),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Status Card
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    colors: _isScanning
                        ? [const Color(0xFF4CAF50), const Color(0xFF45A049)]
                        : [const Color(0xFFFFF9DB), const Color(0xFFF5F5DC)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      _isScanning ? Icons.radar : Icons.favorite,
                      size: 40,
                      color: _isScanning ? Colors.white : Colors.red,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _scanningStatus,
                      style: GoogleFonts.museoModerno(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _isScanning ? Colors.white : Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (_isProcessing) ...[
                      const SizedBox(height: 15),
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Main Content Card
            Expanded(
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xFFFFF9DB),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Heart Image with Animation
                      AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _isScanning ? _pulseAnimation.value : 1.0,
                            child: Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.red.withOpacity(0.3),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.asset(
                                  'assets/heart.jpg',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: const Icon(
                                        Icons.favorite,
                                        size: 100,
                                        color: Colors.red,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 30),

                      // Detection Result
                      if (_detectedObject.isNotEmpty) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 15,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4CAF50),
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.withOpacity(0.3),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color: Colors.white,
                                size: 24,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Detected: $_detectedObject',
                                style: GoogleFonts.museoModerno(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],

                      // Action Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Description Button
                          ElevatedButton.icon(
                            onPressed: _detectedObject.isNotEmpty
                                ? () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const DescriptionScreen(),
                                      ),
                                    );
                                  }
                                : null,
                            icon: const Icon(Icons.info_outline),
                            label: const Text('Description'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6B8E23),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                          ),

                          // AR Button
                          ElevatedButton.icon(
                            onPressed: _detectedObject.isNotEmpty
                                ? () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const ArModel(),
                                      ),
                                    );
                                  }
                                : null,
                            icon: const Icon(Icons.view_in_ar),
                            label: const Text('AR View'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2196F3),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Scan Button
            Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _isScanning
                      ? [const Color(0xFFFF5722), const Color(0xFFE64A19)]
                      : [const Color(0xFF6B8E23), const Color(0xFF4CAF50)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: (_isScanning ? Colors.orange : Colors.green)
                        .withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _isProcessing
                    ? null
                    : (_isScanning ? _stopScanning : _startScanning),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isScanning) ...[
                      AnimatedBuilder(
                        animation: _scanAnimation,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: _scanAnimation.value * 2 * 3.14159,
                            child: const Icon(
                              Icons.radar,
                              color: Colors.white,
                              size: 24,
                            ),
                          );
                        },
                      ),
                    ] else ...[
                      Icon(
                        _isProcessing
                            ? Icons.hourglass_empty
                            : Icons.camera_alt,
                        color: Colors.white,
                        size: 24,
                      ),
                    ],
                    const SizedBox(width: 10),
                    Text(
                      _isProcessing
                          ? 'Processing...'
                          : (_isScanning ? 'Stop Scanning' : 'Start AI Scan'),
                      style: GoogleFonts.museoModerno(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
