import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sainapse/screen/quiz/points_summary.dart';

class MarkQuiz extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final List<Map<String, dynamic>> questions;
  final List<int> userAnswers;

  MarkQuiz({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.questions,
    required this.userAnswers,
  });


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBE7),
      body: Center(
        child: Container(
          width: 340,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.18),
                blurRadius: 32,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 8),
              _BouncingGuy(),
              const SizedBox(height: 16),
              Text(
                'WELL DONE!',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFBFA14A),
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'YOU GOT IT RIGHT',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                '$score of $totalQuestions',
                style: GoogleFonts.poppins(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '+$score points',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFBFA14A),
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PointsSummaryPage(points: score),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB59B2B),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BouncingGuy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/man-jumping-up-and-down.gif',
      width: 300,
      height: 300,
      fit: BoxFit.contain,
    );
  }
}
