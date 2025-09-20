import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
                            'Profile',
                            style: GoogleFonts.museoModerno(
                              color: const Color(0xFF4E342E),
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Manage your account and settings',
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

                // Settings Section
                Text(
                  'Settings',
                  style: GoogleFonts.museoModerno(
                    color: const Color(0xFF4E342E),
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 16),

                // Settings Options
                _buildSettingsOption(
                  icon: Icons.person_outline,
                  title: 'Edit Profile',
                  subtitle: 'Update your personal information',
                  onTap: () {
                    // TODO: Navigate to edit profile
                  },
                ),
                _buildSettingsOption(
                  icon: Icons.notifications_outlined,
                  title: 'Notifications',
                  subtitle: 'Manage your notification preferences',
                  onTap: () {
                    // TODO: Navigate to notifications settings
                  },
                ),
                _buildSettingsOption(
                  icon: Icons.security_outlined,
                  title: 'Privacy & Security',
                  subtitle: 'Control your privacy settings',
                  onTap: () {
                    // TODO: Navigate to privacy settings
                  },
                ),
                _buildSettingsOption(
                  icon: Icons.help_outline,
                  title: 'Help & Support',
                  subtitle: 'Get help and contact support',
                  onTap: () {
                    // TODO: Navigate to help screen
                  },
                ),
                _buildSettingsOption(
                  icon: Icons.info_outline,
                  title: 'About',
                  subtitle: 'App version and information',
                  onTap: () {
                    // TODO: Navigate to about screen
                  },
                ),
                const SizedBox(height: 24),

                // Logout Button
                Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red[200]!),
                  ),
                  child: TextButton(
                    onPressed: () {
                      // TODO: Implement logout
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Logout functionality coming soon!')),
                      );
                    },
                    child: Text(
                      'Logout',
                      style: GoogleFonts.museoModerno(
                        color: Colors.red[600],
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFFFE066).withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF4E342E),
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: GoogleFonts.museoModerno(
            color: const Color(0xFF4E342E),
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.museoModerno(
            color: Colors.brown[400],
            fontSize: 14,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Color(0xFF4E342E),
          size: 16,
        ),
        onTap: onTap,
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.yellow[600],
                  borderRadius: BorderRadius.circular(40),
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/profpic.png',
                    fit: BoxFit.cover,
                  ),
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
                        color: const Color(0xFF4E342E),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'School: SMKA Simpang 5',
                      style: GoogleFonts.museoModerno(
                        color: Colors.brown[600],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Age: 15',
                      style: GoogleFonts.museoModerno(
                        color: Colors.brown[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem('XP', '280', Icons.star),
              _buildStatItem('Level', '5', Icons.trending_up),
              _buildStatItem('Streak', '7 days', Icons.local_fire_department),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: const Color(0xFFFFE066),
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.museoModerno(
            color: const Color(0xFF4E342E),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.museoModerno(
            color: Colors.brown[400],
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
