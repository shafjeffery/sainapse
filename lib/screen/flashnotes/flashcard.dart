import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/file_service.dart';
import '../../services/aws_flashnotes_service.dart';

class FlashcardsResultPage extends StatefulWidget {
  final String fileName;
  final FlashnotesResult? flashnotesResult;

  const FlashcardsResultPage({
    super.key,
    required this.fileName,
    this.flashnotesResult,
  });

  @override
  State<FlashcardsResultPage> createState() => _FlashcardsResultPageState();
}

class _FlashcardsResultPageState extends State<FlashcardsResultPage> {
  int currentIndex = 0;
  bool isSaving = false;

  // Get flashcards from AWS result or use dummy data
  List<Map<String, String>> get flashcards {
    if (widget.flashnotesResult != null &&
        widget.flashnotesResult!.flashcards.isNotEmpty) {
      return widget.flashnotesResult!.flashcards;
    }

    // Fallback to dummy flashcards
    return [
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
  }

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

  Future<void> _saveFlashcards() async {
    setState(() {
      isSaving = true;
    });

    try {
      // Get the flashcards content
      final String flashcardsContent = _getFlashcardsContent();

      // Save to file
      final bool success = await FileService.saveNotesToFile(
        fileName: widget.fileName,
        content: flashcardsContent,
        noteType: 'Flash Card',
      );

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Flashcards saved successfully to SAInapse_Notes/Flash Card folder!",
                style: GoogleFonts.museoModerno(),
              ),
              backgroundColor: const Color(0xFF4E342E),
              duration: const Duration(seconds: 3),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Failed to save flashcards. Please try again.",
                style: GoogleFonts.museoModerno(),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Error saving flashcards: $e",
              style: GoogleFonts.museoModerno(),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  String _getFlashcardsContent() {
    if (widget.flashnotesResult != null) {
      return widget.flashnotesResult!.flashcardsAsString;
    }

    final StringBuffer content = StringBuffer();
    content.writeln("Flashcards - ${widget.fileName}");
    content.writeln("=" * 50);
    content.writeln();

    for (int i = 0; i < flashcards.length; i++) {
      final card = flashcards[i];
      content.writeln("Card ${i + 1}:");
      content.writeln("Question: ${card['question']}");
      content.writeln("Answer: ${card['answer']}");
      content.writeln();
    }

    content.writeln("---");
    content.writeln("Generated from: ${widget.fileName}");
    content.writeln("Created: ${DateTime.now().toString()}");

    return content.toString();
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
                onPressed: isSaving ? null : _saveFlashcards,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4E342E),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: isSaving
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Saving...",
                            style: GoogleFonts.museoModerno(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    : Text(
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
