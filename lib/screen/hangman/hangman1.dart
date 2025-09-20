import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import '../quiz/mark_quiz.dart';

class HangmanGamePage extends StatefulWidget {
  const HangmanGamePage({Key? key}) : super(key: key);

  @override
  State<HangmanGamePage> createState() => _HangmanGamePageState();
}

class _HangmanGamePageState extends State<HangmanGamePage> {
  static const List<Map<String, String>> _wordList = [
    {
      'word': 'SULTAN ABU BAKAR',
      'hint': 'The name of the museum in Pekan, Pahang.',
    },
    {
      'word': 'PEKAN PAHANG',
      'hint': 'The royal town where the museum is located.',
    },
    {
      'word': 'ROYAL REGALIA',
      'hint': 'Symbols of royalty like crowns and ceremonial items.',
    },
    {
      'word': 'KERIS',
      'hint': 'A traditional Malay dagger displayed in the museum.',
    },
    {
      'word': 'TEXTILES',
      'hint': 'Traditional Malay fabrics and weaving tools.',
    },
    {
      'word': 'ISTANA BATU',
      'hint': "The building's original name before it became a museum.",
    },
    {'word': 'CERAMICS', 'hint': 'Antique porcelain and pottery on display.'},
    {
      'word': 'WEAPONRY',
      'hint': 'Spears, swords, and firearms from Malay history.',
    },
    {
      'word': 'MALAY CULTURE',
      'hint': 'The heritage and traditions showcased in the museum.',
    },
    {
      'word': 'ISLAMIC ART',
      'hint': 'Beautiful calligraphy and religious artifacts.',
    },
    {'word': 'ROYAL CROWN', 'hint': 'Worn by the sultan as a symbol of power.'},
    {'word': 'SILVER CUP', 'hint': 'A shiny item used in royal dining.'},
    {'word': 'OLD PALACE', 'hint': 'What the museum used to be.'},
    {'word': 'GOLD COINS', 'hint': 'Ancient currency found in the museum.'},
    {
      'word': 'BRASS TRAY',
      'hint': 'Used in royal ceremonies for offerings or items.',
    },
    {'word': 'WOOD PANEL', 'hint': 'Decorative carvings on the museum walls.'},
    {'word': 'GOLD JEWEL', 'hint': 'Worn by royals in ceremonial dress.'},
    {
      'word': 'PHOTO ROOM',
      'hint': 'A gallery filled with old photos of royalty.',
    },
    {'word': 'ROYAL MASK', 'hint': 'Used in rituals or performances.'},
    {'word': 'BATIK ART', 'hint': 'Traditional Malay fabric art on display.'},
    {'word': 'SILK ROBE', 'hint': 'Worn by members of the royal family.'},
    {'word': 'ROYAL SEAT', 'hint': 'Throne used by the sultan.'},
    {'word': 'CLOCK ROOM', 'hint': 'Room with antique timepieces.'},
    {'word': 'GONG', 'hint': 'A traditional musical instrument.'},
    {'word': 'WAR TOOLS', 'hint': 'Items used in past battles.'},
    {'word': 'BRONZE POT', 'hint': 'Cooking or ceremonial item in metal form.'},
    {'word': 'GLASS CASE', 'hint': 'Used to protect and display artifacts.'},
    {
      'word': 'FRAME ART',
      'hint': 'Traditional works displayed in wooden borders.',
    },
    {
      'word': 'WOVEN BAG',
      'hint': 'Handcrafted item shown in the textile section.',
    },
    {'word': 'ROYAL RING', 'hint': 'Jewelry worn by the royal family.'},
  ];

  late String _answer;
  late List<String> _answerChars;
  Set<String> _guessed = {};
  int _wrongGuesses = 0;
  final int _maxWrong = 6;
  bool _showFullAnswer = false;
  bool _gameOver = false;
  bool _won = false;
  int _currentRound = 1;
  int _correctCount = 0;
  final int _totalRounds = 10;
  late List<String> _testWords;

  @override
  void initState() {
    super.initState();
    _startTest();
  }

  void _startTest() {
    final random = Random();
    _testWords = List<String>.from(_wordList.map((e) => e['word']!))
      ..shuffle(random);
    _currentRound = 1;
    _correctCount = 0;
    _startNewGame();
  }

  void _startNewGame() {
    _answer = _testWords[_currentRound - 1];
    _answerChars = _answer.split('');
    _guessed = {};
    _wrongGuesses = 0;
    _showFullAnswer = false;
    _gameOver = false;
    _won = false;
    setState(() {});
  }

  void _guessLetter(String letter) {
    if (_gameOver || _guessed.contains(letter)) return;
    setState(() {
      _guessed.add(letter);
      if (!_answer.contains(letter)) {
        _wrongGuesses++;
        if (_wrongGuesses >= _maxWrong) {
          _gameOver = true;
          _won = false;
        }
      } else {
        if (_answerChars.every((c) => _guessed.contains(c))) {
          _gameOver = true;
          _won = true;
        }
      }
    });
  }

