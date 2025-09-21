import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/file_service.dart';
import '../../services/aws_flashnotes_service.dart';

class SimpleNotesResultPage extends StatefulWidget {
  final String fileName;
  final FlashnotesResult? flashnotesResult;

  const SimpleNotesResultPage({
    super.key,
    required this.fileName,
    this.flashnotesResult,
  });

  @override
  State<SimpleNotesResultPage> createState() => _SimpleNotesResultPageState();
}

class _SimpleNotesResultPageState extends State<SimpleNotesResultPage> {
  bool isSaving = false;

  Future<void> _saveNotes() async {
    // Show rename dialog first
    final String? renamedFileName = await _showRenameDialog();
    if (renamedFileName == null) return; // User cancelled

    setState(() {
      isSaving = true;
    });

    try {
      // Get the notes content
      final String notesContent = _getNotesContent();

      // Save to file with renamed filename
      final bool success = await FileService.saveNotesToFile(
        fileName: renamedFileName,
        content: notesContent,
        noteType: 'Simple Notes',
      );

      if (mounted) {
        if (success) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Notes saved successfully as '$renamedFileName'!",
                style: GoogleFonts.museoModerno(),
              ),
              backgroundColor: const Color(0xFF4E342E),
              duration: const Duration(seconds: 2),
            ),
          );

          // Navigate back to homepage after a short delay
          await Future.delayed(const Duration(seconds: 1));
          if (mounted) {
            Navigator.popUntil(context, (route) => route.isFirst);
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Failed to save notes. Please try again.",
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
              "Error saving notes: $e",
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

  Future<String?> _showRenameDialog() async {
    final TextEditingController controller = TextEditingController();
    controller.text = widget.fileName
        .split('.')
        .first; // Remove extension for editing

    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Save Notes',
            style: GoogleFonts.museoModerno(
              fontWeight: FontWeight.bold,
              color: const Color(0xFF4E342E),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter a name for your notes:',
                style: GoogleFonts.museoModerno(color: const Color(0xFF4E342E)),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Enter notes name...',
                  hintStyle: GoogleFonts.poppins(color: Colors.grey[500]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF4E342E)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF4E342E),
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                style: GoogleFonts.poppins(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: GoogleFonts.museoModerno(color: Colors.grey[600]),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final String fileName = controller.text.trim();
                if (fileName.isNotEmpty) {
                  Navigator.of(context).pop('$fileName.txt');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4E342E),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Save',
                style: GoogleFonts.museoModerno(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  String _getNotesContent() {
    // Use AWS-generated content if available, otherwise fallback to dummy content
    if (widget.flashnotesResult != null) {
      return widget.flashnotesResult!.simpleNotes;
    }

    return """Understanding Python

What is Python?
Python is a popular programming language. It was created by Guido van Rossum, and released in 1991. It is used for:
• Web development (server-side)
• Software development
• Mathematics
• System scripting

What can Python do?
• Python can be used on a server to create web applications.
• It can be used alongside software to create workflows.
• Python can connect to database systems.
• It can also read and modify files.

Python Syntax
Python has a simple syntax similar to the English language. Python has syntax that allows developers to write programs with fewer lines than some other programming languages.

Example:
print('Hello, World!')
if 5 > 2:
    print('Five is greater than two!')

Python Variables
In Python, variables are created when you assign a value to them. Python has no command for declaring a variable.

Variables do not need to be declared with any particular type, and can even change type after they have been set.

Python Data Types
Python has the following data types built-in by default:
• Text Type: str
• Numeric Types: int, float, complex
• Sequence Types: list, tuple, range
• Mapping Type: dict
• Set Types: set, frozenset
• Boolean Type: bool
• Binary Types: bytes, bytearray, memoryview

---
Generated from: ${widget.fileName}
Created: ${DateTime.now().toString()}
""";
  }

  Widget _buildNotesContent() {
    if (widget.flashnotesResult != null) {
      // Display AWS-generated content
      return Text(
        widget.flashnotesResult!.simpleNotes,
        style: GoogleFonts.poppins(fontSize: 14),
      );
    } else {
      // Display fallback content
      return Column(
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
      );
    }
  }

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
                  child: _buildNotesContent(),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isSaving ? null : _saveNotes,
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
