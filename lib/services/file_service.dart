import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FileService {
  static const String _savedNotesKey = 'saved_notes';

  /// Save notes content to a file in the app's documents directory
  static Future<bool> saveNotesToFile({
    required String fileName,
    required String content,
    required String noteType, // 'Simple Notes', 'Flash Card', 'Mind Map'
  }) async {
    try {
      // Get the documents directory
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final String notesDir = '${appDocDir.path}/SAInapse_Notes';

      // Create the notes directory if it doesn't exist
      final Directory notesDirectory = Directory(notesDir);
      if (!await notesDirectory.exists()) {
        await notesDirectory.create(recursive: true);
      }

      // Create a subdirectory for the note type
      final String typeDir = '${notesDir}/$noteType';
      final Directory typeDirectory = Directory(typeDir);
      if (!await typeDirectory.exists()) {
        await typeDirectory.create(recursive: true);
      }

      // Generate filename with timestamp
      final DateTime now = DateTime.now();
      final String timestamp =
          '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}_${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}';
      final String baseFileName = fileName.split('.').first;
      final String fileExtension = noteType == 'Simple Notes' ? 'txt' : 'json';
      final String finalFileName = '${baseFileName}_$timestamp.$fileExtension';

      // Create the file
      final File file = File('$typeDir/$finalFileName');

      // Prepare content based on note type
      String fileContent;
      if (noteType == 'Simple Notes') {
        fileContent = content;
      } else {
        // For Flash Cards and Mind Maps, save as JSON
        final Map<String, dynamic> noteData = {
          'fileName': fileName,
          'noteType': noteType,
          'content': content,
          'createdAt': now.toIso8601String(),
          'timestamp': timestamp,
        };
        fileContent = jsonEncode(noteData);
      }

      // Write content to file
      await file.writeAsString(fileContent);

      // Save file info to SharedPreferences for tracking
      await _saveFileInfo(finalFileName, noteType, now);

      return true;
    } catch (e) {
      print('Error saving file: $e');
      return false;
    }
  }

  /// Save file information to SharedPreferences
  static Future<void> _saveFileInfo(
    String fileName,
    String noteType,
    DateTime createdAt,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? existingData = prefs.getString(_savedNotesKey);

      List<Map<String, dynamic>> savedNotes = [];
      if (existingData != null) {
        final List<dynamic> decoded = jsonDecode(existingData);
        savedNotes = decoded.cast<Map<String, dynamic>>();
      }

      savedNotes.add({
        'fileName': fileName,
        'noteType': noteType,
        'createdAt': createdAt.toIso8601String(),
        'filePath': 'SAInapse_Notes/$noteType/$fileName',
      });

      await prefs.setString(_savedNotesKey, jsonEncode(savedNotes));
    } catch (e) {
      print('Error saving file info: $e');
    }
  }

  /// Get list of saved notes
  static Future<List<Map<String, dynamic>>> getSavedNotes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? data = prefs.getString(_savedNotesKey);

      if (data == null) return [];

      final List<dynamic> decoded = jsonDecode(data);
      return decoded.cast<Map<String, dynamic>>();
    } catch (e) {
      print('Error getting saved notes: $e');
      return [];
    }
  }

  /// Get the notes directory path
  static Future<String> getNotesDirectoryPath() async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    return '${appDocDir.path}/SAInapse_Notes';
  }

  /// Check if a file exists
  static Future<bool> fileExists(String filePath) async {
    try {
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final File file = File('${appDocDir.path}/$filePath');
      return await file.exists();
    } catch (e) {
      return false;
    }
  }

  /// Delete a saved note
  static Future<bool> deleteNote(String filePath) async {
    try {
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final File file = File('${appDocDir.path}/$filePath');

      if (await file.exists()) {
        await file.delete();

        // Remove from SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        final String? data = prefs.getString(_savedNotesKey);

        if (data != null) {
          final List<dynamic> decoded = jsonDecode(data);
          final List<Map<String, dynamic>> savedNotes = decoded
              .cast<Map<String, dynamic>>();

          savedNotes.removeWhere((note) => note['filePath'] == filePath);
          await prefs.setString(_savedNotesKey, jsonEncode(savedNotes));
        }

        return true;
      }
      return false;
    } catch (e) {
      print('Error deleting file: $e');
      return false;
    }
  }
}
