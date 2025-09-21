import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/aws_quiz_service.dart';
import 'quiz_generation_screen.dart';

class QuizUploadScreen extends StatefulWidget {
  const QuizUploadScreen({super.key});

  @override
  State<QuizUploadScreen> createState() => _QuizUploadScreenState();
}

class _QuizUploadScreenState extends State<QuizUploadScreen> {
  final AWSQuizService _quizService = AWSQuizService();
  File? _selectedFile;
  bool _isUploading = false;
  String _uploadStatus = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9DB),
      appBar: AppBar(
        title: Text(
          'Upload Document',
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Create Quiz from Document',
                style: GoogleFonts.museoModerno(
                  color: const Color(0xFF4E342E),
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Upload a PDF or image to generate a personalized quiz',
                style: GoogleFonts.museoModerno(
                  color: Colors.brown[400],
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 32),

              // File Selection Card
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
                  children: [
                    Icon(
                      Icons.upload_file,
                      size: 64,
                      color: _selectedFile != null
                          ? const Color(0xFFFFE066)
                          : Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _selectedFile != null
                          ? 'File Selected'
                          : 'Select Document',
                      style: GoogleFonts.museoModerno(
                        color: const Color(0xFF4E342E),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (_selectedFile != null) ...[
                      Text(
                        _selectedFile!.path.split('/').last,
                        style: GoogleFonts.museoModerno(
                          color: Colors.brown[600],
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _selectFile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[200],
                          foregroundColor: const Color(0xFF4E342E),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Change File',
                          style: GoogleFonts.museoModerno(),
                        ),
                      ),
                    ] else ...[
                      Text(
                        'Supported formats: PDF, PNG, JPG, JPEG',
                        style: GoogleFonts.museoModerno(
                          color: Colors.brown[400],
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _selectFile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFE066),
                          foregroundColor: const Color(0xFF4E342E),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                        ),
                        child: Text(
                          'Choose File',
                          style: GoogleFonts.museoModerno(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Upload Status
              if (_uploadStatus.isNotEmpty) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _uploadStatus.contains('Error')
                        ? Colors.red[50]
                        : Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _uploadStatus.contains('Error')
                          ? Colors.red[200]!
                          : Colors.blue[200]!,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _uploadStatus.contains('Error')
                            ? Icons.error_outline
                            : Icons.info_outline,
                        color: _uploadStatus.contains('Error')
                            ? Colors.red[600]
                            : Colors.blue[600],
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _uploadStatus,
                          style: GoogleFonts.museoModerno(
                            color: _uploadStatus.contains('Error')
                                ? Colors.red[600]
                                : Colors.blue[600],
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Upload Button
              if (_selectedFile != null) ...[
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isUploading ? null : _uploadDocument,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFE066),
                      foregroundColor: const Color(0xFF4E342E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: _isUploading
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFF4E342E),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Uploading...',
                                style: GoogleFonts.museoModerno(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          )
                        : Text(
                            'Upload & Generate Quiz',
                            style: GoogleFonts.museoModerno(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                  ),
                ),
              ],

              const Spacer(),

              // Info Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          color: Colors.blue[600],
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'How it works',
                          style: GoogleFonts.museoModerno(
                            color: Colors.blue[600],
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      ' AI extracts text and analyzes content\n3. Generate personalized quiz questions',
                      style: GoogleFonts.museoModerno(
                        color: Colors.blue[700],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectFile() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _selectedFile = File(image.path);
          _uploadStatus = '';
        });
      }
    } catch (e) {
      setState(() {
        _uploadStatus = 'Error selecting file: $e';
      });
    }
  }

  Future<void> _uploadDocument() async {
    if (_selectedFile == null) return;

    setState(() {
      _isUploading = true;
      _uploadStatus = 'Uploading document...';
    });

    try {
      // For now, we'll use a mock userId. In a real app, get this from auth
      const String userId = 'user123';

      final document = await _quizService.uploadDocument(
        _selectedFile!,
        userId,
      );

      setState(() {
        _uploadStatus = 'Document uploaded successfully! Processing...';
      });

      // Navigate to quiz generation screen
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizGenerationScreen(
              documentId: document.id,
              fileName: document.fileName,
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _uploadStatus = 'Error uploading document: $e';
        _isUploading = false;
      });
    }
  }
}
