import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final quill.QuillController _controller = quill.QuillController.basic();
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New note'),
        actions: [
          IconButton(
            icon: const Icon(Icons.folder_open),
            onPressed: _openNote,
            tooltip: 'Open note',
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveNoteWithDialog,
            tooltip: 'Save note',
          ),
        ],
      ),
      body: Column(
        children: [
          quill.QuillToolbar.basic(
            controller: _controller,
            multiRowsDisplay: false,
            toolbarIconAlignment: WrapAlignment.start,
            showUndo: true,
            showRedo: true,
            showBoldButton: true,
            showItalicButton: true,
            showUnderLineButton: true,
            showFontSize: true,
            showListNumbers: true,
            showListBullets: true,
            showImageButton: true,
            showColorButton: true,
            showBackgroundColorButton: true,
            showHeaderStyle: true,
            onImagePickCallback: _onImagePickCallback,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: quill.QuillEditor(
                controller: _controller,
                scrollController: ScrollController(),
                scrollable: true,
                focusNode: _focusNode,
                autoFocus: true,
                readOnly: false,
                expands: true,
                padding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<String> _onImagePickCallback(File file) async {
    return file.path;
  }

  void _saveNoteWithDialog() async {
    String? fileName = await _askForNoteName();
    if (fileName == null || fileName.trim().isEmpty) return;

    String jsonContent = jsonEncode(_controller.document.toDelta().toJson());
    Directory dir = await getApplicationDocumentsDirectory();
    String path = '${dir.path}/$fileName.json';
    File file = File(path);

    await file.writeAsString(jsonContent);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Note saved as "$fileName.json"')),
      );
      Navigator.pop(context, jsonContent);
    }
  }

  Future<String?> _askForNoteName() async {
    String noteName = '';
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Save note as...'),
          content: TextField(
            autofocus: true,
            onChanged: (value) => noteName = value,
            decoration: const InputDecoration(hintText: 'Enter note name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(noteName),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _openNote() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result != null && result.files.single.path != null) {
      File file = File(result.files.single.path!);
      try {
        String content = await file.readAsString();
        var json = jsonDecode(content);
        var doc = quill.Document.fromJson(json);
        setState(() {
          _controller.document = doc;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Note loaded!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load note')),
        );
      }
    }
  }
}