import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'screen/main_navigation.dart';
import 'screen/leaderboard/leaderboard.dart';
import 'screen/rewards/rewards_screen.dart';
import 'shared/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SAInapse',
      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme,
      home: const MainNavigation(),
      routes: {
        '/leaderboard': (context) => const LeaderboardScreen(),
        '/reward': (context) => const RewardsScreen(),
      },
    );
  }
}
