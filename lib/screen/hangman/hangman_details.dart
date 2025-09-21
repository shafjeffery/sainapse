import 'package:flutter/material.dart';
import 'package:sainapse/screen/main_navigation.dart';

class HangmanDetails extends StatelessWidget {
  const HangmanDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/backgrounddQuiz.png', fit: BoxFit.cover),
          ),
          Center(
            child: Container(
              width: 350,
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 0),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(32),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'HANGMAN',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                      color: Colors.black,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'PLAYING THE GAME AND LEARN',
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
                          '1. You have to guess the hidden word letter by letter.\n'
                          '2. You get 5 chances to guess wrong letters.\n'
                          '3. Every correct word guessed = 15 points.\n'
                          '4. Complete all this to unlock points!',
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
                          onPressed: () {
                            Navigator.pushNamed(context, '/hangman');
                          },
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
}
