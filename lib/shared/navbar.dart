import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class GameNavigationBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const GameNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<GameNavigationBar> createState() => _GameNavigationBarState();
}

class _GameNavigationBarState extends State<GameNavigationBar> {
  final List<IconData> _icons = [
    Icons.home_rounded,
    Icons.search_rounded,
    Icons.map_rounded,
    Icons.public_rounded,
    Icons.person_2_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      index: widget.currentIndex,
      height: 70,
      backgroundColor: Colors.transparent,
      color: const Color.fromARGB(255, 48, 38, 0), // App's main background color
      buttonBackgroundColor: const Color(0xFFF7D046), // Brighter yellow for selected
      items: _icons.map((icon) => Icon(
        icon,
        size: 28,
        color: Colors.white,
      )).toList(),
      onTap: widget.onTap,
      animationDuration: const Duration(milliseconds: 300),
      animationCurve: Curves.easeInOut,
    );
  }
}
