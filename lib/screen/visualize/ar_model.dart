import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:google_fonts/google_fonts.dart';

class ArModel extends StatefulWidget {
  const ArModel({super.key});

  @override
  State<ArModel> createState() => _ArModelState();
}

class _ArModelState extends State<ArModel> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Set loading to false after a short delay to show the model
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  void _showHeartInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Heart Information',
            style: GoogleFonts.museoModerno(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Anatomy:',
                  style: GoogleFonts.museoModerno(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'The heart is a four-chambered muscular organ that pumps blood throughout the body.',
                  style: GoogleFonts.museoModerno(),
                ),
                const SizedBox(height: 16),
                Text(
                  'Function:',
                  style: GoogleFonts.museoModerno(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  '• Pumps oxygenated blood to all body tissues\n• Removes carbon dioxide and waste products\n• Maintains blood pressure and circulation',
                  style: GoogleFonts.museoModerno(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close', style: GoogleFonts.museoModerno()),
            ),
          ],
        );
      },
    );
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
          'AR Vision',
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
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          'Heart',
                          style: GoogleFonts.museoModerno(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Expanded(
                        child: _isLoading
                            ? const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Color(0xFF6B8E23),
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    Text(
                                      'Loading 3D Heart Model...',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.grey[100],
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: const Color(0xFFFFF9DB),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Heart icon as placeholder
                                      Container(
                                        width: 120,
                                        height: 120,
                                        decoration: BoxDecoration(
                                          color: Colors.red.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                            60,
                                          ),
                                          border: Border.all(
                                            color: Colors.red,
                                            width: 3,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.favorite,
                                          size: 80,
                                          color: Colors.red,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Text(
                                        '3D Heart Model',
                                        style: GoogleFonts.museoModerno(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        'AR functionality requires\nHTTPS connection',
                                        style: GoogleFonts.museoModerno(
                                          fontSize: 14,
                                          color: Colors.black54,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 20),
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          // Show heart information instead
                                          _showHeartInfo(context);
                                        },
                                        icon: const Icon(Icons.info_outline),
                                        label: const Text('View Heart Info'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(
                                            0xFF6B8E23,
                                          ),
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 10,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              25,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFF6B8E23),
                borderRadius: BorderRadius.circular(30),
              ),
              child: ElevatedButton(
                onPressed: () => _showHeartInfo(context),
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
                    const Icon(
                      Icons.info_outline,
                      color: Colors.white,
                      size: 24,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'View Heart Information',
                      style: GoogleFonts.museoModerno(
                        fontSize: 16,
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
