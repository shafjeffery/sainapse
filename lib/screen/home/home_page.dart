import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sainapse/screen/feature selection/theme_selection_page.dart';
import '../flashnotes/flashnotes_home.dart';
import '../visualize/lookout_screen.dart';
import '../quiz/quiz_upload_screen.dart';
import '../profile/card_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9DB),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 35),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hi, Hafiz Fauzi',
                            style: GoogleFonts.museoModerno(
                              color: const Color(0xFF4E342E),
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Welcome to your Virtual Learning Space',
                            style: GoogleFonts.museoModerno(
                              color: Colors.brown[400],
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFE066),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Color(0xFF4E342E),
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '280 pts',
                            style: GoogleFonts.museoModerno(
                              color: const Color(0xFF4E342E),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Profile Card
                const ProfileCard(),
                const SizedBox(height: 24),

                // Quick Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    QuickActionButton(
                      imagePath: 'assets/camera.png',
                      label: 'Augmented Reality',
                      color:  const Color.fromARGB(255, 207, 135, 84),

                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LookoutScreen(),
                          ),
                        );
                      },
                    ),
                    QuickActionButton(
                      imagePath: 'assets/leaderboard.png',
                      label: 'Leaderboard',
                           color: Colors.green[200]!,

                      onTap: () {
                        Navigator.pushNamed(context, '/leaderboard');
                      },
                    ),
                    QuickActionButton(
                      imagePath: 'assets/rewards.png',
                      label: 'Rewards',
                      color: Colors.blue[200]!,

                      onTap: () {
                        Navigator.pushNamed(context, '/reward');
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Themes Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Interesting features',
                      style: GoogleFonts.museoModerno(
                        color: const Color(0xFF4E342E),
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ThemeSelectionPage(),
                          ),
                        );
                      },
                      child: Text(
                        'See All >',
                        style: GoogleFonts.museoModerno(
                          color: Colors.brown[400],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Theme Cards
                ThemeCard(
                  title: 'Go-To-Quiz',
                  description: 'Generate your own sets of quiz with your learning material',
                  image: 'assets/1.png',
                  onStart: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const QuizUploadScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                ThemeCard(
                  title: 'Flash Notes',
                  description: 'Summarize your complex notes into simple flash notes',
                  image: 'assets/2.png',
                  onStart: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FlashNotesPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.yellow[600],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Image.asset(
                  'assets/profpic.png',
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mohd Hafiz bin Fauzi',
                      style: GoogleFonts.museoModerno(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'School: SMKA Simpang 5',
                      style: GoogleFonts.museoModerno(color: Colors.brown,
                      fontWeight: FontWeight.bold,),
                    ),
                     const SizedBox(height: 4),
                    Text(
                      'Age: 15',
                      style: GoogleFonts.museoModerno(color: Colors.brown,
                      fontWeight: FontWeight.bold,),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GestureDetector(
           onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CardPage()),
            );
          },
            child: Container(
              width: 250,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFFFE066),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  "View Student Card",
                  style: GoogleFonts.museoModerno(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF4E342E),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class QuickActionButton extends StatelessWidget {
  final IconData? icon;
  final String? imagePath;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const QuickActionButton({
    super.key,
    this.icon,
    this.imagePath,
    required this.label,
    required this.onTap,
    required this.color,
  }) : assert(icon != null || imagePath != null, 'Either icon or imagePath must be provided');

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 105,
        height: 150,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (icon != null)
              Icon(icon, color: Colors.white, size: 40)
            else if (imagePath != null)
              Image.asset(
                imagePath!,
                width: 90,
                height: 90,
                
              ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.museoModerno(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ThemeCard extends StatelessWidget {
  final String title;
  final String description;
  final String image;
  final VoidCallback? onStart;

  const ThemeCard({
    super.key,
    required this.title,
    required this.description,
    required this.image,
    this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
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
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.museoModerno(
                      color: const Color(0xFF4E342E),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: GoogleFonts.museoModerno(
                      color: Colors.brown[400],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: onStart,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFE066),
                      foregroundColor: const Color(0xFF4E342E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Let\'s Start',
                      style: GoogleFonts.museoModerno(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                image: DecorationImage(
                  image: AssetImage(image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
