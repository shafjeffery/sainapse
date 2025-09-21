import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/quiz_models.dart';
import 'quiz_result_screen.dart';

class QuizDisplayScreen extends StatefulWidget {
  final Quiz quiz;

  const QuizDisplayScreen({super.key, required this.quiz});

  @override
  State<QuizDisplayScreen> createState() => _QuizDisplayScreenState();
}

class _QuizDisplayScreenState extends State<QuizDisplayScreen> {
  int _currentQuestionIndex = 0;
  List<int?> _userAnswers = [];
  DateTime? _startTime;
  Duration _timeRemaining = const Duration(minutes: 30);

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    _userAnswers = List.filled(widget.quiz.questions.length, null);
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = widget.quiz.questions[_currentQuestionIndex];
    final progress = (_currentQuestionIndex + 1) / widget.quiz.questions.length;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF9DB),
      appBar: AppBar(
        title: Text(
          widget.quiz.title,
          style: GoogleFonts.museoModerno(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF4E342E),
            fontSize: 16,
          ),
        ),
        backgroundColor: const Color(0xFFFFE066),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4E342E)),
          onPressed: () => _showExitDialog(),
        ),
        actions: [
          // Timer
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _timeRemaining.inMinutes < 5
                  ? Colors.red[100]
                  : Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.timer,
                  size: 16,
                  color: _timeRemaining.inMinutes < 5
                      ? Colors.red[600]
                      : const Color(0xFF4E342E),
                ),
                const SizedBox(width: 4),
                Text(
                  '${_timeRemaining.inMinutes}:${(_timeRemaining.inSeconds % 60).toString().padLeft(2, '0')}',
                  style: GoogleFonts.museoModerno(
                    color: _timeRemaining.inMinutes < 5
                        ? Colors.red[600]
                        : const Color(0xFF4E342E),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress Bar
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Question ${_currentQuestionIndex + 1} of ${widget.quiz.questions.length}',
                        style: GoogleFonts.museoModerno(
                          color: const Color(0xFF4E342E),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${(progress * 100).toInt()}%',
                        style: GoogleFonts.museoModerno(
                          color: Colors.brown[600],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[200],
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFFFFE066),
                    ),
                  ),
                ],
              ),
            ),

            // Question Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // Question Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Difficulty Badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _getDifficultyColor(
                                currentQuestion.difficulty,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              currentQuestion.difficulty.toUpperCase(),
                              style: GoogleFonts.museoModerno(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Question Text
                          Text(
                            currentQuestion.questionText,
                            style: GoogleFonts.museoModerno(
                              color: const Color(0xFF4E342E),
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Options
                    Expanded(
                      child: ListView.builder(
                        itemCount: currentQuestion.options.length,
                        itemBuilder: (context, index) {
                          final isSelected =
                              _userAnswers[_currentQuestionIndex] == index;
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: InkWell(
                              onTap: () => _selectAnswer(index),
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFFFFE066)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected
                                        ? const Color(0xFF4E342E)
                                        : Colors.grey[300]!,
                                    width: isSelected ? 2 : 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: isSelected
                                            ? const Color(0xFF4E342E)
                                            : Colors.grey[300],
                                      ),
                                      child: Center(
                                        child: Text(
                                          String.fromCharCode(
                                            65 + index,
                                          ), // A, B, C, D
                                          style: GoogleFonts.museoModerno(
                                            color: isSelected
                                                ? Colors.white
                                                : Colors.grey[600],
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Text(
                                        currentQuestion.options[index],
                                        style: GoogleFonts.museoModerno(
                                          color: isSelected
                                              ? const Color(0xFF4E342E)
                                              : Colors.brown[600],
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.normal,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Navigation Buttons
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  // Previous Button
                  if (_currentQuestionIndex > 0)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _previousQuestion,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[200],
                          foregroundColor: const Color(0xFF4E342E),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          'Previous',
                          style: GoogleFonts.museoModerno(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                  if (_currentQuestionIndex > 0) const SizedBox(width: 12),

                  // Next/Submit Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _userAnswers[_currentQuestionIndex] != null
                          ? _nextQuestion
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFE066),
                        foregroundColor: const Color(0xFF4E342E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        _currentQuestionIndex ==
                                widget.quiz.questions.length - 1
                            ? 'Submit Quiz'
                            : 'Next',
                        style: GoogleFonts.museoModerno(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green[400]!;
      case 'medium':
        return Colors.orange[400]!;
      case 'hard':
        return Colors.red[400]!;
      default:
        return Colors.grey[400]!;
    }
  }

  void _selectAnswer(int answerIndex) {
    setState(() {
      _userAnswers[_currentQuestionIndex] = answerIndex;
    });
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    }
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < widget.quiz.questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      _submitQuiz();
    }
  }

  void _submitQuiz() {
    final endTime = DateTime.now();
    final timeTaken = endTime.difference(_startTime!);

    // Calculate score
    int score = 0;
    for (int i = 0; i < widget.quiz.questions.length; i++) {
      if (_userAnswers[i] == widget.quiz.questions[i].correctAnswerIndex) {
        score++;
      }
    }

    final result = QuizResult(
      quizId: widget.quiz.id,
      userId: 'user123', // Get from auth
      userAnswers: _userAnswers.cast<int>(),
      score: score,
      totalQuestions: widget.quiz.questions.length,
      percentage: (score / widget.quiz.questions.length) * 100,
      completedAt: endTime,
      timeTaken: timeTaken,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            QuizResultScreen(quiz: widget.quiz, result: result),
      ),
    );
  }

  void _startTimer() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() {
          if (_timeRemaining.inSeconds > 0) {
            _timeRemaining = Duration(seconds: _timeRemaining.inSeconds - 1);
          } else {
            _submitQuiz(); // Auto-submit when time runs out
          }
        });
        return _timeRemaining.inSeconds > 0;
      }
      return false;
    });
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Exit Quiz?',
          style: GoogleFonts.museoModerno(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF4E342E),
          ),
        ),
        content: Text(
          'Are you sure you want to exit? Your progress will be lost.',
          style: GoogleFonts.museoModerno(color: Colors.brown[600]),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.museoModerno(color: Colors.grey[600]),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Exit quiz
            },
            child: Text(
              'Exit',
              style: GoogleFonts.museoModerno(
                color: Colors.red[600],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
