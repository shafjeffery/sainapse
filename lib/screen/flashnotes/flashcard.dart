import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FlashcardsResultPage extends StatefulWidget {
  final String fileName;

  const FlashcardsResultPage({super.key, required this.fileName});

  @override
  State<FlashcardsResultPage> createState() => _FlashcardsResultPageState();
}

class _FlashcardsResultPageState extends State<FlashcardsResultPage> {
  int currentIndex = 0;

  // Dummy flashcards
  final List<Map<String, String>> flashcards = [
    {
      "question": "What is Python?",
      "answer":
          "Python is a high-level programming language created by Guido van Rossum in 1991.",
    },
    {
      "question": "What is Python used for?",
      "answer":
          "Python is used for web development, data analysis, machine learning, automation, and more.",
    },
    {
      "question": "Is Python easy to learn?",
      "answer":
          "Yes! Python is known for its simple syntax, making it beginner-friendly.",
    },
  ];

  bool showAnswer = false;

  void _nextCard() {
    setState(() {
      if (currentIndex < flashcards.length - 1) {
        currentIndex++;
        showAnswer = false;
      }
    });
  }

  void _prevCard() {
    setState(() {
      if (currentIndex > 0) {
        currentIndex--;
        showAnswer = false;
      }
    });
  }

  void _toggleAnswer() {
    setState(() {
      showAnswer = !showAnswer;
    });
  }

  @override
  Widget build(BuildContext context) {
    final flashcard = flashcards[currentIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFFFF9DB),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF4E342E)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Flash Notes",
          style: GoogleFonts.museoModerno(
            color: const Color(0xFF4E342E),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              "Flashcards",
              style: GoogleFonts.museoModerno(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: const Color(0xFF4E342E),
              ),
            ),
            const SizedBox(height: 20),

            // Flashcard UI
            Expanded(
              child: GestureDetector(
                onTap: _toggleAnswer,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      showAnswer
                          ? flashcard["answer"]!
                          : flashcard["question"]!,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Navigation + Heart
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Color(0xFF4E342E),
                  ),
                  onPressed: _prevCard,
                ),
                IconButton(
                  icon: Icon(
                    Icons.favorite,
                    color: showAnswer ? Colors.red : Colors.grey,
                    size: 32,
                  ),
                  onPressed: _toggleAnswer,
                ),
                IconButton(
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                    color: Color(0xFF4E342E),
                  ),
                  onPressed: _nextCard,
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Flashcards saved successfully!",
                        style: GoogleFonts.museoModerno(),
                      ),
                      backgroundColor: const Color(0xFF4E342E),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4E342E),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  "Save Into Folder",
                  style: GoogleFonts.museoModerno(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
