import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screen/visualize/lookout_screen.dart';
import 'screen/visualize/ar_model.dart';
import 'screen/visualize/scan_visualize_screen.dart';
import 'screen/chatbot/chatbot_screen.dart';
import 'screen/friends/friends_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8B4513), // Dark brown background
      appBar: AppBar(
        backgroundColor: const Color(0xFF8B4513),
        elevation: 0,
        title: Text(
          'SAInapse',
          style: GoogleFonts.museoModerno(
            color: const Color(0xFFFFF9DB), // Light yellow text
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Welcome Text
            Text(
              'Scan and Visualize',
              style: GoogleFonts.museoModerno(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFFFF9DB),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Discover objects with AI-powered vision',
              style: GoogleFonts.museoModerno(
                fontSize: 18,
                color: const Color(0xFFFFF9DB).withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50),

            // Feature Cards
            _buildFeatureCard(
              context,
              'Live Camera Scan',
              'Scan objects with your camera and get instant information',
              Icons.camera_alt,
              const Color(0xFFFFF9DB), // Light yellow card
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LookoutScreen()),
              ),
            ),
            const SizedBox(height: 20),
            _buildFeatureCard(
              context,
              'Scan and Visualize',
              'Interactive scanning interface with AR capabilities',
              Icons.scanner,
              const Color(0xFFFFF9DB), // Light yellow card
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ScanVisualizeScreen(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildFeatureCard(
              context,
              'AI Chatbot',
              'Ask questions and get instant answers about exhibits',
              Icons.chat,
              const Color(0xFFFFF9DB), // Light yellow card
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChatbotScreen()),
              ),
            ),
            const SizedBox(height: 20),
            _buildFeatureCard(
              context,
              'Friends',
              'Connect and chat with your study friends',
              Icons.people,
              const Color(0xFFFFF9DB), // Light yellow card
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FriendsScreen()),
              ),
            ),
            const SizedBox(height: 20),
            _buildFeatureCard(
              context,
              'AR Model View',
              'View 3D models in augmented reality',
              Icons.view_in_ar,
              const Color(0xFFFFF9DB), // Light yellow card
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ArModel()),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 80,
        decoration: const BoxDecoration(
          color: Color(0xFF8B4513), // Dark brown
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home, 'Home', true),
            _buildNavItem(Icons.explore, 'Discover', false),
            _buildNavItem(Icons.people, 'Friends', false),
            _buildNavItem(Icons.chat, 'Chat', false),
            _buildNavItem(Icons.person, 'Profile', false),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color cardColor,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: cardColor,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color(
                    0xFF6B8E23,
                  ).withOpacity(0.2), // Olive green accent
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 30,
                  color: const Color(0xFF6B8E23), // Olive green
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.museoModerno(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      description,
                      style: GoogleFonts.museoModerno(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Color(0xFF6B8E23),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: isSelected
              ? const Color(0xFFFFF9DB)
              : const Color(0xFFFFF9DB).withOpacity(0.5),
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.museoModerno(
            color: isSelected
                ? const Color(0xFFFFF9DB)
                : const Color(0xFFFFF9DB).withOpacity(0.5),
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
