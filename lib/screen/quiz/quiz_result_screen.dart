import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:confetti/confetti.dart';
import '../../models/quiz_models.dart';
import 'quiz_display_screen.dart';

class QuizResultScreen extends StatefulWidget {
  final Quiz quiz;
  final QuizResult result;

  const QuizResultScreen({
    super.key,
    required this.quiz,
    required this.result,
  });

  @override
  State<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    
    // Trigger confetti if score is good
    if (widget.result.percentage >= 70) {
      _confettiController.play();
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isGoodScore = widget.result.percentage >= 70;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF9DB),
      body: SafeArea(
        child: Stack(
          children: [
            // Main Content
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Header
                    Text(
                      'Quiz Completed!',
                      style: GoogleFonts.museoModerno(
                        color: const Color(0xFF4E342E),
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.quiz.title,
                      style: GoogleFonts.museoModerno(
                        color: Colors.brown[400],
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 32),

                    // Score Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Score Circle
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: 120,
                                height: 120,
                                child: CircularProgressIndicator(
                                  value: widget.result.percentage / 100,
                                  strokeWidth: 8,
                                  backgroundColor: Colors.grey[200],
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    _getScoreColor(widget.result.percentage),
                                  ),
                                ),
                              ),
                              Column(
                                children: [
                                  Text(
                                    '${widget.result.percentage.toInt()}%',
                                    style: GoogleFonts.museoModerno(
                                      color: const Color(0xFF4E342E),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 32,
                                    ),
                                  ),
                                  Text(
                                    '${widget.result.score}/${widget.result.totalQuestions}',
                                    style: GoogleFonts.museoModerno(
                                      color: Colors.brown[400],
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // Score Message
                          Text(
                            _getScoreMessage(widget.result.percentage),
                            style: GoogleFonts.museoModerno(
                              color: _getScoreColor(widget.result.percentage),
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 8),

                          Text(
                            _getScoreDescription(widget.result.percentage),
                            style: GoogleFonts.museoModerno(
                              color: Colors.brown[400],
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Stats Cards
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            'Time Taken',
                            '${widget.result.timeTaken.inMinutes}m ${widget.result.timeTaken.inSeconds % 60}s',
                            Icons.timer,
                            Colors.blue[400]!,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            'Correct',
                            '${widget.result.score}',
                            Icons.check_circle,
                            Colors.green[400]!,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            'Incorrect',
                            '${widget.result.totalQuestions - widget.result.score}',
                            Icons.cancel,
                            Colors.red[400]!,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Question Review
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Question Review',
                            style: GoogleFonts.museoModerno(
                              color: const Color(0xFF4E342E),
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ...widget.quiz.questions.asMap().entries.map((entry) {
                            final index = entry.key;
                            final question = entry.value;
                            final userAnswer = widget.result.userAnswers[index];
                            final isCorrect = userAnswer == question.correctAnswerIndex;
                            
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isCorrect 
                                    ? Colors.green[50] 
                                    : Colors.red[50],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isCorrect 
                                      ? Colors.green[200]! 
                                      : Colors.red[200]!,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    isCorrect ? Icons.check : Icons.close,
                                    color: isCorrect 
                                        ? Colors.green[600] 
                                        : Colors.red[600],
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'Q${index + 1}: ${question.questionText}',
                                      style: GoogleFonts.museoModerno(
                                        color: const Color(0xFF4E342E),
                                        fontSize: 14,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Action Buttons
                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _retakeQuiz,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFFE066),
                              foregroundColor: const Color(0xFF4E342E),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              'Retake Quiz',
                              style: GoogleFonts.museoModerno(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: OutlinedButton(
                            onPressed: _goHome,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF4E342E),
                              side: const BorderSide(
                                color: Color(0xFF4E342E),
                                width: 2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              'Back to Home',
                              style: GoogleFonts.museoModerno(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Confetti
            if (isGoodScore)
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirection: 1.57, // Down
                  blastDirectionality: BlastDirectionality.explosive,
                  shouldLoop: false,
                  colors: const [
                    Color(0xFFFFE066),
                    Color(0xFF4E342E),
                    Colors.blue,
                    Colors.green,
                    Colors.orange,
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.museoModerno(
              color: const Color(0xFF4E342E),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Text(
            title,
            style: GoogleFonts.museoModerno(
              color: Colors.brown[400],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Color _getScoreColor(double percentage) {
    if (percentage >= 90) return Colors.green[400]!;
    if (percentage >= 70) return Colors.orange[400]!;
    return Colors.red[400]!;
  }

  String _getScoreMessage(double percentage) {
    if (percentage >= 90) return 'Excellent!';
    if (percentage >= 70) return 'Good Job!';
    if (percentage >= 50) return 'Not Bad!';
    return 'Keep Trying!';
  }

  String _getScoreDescription(double percentage) {
    if (percentage >= 90) return 'Outstanding performance!';
    if (percentage >= 70) return 'Well done! You passed!';
    if (percentage >= 50) return 'You\'re getting there!';
    return 'Don\'t give up! Practice makes perfect.';
  }

  void _retakeQuiz() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => QuizDisplayScreen(quiz: widget.quiz),
      ),
    );
  }

  void _goHome() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/',
      (route) => false,
    );
  }
}
