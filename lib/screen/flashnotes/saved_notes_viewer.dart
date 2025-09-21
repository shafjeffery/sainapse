import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/file_service.dart';

class SavedNotesViewer extends StatefulWidget {
  const SavedNotesViewer({super.key});

  @override
  State<SavedNotesViewer> createState() => _SavedNotesViewerState();
}

class _SavedNotesViewerState extends State<SavedNotesViewer> with WidgetsBindingObserver {
  List<Map<String, dynamic>> savedNotes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadSavedNotes();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Refresh when app comes back to foreground
      _loadSavedNotes();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh when page becomes visible again
    _loadSavedNotes();
  }

  Future<void> _loadSavedNotes() async {
    setState(() {
      isLoading = true;
    });

    try {
      final notes = await FileService.getSavedNotes();
      setState(() {
        savedNotes = notes;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Error loading saved notes: $e",
              style: GoogleFonts.museoModerno(),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _deleteNote(Map<String, dynamic> note) async {
    try {
      final bool success = await FileService.deleteNote(note['filePath']);
      if (success) {
        await _loadSavedNotes(); // Refresh the list
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Note deleted successfully",
                style: GoogleFonts.museoModerno(),
              ),
              backgroundColor: const Color(0xFF4E342E),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Failed to delete note",
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
              "Error deleting note: $e",
              style: GoogleFonts.museoModerno(),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9DB),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF4E342E)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Saved Notes",
          style: GoogleFonts.museoModerno(
            color: const Color(0xFF4E342E),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFF4E342E)),
            onPressed: _loadSavedNotes,
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4E342E)),
              ),
            )
          : savedNotes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.folder_open, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    "No saved notes yet",
                    style: GoogleFonts.museoModerno(
                      fontSize: 18,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Upload and save notes to see them here",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Your Saved Notes (${savedNotes.length})",
                    style: GoogleFonts.museoModerno(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF4E342E),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: savedNotes.length,
                      itemBuilder: (context, index) {
                        final note = savedNotes[index];
                        final createdAt = DateTime.parse(note['createdAt']);
                        final noteType = note['noteType'] as String;

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: _getNoteTypeColor(
                                  noteType,
                                ).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                _getNoteTypeIcon(noteType),
                                color: _getNoteTypeColor(noteType),
                                size: 24,
                              ),
                            ),
                            title: Text(
                              note['fileName'],
                              style: GoogleFonts.museoModerno(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text(
                                  noteType,
                                  style: GoogleFonts.poppins(
                                    color: _getNoteTypeColor(noteType),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "Created: ${_formatDate(createdAt)}",
                                  style: GoogleFonts.poppins(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            trailing: PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == 'delete') {
                                  _showDeleteDialog(note);
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete, color: Colors.red),
                                      SizedBox(width: 8),
                                      Text('Delete'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Color _getNoteTypeColor(String noteType) {
    switch (noteType) {
      case 'Simple Notes':
        return const Color(0xFF4E342E);
      case 'Flash Card':
        return const Color(0xFF2196F3);
      case 'Mind Map':
        return const Color(0xFF4CAF50);
      default:
        return Colors.grey;
    }
  }

  IconData _getNoteTypeIcon(String noteType) {
    switch (noteType) {
      case 'Simple Notes':
        return Icons.note;
      case 'Flash Card':
        return Icons.style;
      case 'Mind Map':
        return Icons.account_tree;
      default:
        return Icons.description;
    }
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
  }

  void _showDeleteDialog(Map<String, dynamic> note) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Note',
          style: GoogleFonts.museoModerno(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to delete "${note['fileName']}"?',
          style: GoogleFonts.museoModerno(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.museoModerno()),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteNote(note);
            },
            child: Text(
              'Delete',
              style: GoogleFonts.museoModerno(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
