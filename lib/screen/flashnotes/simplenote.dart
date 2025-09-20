import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SimpleNotesResultPage extends StatelessWidget {
  final String fileName;

  const SimpleNotesResultPage({super.key, required this.fileName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9DB), // Light yellow
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF4E342E)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Simple Notes",
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summarized Notes Card
            Expanded(
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
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Understanding Python",
                        style: GoogleFonts.museoModerno(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: const Color(0xFF4E342E),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "What is Python?",
                        style: GoogleFonts.museoModerno(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Python is a popular programming language. "
                        "It was created by Guido van Rossum, and released in 1991. "
                        "It is used for:\n"
                        "• Web development (server-side)\n"
                        "• Software development\n"
                        "• Mathematics\n"
                        "• System scripting",
                        style: GoogleFonts.poppins(fontSize: 14),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "What can Python do?",
                        style: GoogleFonts.museoModerno(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "• Python can be used on a server to create web applications.\n"
                        "• It can be used alongside software to create workflows.\n"
                        "• Python can connect to database systems.\n"
                        "• It can also read and modify files.",
                        style: GoogleFonts.poppins(fontSize: 14),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Python Syntax",
                        style: GoogleFonts.museoModerno(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Python has a simple syntax similar to the English language. "
                        "Python has syntax that allows developers to write programs with fewer lines than some other programming languages.\n\n"
                        "Example:\n"
                        "print('Hello, World!')\n"
                        "if 5 > 2:\n"
                        "    print('Five is greater than two!')",
                        style: GoogleFonts.poppins(fontSize: 14),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Python Variables",
                        style: GoogleFonts.museoModerno(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "In Python, variables are created when you assign a value to them. "
                        "Python has no command for declaring a variable.\n\n"
                        "Variables do not need to be declared with any particular type, "
                        "and can even change type after they have been set.",
                        style: GoogleFonts.poppins(fontSize: 14),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Python Data Types",
                        style: GoogleFonts.museoModerno(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Python has the following data types built-in by default:\n"
                        "• Text Type: str\n"
                        "• Numeric Types: int, float, complex\n"
                        "• Sequence Types: list, tuple, range\n"
                        "• Mapping Type: dict\n"
                        "• Set Types: set, frozenset\n"
                        "• Boolean Type: bool\n"
                        "• Binary Types: bytes, bytearray, memoryview",
                        style: GoogleFonts.poppins(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
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
                        "Saved into folder successfully!",
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
