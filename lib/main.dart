import 'package:flutter/material.dart';

import 'home_page.dart';
import 'screen/chatbot/chatbot_screen.dart';
import 'screen/friends/friends_screen.dart';
import 'screen/visualize/lookout_screen.dart';

import 'shared/theme.dart';
import 'screen/flashnotes/flashnotes_home.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SAInapse',
      debugShowCheckedModeBanner: false,

      theme: ThemeData.light(),
      home: const LookoutScreen(),
    );
  }
}
