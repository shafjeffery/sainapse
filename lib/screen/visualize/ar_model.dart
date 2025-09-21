import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:google_fonts/google_fonts.dart';

class ArModel extends StatelessWidget {
  const ArModel({super.key});

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
                  '• Pumps oxygenated blood to all body tissues\n'
                  '• Removes carbon dioxide and waste products\n'
                  '• Maintains blood pressure and circulation',
                  style: GoogleFonts.museoModerno(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Close', style: GoogleFonts.museoModerno()),
              onPressed: () => Navigator.of(context).pop(),
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
          'AR Heart Model',
          style: GoogleFonts.museoModerno(
            color: const Color(0xFFFFF9DB),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 3D Model Viewer
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: ModelViewer(
                  src: 'assets/human_heart.glb',
                  alt: "A 3D model of the human heart",
                  ar: true,
                  autoRotate: true,
                  cameraControls: true,
                  backgroundColor: Colors.white,
                ),
              ),
            ),
          ),

          // Info Button
          Container(
            width: double.infinity,
            height: 60,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6B8E23),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () => _showHeartInfo(context),
              icon: const Icon(Icons.info_outline, color: Colors.white),
              label: Text(
                "View Heart Information",
                style: GoogleFonts.museoModerno(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
