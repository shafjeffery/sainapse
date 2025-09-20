import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../flashnotes/flashnotes_home.dart';
import '../visualize/lookout_screen.dart';
import '../chatbot/chatbot_screen.dart';
import '../friends/friends_screen.dart';
import '../quiz/upload_file_quiz_page.dart';

class ThemeSelectionPage extends StatelessWidget {
  const ThemeSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themes = [
      {
        'title': 'Go-To-Quiz',
        'description': 'Generate your own sets of quiz with your learning material',
        'image': 'assets/1.png',
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const UploadFileQuizPage(),
          ),
        ),
      },
      {
        'title': 'Flash Notes',
        'description': 'Summarize your complex notes into simple flash notes',
        'image': 'assets/2.png',
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const FlashNotesPage(),
          ),
        ),
      },
      {
        'title': 'Scan and Visualize',
        'description': 'Bring your notes to life with AR visualization',
        'image': 'assets/3.png',
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LookoutScreen(),
          ),
        ),
      },
      {
        'title': 'Buddy Chat',
        'description': 'Chat with your study buddy',
        'image': 'assets/4.png',
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const FriendsScreen(),
          ),
        ),
      },
      {
        'title': 'SAI chatbot',
        'description': 'Get instant answers to your questions with SAI chatbot',
        'image': 'assets/5.png',
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ChatbotScreen(),
          ),
        ),
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFFF9DB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF4E342E)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Interesting Features',
          style: GoogleFonts.museoModerno(
            color: const Color(0xFF4E342E),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 35),
        child: ListView.builder(
          itemCount: themes.length,
          itemBuilder: (context, index) {
            final theme = themes[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 24),
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
                            theme['title'] as String,
                            style: GoogleFonts.museoModerno(
                              color: const Color(0xFF4E342E),
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            theme['description'] as String,
                            style: GoogleFonts.museoModerno(
                              color: Colors.brown[400],
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: theme['onTap'] as VoidCallback,
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
                          image: AssetImage(theme['image'] as String),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
