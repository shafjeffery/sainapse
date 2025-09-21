import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'simplenote.dart';
import 'flashcard.dart';
import '../../shared/theme.dart';
import '../../services/aws_flashnotes_service.dart';

class FileSummaryOptionsPage extends StatefulWidget {
  final String fileName; // Pass uploaded file name
  final FlashnotesResult? flashnotesResult; // Pass processed result

  const FileSummaryOptionsPage({
    super.key,
    required this.fileName,
    this.flashnotesResult,
  });

  @override
  State<FileSummaryOptionsPage> createState() => _FileSummaryOptionsPageState();
}

class _FileSummaryOptionsPageState extends State<FileSummaryOptionsPage> {
  String selectedOption = "Simple Notes";
  final List<String> options = ["Simple Notes", "Flash Card", "Mind Map"];
  bool showOptions = false;

  void _handleConfirm() {
    // Show confirmation dialog or navigate to next screen
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Confirm Selection',
            style: GoogleFonts.museoModerno(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'You have selected "${selectedOption}" for file "${widget.fileName}". Do you want to proceed?',
            style: GoogleFonts.museoModerno(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: GoogleFonts.museoModerno()),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog

                // Navigate based on selected option
                if (selectedOption == "Simple Notes") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SimpleNotesResultPage(
                        fileName: widget.fileName,
                        flashnotesResult: widget.flashnotesResult,
                      ),
                    ),
                  );
                } else if (selectedOption == "Flash Card") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FlashcardsResultPage(
                        fileName: widget.fileName,
                        flashnotesResult: widget.flashnotesResult,
                      ),
                    ),
                  );
                } else {
                  // For other options (Mind Map), show processing message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Processing ${selectedOption} for ${widget.fileName}...',
                        style: GoogleFonts.museoModerno(),
                      ),
                      backgroundColor: const Color(0xFF4E342E),
                    ),
                  );
                }
              },
              child: Text(
                'Confirm',
                style: GoogleFonts.museoModerno(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF4E342E),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9DB), // light yellow
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF4E342E)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Flash Notes",
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
            Text(
              "Your File",
              style: GoogleFonts.museoModerno(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: const Color(0xFF4E342E),
              ),
            ),
            const SizedBox(height: 10),

            // File card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.insert_drive_file,
                    color: AppTheme.accentColor,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.fileName,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Upload More Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  // TODO: Implement add more upload
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF4E342E)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  "Upload More",
                  style: GoogleFonts.museoModerno(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: const Color(0xFF4E342E),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Summarize Dropdown Button
            GestureDetector(
              onTap: () {
                setState(() {
                  showOptions = !showOptions;
                });
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF4E342E),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Summarize",
                      style: GoogleFonts.museoModerno(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Icon(
                      showOptions ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),

            if (showOptions)
              Container(
                margin: const EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: options.map((option) {
                    final isSelected = option == selectedOption;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedOption = option;
                          showOptions = false;
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.accentColor
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          option,
                          style: GoogleFonts.museoModerno(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: isSelected ? Colors.black : Colors.grey[800],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

            const SizedBox(height: 20),

            // Confirm Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle confirmation
                  _handleConfirm();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentColor, // Yellow background
                  foregroundColor: AppTheme.primaryColor, // Brown text
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  'Transform to ${selectedOption}',
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
