import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'chat_screen.dart';

class FriendsScreen extends StatelessWidget {
  const FriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9DB), // Light yellow/cream background
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF9DB),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF2C2C2C)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Friends',
          style: GoogleFonts.museoModerno(
            color: const Color(0xFF2C2C2C),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _friends.length,
        itemBuilder: (context, index) {
          final friend = _friends[index];
          return _buildFriendCard(context, friend, index + 4);
        },
      ),
    );
  }

  Widget _buildFriendCard(BuildContext context, Friend friend, int rank) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: friend.isHighlighted
            ? const Color(0xFFE8E8E8) // Slightly darker for highlighted
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Rank number
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$rank',
                  style: GoogleFonts.museoModerno(
                    color: const Color(0xFF2C2C2C),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Avatar
            CircleAvatar(
              radius: 24,
              backgroundColor: friend.avatarColor,
              child: Text(
                friend.name.split(' ').map((e) => e[0]).join(),
                style: GoogleFonts.museoModerno(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        title: Text(
          friend.name,
          style: GoogleFonts.museoModerno(
            color: const Color(0xFF2C2C2C),
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          '${friend.points} points',
          style: GoogleFonts.museoModerno(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Color(0xFF2C2C2C),
          size: 16,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatScreen(friend: friend)),
          );
        },
      ),
    );
  }

  static final List<Friend> _friends = [
    Friend(
      name: 'Danisha Azra',
      points: 590,
      avatarColor: Colors.purple,
      isHighlighted: true,
    ),
    Friend(name: 'Nur Aisyah', points: 448, avatarColor: Colors.blue),
    Friend(name: 'Adiba Alya', points: 448, avatarColor: Colors.green),
    Friend(name: 'Amylia Natasya', points: 448, avatarColor: Colors.orange),
    Friend(name: 'Siti Athirah', points: 448, avatarColor: Colors.purple),
    Friend(name: 'Nurin Adni', points: 448, avatarColor: Colors.blue),
    Friend(name: 'Nur Akmal', points: 448, avatarColor: Colors.brown),
  ];
}

class Friend {
  final String name;
  final int points;
  final Color avatarColor;
  final bool isHighlighted;

  Friend({
    required this.name,
    required this.points,
    required this.avatarColor,
    this.isHighlighted = false,
  });
}
