import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/aws_quiz_service.dart';
import '../../models/quiz_models.dart';
import 'quiz_display_screen.dart';

class QuizGenerationScreen extends StatefulWidget {
  final String documentId;
  final String fileName;

  const QuizGenerationScreen({
    super.key,
    required this.documentId,
    required this.fileName,
  });

  @override
  State<QuizGenerationScreen> createState() => _QuizGenerationScreenState();
}

class _QuizGenerationScreenState extends State<QuizGenerationScreen> {
  final AWSQuizService _quizService = AWSQuizService();
  String _status = 'Processing document...';
  int _progress = 0;
  bool _isGenerating = true;
  Quiz? _generatedQuiz;

  @override
  void initState() {
    super.initState();
    _startQuizGeneration();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9DB),
      appBar: AppBar(
        title: Text(
          'Generating Quiz',
          style: GoogleFonts.museoModerno(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF4E342E),
          ),
        ),
        backgroundColor: const Color(0xFFFFE066),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4E342E)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // File Info Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
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
                  children: [
                    Icon(
                      Icons.description,
                      size: 48,
                      color: const Color(0xFFFFE066),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.fileName,
                      style: GoogleFonts.museoModerno(
                        color: const Color(0xFF4E342E),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Document ID: ${widget.documentId}',
                      style: GoogleFonts.museoModerno(
                        color: Colors.brown[400],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Progress Section
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Progress Circle
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 120,
                          height: 120,
                          child: CircularProgressIndicator(
                            value: _progress / 100,
                            strokeWidth: 8,
                            backgroundColor: Colors.grey[200],
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFFFFE066),
                            ),
                          ),
                        ),
                        Text(
                          '$_progress%',
                          style: GoogleFonts.museoModerno(
                            color: const Color(0xFF4E342E),
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Status Text
                    Text(
                      _status,
                      style: GoogleFonts.museoModerno(
                        color: const Color(0xFF4E342E),
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 16),

                    // Progress Steps
                    _buildProgressSteps(),

                    const SizedBox(height: 32),

                    // Action Button
                    if (_generatedQuiz != null) ...[
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _startQuiz,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFE066),
                            foregroundColor: const Color(0xFF4E342E),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Start Quiz',
                            style: GoogleFonts.museoModerno(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ] else if (!_isGenerating && _status.contains('Error')) ...[
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _retryGeneration,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange[400],
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Retry',
                            style: GoogleFonts.museoModerno(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Info Card
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressSteps() {
    final steps = [
      'Uploading document',
      'Extracting text',
      'Analyzing content',
      'Generating questions',
      'Finalizing quiz',
    ];

    return Column(
      children: steps.asMap().entries.map((entry) {
        final index = entry.key;
        final step = entry.value;
        final isCompleted = _progress > (index * 20);
        final isCurrent =
            _progress >= (index * 20) && _progress < ((index + 1) * 20);

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted
                      ? const Color(0xFFFFE066)
                      : isCurrent
                      ? const Color(0xFFFFE066).withOpacity(0.5)
                      : Colors.grey[300],
                ),
                child: isCompleted
                    ? const Icon(
                        Icons.check,
                        color: Color(0xFF4E342E),
                        size: 16,
                      )
                    : isCurrent
                    ? const SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFF4E342E),
                          ),
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  step,
                  style: GoogleFonts.museoModerno(
                    color: isCompleted || isCurrent
                        ? const Color(0xFF4E342E)
                        : Colors.grey[500],
                    fontWeight: isCompleted || isCurrent
                        ? FontWeight.w600
                        : FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Future<void> _startQuizGeneration() async {
    try {
      // Simulate document processing steps
      await _simulateProgress();

      // Generate quiz using the service with OCR
      setState(() {
        _status = 'Extracting text from image...';
        _progress = 60;
      });

      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _status = 'Generating quiz questions...';
        _progress = 80;
      });

      _generatedQuiz = await _quizService.generateQuiz(
        widget.documentId,
        'user123',
        numberOfQuestions: 5,
        difficulty: 'medium',
      );

      setState(() {
        _status = 'Quiz generated successfully!';
        _progress = 100;
        _isGenerating = false;
      });
    } catch (e) {
      setState(() {
        _status = 'Error generating quiz: $e';
        _isGenerating = false;
      });
    }
  }

  Future<void> _simulateProgress() async {
    final steps = [
      'Uploading document...',
      'Extracting text with OCR...',
      'Analyzing content with AI...',
      'Generating questions...',
    ];

    for (int i = 0; i < steps.length; i++) {
      await Future.delayed(const Duration(seconds: 2));
      setState(() {
        _status = steps[i];
        _progress = (i + 1) * 15; // Adjusted for better progress flow
      });
    }
  }

  void _startQuiz() {
    if (_generatedQuiz != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuizDisplayScreen(quiz: _generatedQuiz!),
        ),
      );
    }
  }

  void _retryGeneration() {
    setState(() {
      _isGenerating = true;
      _progress = 0;
      _status = 'Retrying...';
      _generatedQuiz = null;
    });
    _startQuizGeneration();
  }
}
