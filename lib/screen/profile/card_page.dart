import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CardPage extends StatefulWidget {
  const CardPage({super.key});

  @override
  _CardPageState createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  int currentStep = 0; // 0: Profile, 1: Details, 2: QR Code

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9DB),
      appBar: AppBar(
        title: Text(
          "Student Card",
          style: GoogleFonts.museoModerno(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF4E342E),
          ),
        ),
        backgroundColor: const Color(0xFFFFE066),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4E342E)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildProgressDot(0),
                  const SizedBox(width: 20),
                  _buildProgressDot(1),
                  const SizedBox(width: 20),
                  _buildProgressDot(2),
                ],
              ),
            ),
            
            // Main content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: _buildCurrentStep(),
              ),
            ),
            
            // Navigation buttons
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (currentStep > 0)
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          currentStep--;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: const Color(0xFF4E342E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Previous',
                        style: GoogleFonts.museoModerno(fontWeight: FontWeight.bold),
                      ),
                    )
                  else
                    const SizedBox(width: 100),
                  
                  if (currentStep < 2)
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          currentStep++;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFE066),
                        foregroundColor: const Color(0xFF4E342E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Next',
                        style: GoogleFonts.museoModerno(fontWeight: FontWeight.bold),
                      ),
                    )
                  else
                    const SizedBox(width: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressDot(int step) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: currentStep >= step ? const Color(0xFFFFE066) : Colors.grey[300],
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (currentStep) {
      case 0:
        return _buildProfileStep();
      case 1:
        return _buildDetailsStep();
      case 2:
        return _buildQRStep();
      default:
        return _buildProfileStep();
    }
  }

  Widget _buildProfileStep() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue[200]!, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // XP Display
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star, color: Color.fromARGB(255, 255, 232, 21), size:30),
                const SizedBox(width: 8),
                Text(
                  '280XP',
                  style: GoogleFonts.museoModerno(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.yellow[700],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Connect message
            Text(
              "Let's Connect With Me!",
              style: GoogleFonts.museoModerno(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue[700],
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 30),
            
            // Profile picture
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.blue[300]!, width: 4),
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/profpic.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Name
            Text(
              'Hafiz Fauzi',
              style: GoogleFonts.museoModerno(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsStep() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Profile',
              style: GoogleFonts.museoModerno(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF4E342E),
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Profile picture
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey[300]!, width: 3),
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/profpic.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Details container
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                children: [
                  _buildDetailField('Name', 'Mohd Hafiz bin Fauzi'),
                  const SizedBox(height: 15),
                  _buildDetailField('Card No', 'SMK2024001'),
                  const SizedBox(height: 15),
                  _buildDetailField('School', 'SMKA Simpang 5'),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Implement QR generation
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('QR Code generated!')),
                    );
                  },
                  icon: const Icon(Icons.qr_code),
                  label: Text('QR', style: GoogleFonts.museoModerno()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFE066),
                    foregroundColor: const Color(0xFF4E342E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Implement QR scanning
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('QR Scanner opened!')),
                    );
                  },
                  icon: const Icon(Icons.qr_code_scanner),
                  label: Text('Scan QR', style: GoogleFonts.museoModerno()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[200],
                    foregroundColor: const Color(0xFF4E342E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailField(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!, width: 1),
        ),
      ),
      child: Row(
        children: [
          Text(
            '$label:',
            style: GoogleFonts.museoModerno(
              fontWeight: FontWeight.bold,
              color: const Color(0xFF4E342E),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.museoModerno(
                color: Colors.brown[600],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQRStep() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Scan Me to Connect',
              style: GoogleFonts.museoModerno(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF4E342E),
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 30),
            
            // QR Code placeholder
            Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/qr.png',
                    width: 200,
                    height: 200,
                  ),
                 
                  const SizedBox(height: 5),
                  Text(
                    'Hafiz Fauzi',
                    style: GoogleFonts.museoModerno(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Share button
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('QR Code shared!')),
                );
              },
              icon: const Icon(Icons.share),
              label: Text('Share QR Code', style: GoogleFonts.museoModerno()),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFE066),
                foregroundColor: const Color(0xFF4E342E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
