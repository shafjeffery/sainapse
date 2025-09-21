import 'package:flutter/material.dart';
import 'mark_quiz.dart';
import 'dart:async';
import '../main_navigation.dart';
import '../hangman/hangman1.dart';

class QuizGamePage extends StatefulWidget {
  const QuizGamePage({super.key});

  @override
  State<QuizGamePage> createState() => _QuizGamePageState();
}

class _QuizGamePageState extends State<QuizGamePage> {
  int currentStep = 0;
  int currentQuestion = 0;
  int score = 0;
  bool showResult = false;
  bool? isCorrect;
  int selectedIndex = -1;
  bool showReview = false;
  List<int> userAnswers = [];
  Timer? _timer;
  int _timeLeft = 10;

  final List<Map<String, dynamic>> questions = [
    {
      'question': 'In which Malaysian state is Istana Abu Bakar located?',
      'options': ['Selangor', 'Pahang', 'Johor', 'Perak'],
      'answer': 1,
      'explanation': 'Istana Abu Bakar is in the state of Pahang, Malaysia.',
    },
    {
      'question': 'Who commissioned the construction of Istana Abu Bakar?',
      'options': [
        'Sultan Ahmad Shah',
        'Sultan Abdullah Sultan Ahmad Shah',
        'Sultan Abu Bakar',
        'Sultan Mahmud',
      ],
      'answer': 2,
      'explanation':
          'Sultan Abu Bakar commissioned the palace that bears his name.',
    },
    {
      'question':
          'What primary material is used for the palace’s ornate carvings?',
      'options': ['Marble', 'Teak wood', 'Concrete', 'Granite'],
      'answer': 1,
      'explanation':
          'Teak wood is prominently used for the intricate carvings of Istana Abu Bakar.',
    },
    {
      'question': 'Istana Abu Bakar overlooks which river?',
      'options': [
        'Sungai Pahang',
        'Sungai Perak',
        'Sungai Muar',
        'Sungai Kelantan',
      ],
      'answer': 0,
      'explanation': 'The palace is situated along the banks of Sungai Pahang.',
    },
    {
      'question': 'Which year was Istana Abu Bakar completed?',
      'options': ['1880', '1929', '1975', '2001'],
      'answer': 1,
      'explanation': 'Istana Abu Bakar was completed in 1929.',
    },
    {
      'question': 'Which function does the palace mainly serve today?',
      'options': [
        'Public museum',
        'Sultan’s official residence',
        'Government administrative office',
        'Luxury hotel',
      ],
      'answer': 1,
      'explanation':
          'Istana Abu Bakar primarily serves as the Sultan of Pahang’s official residence.',
    },
    {
      'question':
          'What is the name of the ceremonial hall inside Istana Abu Bakar?',
      'options': [
        'Balairung Seri',
        'Dewan Merdeka',
        'Balai Rong Seri',
        'Dewan Tunku Abdul Rahman',
      ],
      'answer': 0,
      'explanation': 'The main ceremonial hall is known as Balairung Seri.',
    },
    {
      'question':
          'Which annual royal celebration is traditionally held at the palace?',
      'options': [
        'Maulidur Rasul',
        'Sultan’s Birthday Investiture',
        'Malaysia Day Parade',
        'Agong’s Coronation',
      ],
      'answer': 1,
      'explanation':
          'The Sultan’s Birthday Investiture ceremony is an annual highlight at Istana Abu Bakar.',
    },
    {
      'question':
          'Istana Abu Bakar’s grounds include gardens inspired by which design style?',
      'options': [
        'Japanese Zen',
        'English landscape',
        'Persian formal',
        'Balinese tropical',
      ],
      'answer': 1,
      'explanation':
          'The surrounding gardens follow an English landscape design, adding elegance to the palace.',
    },
    {
      'question':
          'Which nearby landmark is commonly visited together with Istana Abu Bakar?',
      'options': [
        'Sultan Abu Bakar Mosque',
        'Istana Negara',
        'Bukit Bintang',
        'Petronas Towers',
      ],
      'answer': 0,
      'explanation':
          'Tourists often visit the nearby Sultan Abu Bakar Mosque along with the palace.',
    },
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    _timeLeft = 10;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _timer?.cancel();
          // Time's up - move to next question without adding points
          if (currentQuestion < questions.length - 1) {
            setState(() {
              currentQuestion++;
              selectedIndex = -1;
              isCorrect = null;
              userAnswers[currentQuestion] = -1; // Mark as unanswered
            });
            startTimer(); // Start timer for next question
          } else {
            setState(() {
              showResult = true;
            });
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => MarkQuiz(
                      score: score,
                      totalQuestions: questions.length,
                      questions: questions,
                      userAnswers: userAnswers,
                    ),
              ),
            ).then((result) {
              if (result == 'replay') {
                resetQuiz();
              }
            });
          }
        }
      });
    });
  }

  void startQuiz() {
    setState(() {
      currentStep = 1;
      currentQuestion = 0;
      score = 0;
      showResult = false;
      showReview = false;
      selectedIndex = -1;
      isCorrect = null;
      userAnswers = List.filled(questions.length, -1);
    });
    startTimer();
  }

  void selectAnswer(int index) {
    if (selectedIndex != -1) return;
    _timer?.cancel();
    setState(() {
      selectedIndex = index;
      isCorrect = index == questions[currentQuestion]['answer'];
      if (isCorrect!) {
        score += 10;
      }
      userAnswers[currentQuestion] = index;
    });
    Future.delayed(const Duration(seconds: 1), () async {
      if (currentQuestion < questions.length - 1) {
        setState(() {
          currentQuestion++;
          selectedIndex = -1;
          isCorrect = null;
        });
        startTimer(); // Start timer for next question
      } else {
        setState(() {
          showResult = true;
        });
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => MarkQuiz(
                  score: score,
                  totalQuestions: questions.length,
                  questions: questions,
                  userAnswers: userAnswers,
                ),
          ),
        );
        if (result == 'replay') {
          resetQuiz();
        }
      }
    });
  }

  void resetQuiz() {
    _timer?.cancel();
    setState(() {
      currentStep = 0;
      currentQuestion = 0;
      score = 0;
      showResult = false;
      showReview = false;
      selectedIndex = -1;
      isCorrect = null;
      userAnswers = List.filled(questions.length, -1);
    });
  }

  //Review answers
  @override
  Widget build(BuildContext context) {
    if (showReview) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Review'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black87),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(24),
                itemCount: questions.length,
                itemBuilder: (context, i) {
                  final q = questions[i];
                  return Card(
                    color: const Color(0xFFFFF9E3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(
                        q['question'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...List.generate(q['options'].length, (j) {
                            final isAns = j == q['answer'];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Row(
                                children: [
                                  Icon(
                                    isAns
                                        ? Icons.check_circle
                                        : Icons.radio_button_unchecked,
                                    color: isAns ? Colors.green : Colors.grey,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    q['options'][j],
                                    style: TextStyle(
                                      color:
                                          isAns ? Colors.green : Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                          const SizedBox(height: 6),
                          Text(
                            'Explanation: ${q['explanation']}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.smart_toy, color: Colors.white),
                  label: const Text(
                    'Ask the Guidebot',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF8B7A4F),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () {
                    // TODO: Implement Guidebot action
                  },
                ),
              ),
            ),
          ],
        ),
      );
    }

    //Collect coin

    if (showResult) {
      return Scaffold(
        backgroundColor: const Color(0xFFFFF9E3),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3D6),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Color(0xFFFFCBA4), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'YOUR POINTS',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                      color: Color(0xFFB59B2B),
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            '$score',
                            style: TextStyle(
                              fontSize: 80,
                              fontWeight: FontWeight.bold,
                              foreground:
                                  Paint()
                                    ..shader = LinearGradient(
                                      colors: [
                                        Color(0xFFB59B2B),
                                        Color(0xFFD6B77B),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ).createShader(
                                      Rect.fromLTWH(0, 0, 200, 80),
                                    ),
                              shadows: [
                                Shadow(
                                  blurRadius: 8,
                                  color: Colors.black26,
                                  offset: Offset(2, 4),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFA8E063),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                      ),
                      onPressed: () {},
                      child: const Text(
                        'Leaderboards',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B7A4F),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                      ),
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.card_giftcard,
                            size: 20,
                            color: Colors.white,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Claim Your Gift Card',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD6B77B),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            elevation: 0,
                          ),
                          onPressed: () {
                            // Stop here action
                          },
                          child: const Text(
                            'STOP HERE',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD6B77B),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            elevation: 0,
                          ),
                          onPressed: () async {
                            // Small delay to ensure proper gesture cleanup
                            await Future.delayed(const Duration(milliseconds: 100));
                            if (mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HangmanGamePage(),
                                ),
                              );
                            }
                          },
                          child: const Text(
                            'CONTINUE',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    //Quiz Rules

    if (currentStep == 0) {
      return Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/backgrounddQuiz.png',
                fit: BoxFit.cover,
              ),
            ),
            Center(
              child: Container(
                width: 350,
                padding: const EdgeInsets.symmetric(
                  vertical: 32,
                  horizontal: 0,
                ),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'FUN QUIZ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                        color: Colors.black,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'PLAYING THE GAME AND WIN!',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: Colors.white,
                        letterSpacing: 1.1,
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            blurRadius: 2,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    Container(
                      width: 300,
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 18,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFE066),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.black, width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 6,
                            offset: const Offset(2, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(
                            child: Text(
                              'RULES',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            '1. Each quiz has 10 multiple-choice questions.\n'
                            '2. Pick the correct answer to earn 10 points!\n'
                            '3. You have 10 seconds per question.\n'
                            '4. No penalty for wrong answers - try your best!\n'
                            '5. Complete all to unlock points!',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15.5,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 18),
                          const Divider(
                            color: Colors.brown,
                            thickness: 1,
                            endIndent: 2,
                            indent: 2,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 36),
                    Column(
                      children: [
                        SizedBox(
                          width: 220,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF7A6A27),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                              elevation: 2,
                            ),
                            onPressed: startQuiz,
                            child: const Text(
                              'START',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                letterSpacing: 1.1,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: 220,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                              elevation: 2,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MainNavigation(),
                                ),
                              );
                            },
                            child: const Text(
                              'QUIT',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                letterSpacing: 1.1,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    //Quiz page

    final q = questions[currentQuestion];

    return Scaffold(
      backgroundColor: const Color(0xFFFFF9E3),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              _timer?.cancel();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: (currentQuestion + 1) / questions.length,
                    backgroundColor: Colors.yellow[100],
                    color: const Color(0xFFFFC300),
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color:
                        _timeLeft <= 3 ? Colors.red : const Color(0xFFFFC300),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$_timeLeft s',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Question ${currentQuestion + 1}/${questions.length}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              q['question'],
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 24),
            ...List.generate(q['options'].length, (index) {
              final option = q['options'][index];
              final isSelected = selectedIndex == index;
              final correct = q['answer'] == index;
              Color? color;

              if (selectedIndex != -1) {
                if (isSelected && correct) {
                  color = Colors.green;
                } else if (isSelected && !correct) {
                  color = Colors.red;
                } else if (correct) {
                  color = Colors.green.withOpacity(0.5);
                }
              }

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ElevatedButton(
                  onPressed: () => selectAnswer(index),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color ?? Colors.white,
                    foregroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 12,
                    ),
                    side: const BorderSide(color: Color(0xFFFFC300)),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(option, style: const TextStyle(fontSize: 16)),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
