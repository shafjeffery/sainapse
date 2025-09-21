import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'quiz_game_page.dart';

class UploadFileQuizPage extends StatefulWidget {
  const UploadFileQuizPage({super.key});

  @override
  State<UploadFileQuizPage> createState() => _UploadFileQuizPageState();
}

class _UploadFileQuizPageState extends State<UploadFileQuizPage> {
  bool isQuizSelected = true;
  String? selectedFileName;
  bool isUploading = false;
 

  Future<void> _pickFile() async {
    // Simulate file picker dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Select Quiz File',
            style: GoogleFonts.museoModerno(fontWeight: FontWeight.bold),
          ),
          content: Text(
            isQuizSelected 
                ? 'Choose a PDF or DOC file containing quiz questions'
                : 'Choose a video file for video-based quiz',
            style: GoogleFonts.museoModerno(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: GoogleFonts.museoModerno()),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  selectedFileName = isQuizSelected 
                      ? 'quiz_questions.pdf'
                      : 'quiz_video.mp4';
                });
                Navigator.pop(context);
              },
              child: Text('Select File', style: GoogleFonts.museoModerno()),
            ),
          ],
        );
      },
    );
  }

  Future<void> _uploadFile() async {
    if (selectedFileName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a quiz file first')),
      );
      return;
    }

    setState(() {
      isUploading = true;
    });

    // Simulate upload and processing
    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      isUploading = false;
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Quiz uploaded successfully! Redirecting to quiz...'),
        duration: Duration(seconds: 2),
      ),
    );

    // Wait a moment then navigate to quiz game page
    await Future.delayed(const Duration(seconds: 1));

    // Navigate to quiz game page
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const QuizGamePage(),
        ),
      );
    }

    // Reset file selection
    setState(() {
      selectedFileName = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9DB), // Same as home page
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF4E342E)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Upload Quiz File',
          style: GoogleFonts.museoModerno(
            color: const Color(0xFF4E342E),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF4E342E)),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white, // White card for better contrast
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.blue, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              Text(
                'Upload Quiz File',
                style: GoogleFonts.museoModerno(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFFFD93D), // Golden yellow
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 30),
              
              // Content Type Toggle
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isQuizSelected = true;
                            selectedFileName = null; // Reset file when switching
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: isQuizSelected ? const Color(0xFFFFD93D) : Colors.transparent,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Text(
                            'Quiz',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.museoModerno(
                              fontWeight: FontWeight.bold,
                              color: isQuizSelected ? Colors.white : Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isQuizSelected = false;
                            selectedFileName = null; // Reset file when switching
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: !isQuizSelected ? const Color(0xFF8B7355) : Colors.transparent, // Dark olive green
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Text(
                            'Video Quiz',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.museoModerno(
                              fontWeight: FontWeight.bold,
                              color: !isQuizSelected ? Colors.white : Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Quiz Settings
             
              
              const SizedBox(height: 10),
              
              // File Upload Zone
              GestureDetector(
                onTap: _pickFile,
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: selectedFileName != null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isQuizSelected ? Icons.quiz : Icons.video_file,
                              size: 60,
                              color: Colors.green,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              selectedFileName!,
                              style: GoogleFonts.museoModerno(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Tap to change file',
                              style: GoogleFonts.museoModerno(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.cloud_upload,
                              size: 60,
                              color: Colors.black,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              isQuizSelected 
                                  ? 'Select Your Quiz File (PDF/DOC)'
                                  : 'Select Your Video Quiz File',
                              style: GoogleFonts.museoModerno(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Upload Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isUploading ? null : _uploadFile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B7355), // Dark olive green
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: isUploading
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                            SizedBox(width: 10),
                            Text('Uploading...'),
                          ],
                        )
                      : Text(
                          'Upload Quiz',
                          style: GoogleFonts.museoModerno(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
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
