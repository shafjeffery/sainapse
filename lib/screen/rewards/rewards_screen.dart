import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  int currentPoints = 1250;

  final List<RewardItem> rewards = [
    RewardItem(
      title: 'Coffee Break',
      description: 'Get a free coffee at any partner café',
      cost: 100,
      icon: Icons.local_cafe,
      color: Colors.brown,
    ),
    RewardItem(
      title: 'Study Snacks',
      description: 'Free snacks package for your study session',
      cost: 200,
      icon: Icons.fastfood,
      color: Colors.orange,
    ),
    RewardItem(
      title: 'Premium Notes',
      description: 'Access to premium study materials',
      cost: 500,
      icon: Icons.school,
      color: Colors.blue,
    ),
    RewardItem(
      title: 'Gift Card',
      description: '\$10 gift card to your favorite store',
      cost: 1000,
      icon: Icons.card_giftcard,
      color: Colors.purple,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9DB),
      appBar: AppBar(
        title: Text(
          'Rewards',
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Points Display
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.amber[400]!, Colors.orange[400]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(Icons.stars, size: 48, color: Colors.white),
                    const SizedBox(height: 12),
                    Text(
                      'Your Points',
                      style: GoogleFonts.museoModerno(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$currentPoints',
                      style: GoogleFonts.museoModerno(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Rewards Section
              Text(
                'Available Rewards',
                style: GoogleFonts.museoModerno(
                  color: const Color(0xFF4E342E),
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 16),

              // Rewards List
              ...rewards.map((reward) => _buildRewardCard(reward)).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRewardCard(RewardItem reward) {
    final canAfford = currentPoints >= reward.cost;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: reward.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(reward.icon, color: reward.color, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reward.title,
                  style: GoogleFonts.museoModerno(
                    color: const Color(0xFF4E342E),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  reward.description,
                  style: GoogleFonts.museoModerno(
                    color: Colors.brown[400],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: canAfford ? Colors.green[100] : Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${reward.cost} pts',
                  style: GoogleFonts.museoModerno(
                    color: canAfford ? Colors.green[700] : Colors.grey[600],
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: canAfford ? () => _claimReward(reward) : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: canAfford ? reward.color : Colors.grey[300],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
                child: Text(
                  canAfford
                      ? 'Claim'
                      : 'Need ${reward.cost - currentPoints} more',
                  style: GoogleFonts.museoModerno(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _claimReward(RewardItem reward) {
    setState(() {
      currentPoints -= reward.cost;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Congratulations! You claimed ${reward.title}',
          style: GoogleFonts.museoModerno(color: Colors.white),
        ),
        backgroundColor: reward.color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

class RewardItem {
  final String title;
  final String description;
  final int cost;
  final IconData icon;
  final Color color;

  RewardItem({
    required this.title,
    required this.description,
    required this.cost,
    required this.icon,
    required this.color,
  });
}
