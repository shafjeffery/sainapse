import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme_selection_page.dart';

import 'auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'chatbot_screen.dart';
import 'package:hellopekan/config/user_profiles.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

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
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Profile')
                      .where('email', isEqualTo: user?.email)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Text('Loading...');
                    }

                    final userData =
                        snapshot.data!.docs.first.data()
                            as Map<String, dynamic>;
                    final username = userData['username'] as String? ?? 'User';
                    final points = userData['point'] as int? ?? 0;

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hi, $username',
                                style: GoogleFonts.museoModerno(
                                  color: const Color(0xFF4E342E),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Ready to Explore Pekan?',
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
                                '$points pts',
                                style: GoogleFonts.museoModerno(
                                  color: const Color(0xFF4E342E),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
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
                      color: const Color.fromARGB(255, 207, 135, 84),

                      onTap: () {
                        Navigator.pushNamed(context, '/lookout');
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
                      'Game Theme',
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
                  title: 'Royal Heritage',
                  description: 'Explore the rich history of Pekan',
                  image: 'assets/royalheritage.jpg',
                  onStart: () {
                    Navigator.pushNamed(context, '/itinerary-royale');
                  },
                ),
                const SizedBox(height: 16),
                ThemeCard(
                  title: 'Local Food Hunting',
                  description: 'Discover local delicacies',
                  image: 'assets/foodpahang.jpg',
                  onStart: () {
                    Navigator.pushNamed(context, '/itinerary-food');
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

  Future<void> _handleLogout(BuildContext context) async {
    final authService = AuthService();
    try {
      await authService.signOut();
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/signup');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error signing out: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Profile')
          .where('email', isEqualTo: user?.email)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text('Loading...');
        }

        final userData =
            snapshot.data!.docs.first.data() as Map<String, dynamic>;
        final username = userData['username'] as String? ?? 'User';

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
                      color: UserProfiles.getUserColor(user?.email ?? ''),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Image.asset(
                      UserProfiles.getUserProfilePicture(user?.email ?? ''),
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          username,
                          style: GoogleFonts.museoModerno(
                            color: const Color(0xFF4E342E),
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Quest 3 out of 6: Sultan Abdullah Mosque',
                          style: GoogleFonts.museoModerno(color: Colors.brown),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => _handleLogout(context),
                    icon: const Icon(Icons.logout, color: Color(0xFF4E342E)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: 0.5,
                  backgroundColor: Colors.grey[200],
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFFFFD93D),
                  ),
                  minHeight: 8,
                ),
              ),
            ],
          ),
        );
      },
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
  }) : assert(
         icon != null || imagePath != null,
         'Either icon or imagePath must be provided',
       );

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
              Image.asset(imagePath!, width: 90, height: 90),
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