  void _revealAnswer() {
    setState(() {
      if (_answerChars
          .where((c) => c != ' ')
          .every((c) => _guessed.contains(c))) {
        _won = true;
        _gameOver = true;
        _showFullAnswer = false;
        _correctCount++;
      } else {
        _showFullAnswer = true;
        _gameOver = true;
        _won = false;
      }
    });
  }

  void _nextRound() {
    if (_currentRound < _totalRounds) {
      setState(() {
        _currentRound++;
      });
      _startNewGame();
    } else {
      setState(() {}); // triggers summary
    }
  }

  void _navigateToMarkQuiz() {
    // Create sample quiz data for the mark quiz
    final List<Map<String, dynamic>> sampleQuestions = [
      {
        'question': 'What is the capital of Malaysia?',
        'options': ['Kuala Lumpur', 'Putrajaya', 'Johor Bahru', 'Penang'],
        'answer': 0,
        'explanation': 'Kuala Lumpur is the capital of Malaysia.',
      },
      {
        'question': 'Which state is known as the "Land Below the Wind"?',
        'options': ['Sabah', 'Sarawak', 'Perak', 'Selangor'],
        'answer': 0,
        'explanation': 'Sabah is known as the "Land Below the Wind".',
      },
    ];
    
    // Calculate score based on correct hangman rounds
    final int hangmanScore = _correctCount * 10; // 10 points per correct round
    final List<int> sampleAnswers = List.filled(sampleQuestions.length, 0); // Sample answers
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MarkQuiz(
          score: hangmanScore,
          totalQuestions: sampleQuestions.length,
          questions: sampleQuestions,
          userAnswers: sampleAnswers,
        ),
      ),
    );
  }

  Widget _buildTestProgress() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        'Round $_currentRound / $_totalRounds',
        style: GoogleFonts.poppins(
          fontSize: 15,
          color: Colors.black54,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildSummary() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 8),
        Icon(Icons.emoji_events, color: Color(0xFFFFD700), size: 100),
        const SizedBox(height: 16),
        Text(
          'WELL DONE!',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFFBFA14A),
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
          '$_correctCount of $_totalRounds',
          style: GoogleFonts.poppins(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 28),
      ],
    );
  }

  Widget _buildWordDisplay() {
    final words = _answer.split(' ');
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        for (int i = 0; i < words.length; i++)
          Padding(
            padding: EdgeInsets.only(bottom: i < words.length - 1 ? 10 : 0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children:
                  words[i].split('').map((c) {
                    final revealed = _guessed.contains(c) || _showFullAnswer;
                    return Container(
                      width: 30,
                      height: 42,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 240, 212, 68),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 2,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          revealed ? c : '',
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: revealed ? Colors.black : Colors.transparent,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildHint() {
    final hint =
        _wordList.firstWhere(
          (e) => e['word'] == _answer,
          orElse: () => {},
        )['hint'] ??
        '';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        hint,
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
      ),
    );
  }

  Widget _buildFullAnswerButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: (!_gameOver && !_showFullAnswer) ? _revealAnswer : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFFF6D6),
            foregroundColor: Colors.black87,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Submit Answer'),
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFBFA14A),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(6),
                child: const Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLetterButtons() {
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 6,
        runSpacing: 6,
        children:
            letters.split('').map((letter) {
              final guessed = _guessed.contains(letter);
              return SizedBox(
                width: 36,
                height: 36,
                child: ElevatedButton(
                  onPressed:
                      guessed || _gameOver ? null : () => _guessLetter(letter),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        guessed
                            ? (_answer.contains(letter)
                                ? Colors.green[200]
                                : Colors.red[200])
                            : const Color(0xFF0033CC),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                    padding: EdgeInsets.zero,
                    minimumSize: Size(36, 36),
                    textStyle: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    alignment: Alignment.center,
                  ),
                  child: Text(letter, textAlign: TextAlign.center),
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildWrongGuessesXs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_maxWrong, (i) {
        final isWrong = i < _wrongGuesses;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Text(
            'X',
            style: GoogleFonts.poppins(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: isWrong ? Colors.red : Colors.black,
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBE7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFBE7),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.of(context).maybePop(),
          splashRadius: 20,
        ),
        title: Text(
          'Hangman',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
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
            child:
                _currentRound > _totalRounds
                    ? _buildSummary()
                    : Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildTestProgress(),
                        const SizedBox(height: 10),
                        _buildHint(),
                        const SizedBox(height: 10),
                        _buildWordDisplay(),
                        const SizedBox(height: 15),
                        _buildWrongGuessesXs(),
                        const SizedBox(height: 24),
                        _buildLetterButtons(),
                        _buildFullAnswerButton(),
                        if (_gameOver || _showFullAnswer)
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Center(
                              child: Text(
                                _won ? 'CORRECT!' : 'Answer: $_answer',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      _won
                                          ? Colors.green[700]
                                          : Colors.red[700],
                                ),
                              ),
                            ),
                          ),
                        if (_gameOver)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Center(
                              child: ElevatedButton(
                                onPressed: _currentRound < _totalRounds ? _nextRound : _navigateToMarkQuiz,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0033CC),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 10,
                                  ),
                                ),
                                child: Text(
                                  _currentRound < _totalRounds ? 'Continue' : 'Game Complete',
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
          ),
        ),
      ),
    );
  }
}
