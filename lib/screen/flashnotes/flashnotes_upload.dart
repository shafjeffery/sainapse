import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'flashnotes_filelist.dart';
import '../../shared/theme.dart';
import '../../services/aws_flashnotes_service.dart';
import '../../services/aws_config.dart';
import '../../debug/aws_test_widget.dart';

class UploadFileSummaryPage extends StatefulWidget {
  const UploadFileSummaryPage({super.key});

  @override
  State<UploadFileSummaryPage> createState() => _UploadFileSummaryPageState();
}

class _UploadFileSummaryPageState extends State<UploadFileSummaryPage> {
  bool isQuizSelected = true;
  String? selectedFileName;
  File? selectedFile;
  Uint8List? selectedFileBytes;
  String? selectedContentType;
  bool isUploading = false;
  String? errorMessage;

  Future<void> _pickFile() async {
    try {
      setState(() {
        errorMessage = null;
      });

      final FilePickerResult? result = await AWSFlashnotesService.pickFile(
        isDocument: isQuizSelected,
      );

      if (result != null && result.files.isNotEmpty) {
        final PlatformFile platformFile = result.files.single;
        final String fileName = platformFile.name;
        final String contentType = AWSFlashnotesService.getContentType(
          fileName,
        );

        // Validate file type
        if (!AWSFlashnotesService.isValidFileType(
          contentType,
          isQuizSelected,
        )) {
          setState(() {
            errorMessage = isQuizSelected
                ? 'Please select a valid document file (PDF, DOC, DOCX, JPG, PNG, TIFF, WEBP)'
                : 'Please select a valid video file (MP4, AVI, MOV, WMV)';
          });
          return;
        }

        // Validate file size
        final int fileSize = platformFile.size;
        if (!AWSFlashnotesService.isValidFileSize(fileSize)) {
          setState(() {
            errorMessage = 'File size must be less than 10MB';
          });
          return;
        }

        setState(() {
          selectedFileName = fileName;
          selectedContentType = contentType;

          if (kIsWeb) {
            // On web, use bytes
            selectedFileBytes = platformFile.bytes;
            selectedFile = null;
          } else {
            // On mobile, use file path
            if (platformFile.path != null) {
              selectedFile = File(platformFile.path!);
              selectedFileBytes = null;
            } else {
              setState(() {
                errorMessage = 'Failed to access file path';
              });
              return;
            }
          }
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error picking file: $e';
      });
    }
  }

  Future<void> _uploadFile() async {
    if ((selectedFile == null && selectedFileBytes == null) ||
        selectedFileName == null ||
        selectedContentType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a file first')),
      );
      return;
    }

    setState(() {
      isUploading = true;
      errorMessage = null;
    });

    try {
      // Process file with AWS services
      final FlashnotesResult? result = await AWSFlashnotesService.processFile(
        file: selectedFile,
        fileBytes: selectedFileBytes,
        fileName: selectedFileName!,
        contentType: selectedContentType!,
      );

      if (result != null) {
        // Store the result before resetting
        final processedFileName = result.fileName;

        // Navigate to file list page after successful processing
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FileSummaryOptionsPage(
                fileName: processedFileName,
                flashnotesResult: result,
              ),
            ),
          );
        }

        // Reset file selection
        setState(() {
          selectedFile = null;
          selectedFileBytes = null;
          selectedFileName = null;
          selectedContentType = null;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to process file. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error processing file: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          isUploading = false;
        });
      }
    }
  }

  /// Check if AWS credentials are properly configured
  bool _hasValidAWSCredentials() {
    final String accessKey = AWSConfig.accessKeyId;
    final String secretKey = AWSConfig.secretAccessKey;

    return accessKey.isNotEmpty &&
        secretKey.isNotEmpty &&
        accessKey != 'YOUR_ACCESS_KEY_ID' &&
        secretKey != 'YOUR_SECRET_ACCESS_KEY';
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
          'Upload Your File',
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
                'Upload Your File',
                style: GoogleFonts.museoModerno(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor, // Dark brown text
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 10),

              // AWS Status Indicator
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _hasValidAWSCredentials()
                      ? Colors.green[100]
                      : Colors.orange[100],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _hasValidAWSCredentials()
                        ? Colors.green
                        : Colors.orange,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _hasValidAWSCredentials()
                          ? Icons.cloud_done
                          : Icons.warning_amber,
                      size: 16,
                      color: _hasValidAWSCredentials()
                          ? Colors.green[700]
                          : Colors.orange[700],
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _hasValidAWSCredentials()
                          ? 'AWS Mode (Full AI processing)'
                          : 'Local Mode (Configure AWS for full features)',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: _hasValidAWSCredentials()
                            ? Colors.green[700]
                            : Colors.orange[700],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // AWS Test Button (Debug)
              if (kDebugMode)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AWSTestWidget(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('🔧 Test AWS Configuration (Debug)'),
                  ),
                ),

              const SizedBox(height: 10),

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
                            selectedFile = null;
                            selectedFileName = null;
                            selectedContentType = null;
                            errorMessage = null;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: isQuizSelected
                                ? AppTheme.accentColor
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Text(
                            'Notes',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.museoModerno(
                              fontWeight: FontWeight.bold,
                              color: isQuizSelected
                                  ? Colors.white
                                  : Colors.grey[600],
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
                            selectedFile = null;
                            selectedFileName = null;
                            selectedContentType = null;
                            errorMessage = null;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: !isQuizSelected
                                ? const Color(0xFF8B7355)
                                : Colors.transparent, // Dark olive green
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Text(
                            'Video',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.museoModerno(
                              fontWeight: FontWeight.bold,
                              color: !isQuizSelected
                                  ? Colors.white
                                  : Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Error Message
              if (errorMessage != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red[300]!),
                  ),
                  child: Text(
                    errorMessage!,
                    style: GoogleFonts.poppins(
                      color: Colors.red[700],
                      fontSize: 14,
                    ),
                  ),
                ),

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
                                  ? 'Select Your Notes File (PDF/DOC)'
                                  : 'Select Your Video File',
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
                    backgroundColor: const Color(
                      0xFF8B7355,
                    ), // Dark olive green
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: isUploading
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
                              _hasValidAWSCredentials()
                                  ? 'Processing with AWS...'
                                  : 'Processing locally...',
                              style: GoogleFonts.museoModerno(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          'Upload & Process',
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
