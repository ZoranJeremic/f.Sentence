import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final quill.QuillController _controller = quill.QuillController.basic();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New note'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveNote,
            tooltip: 'Save note',
          )
        ],
      ),
      body: Column(
        children: [
          // Toolbar sa svim bitnim opcijama
          quill.QuillToolbar.basic(
            controller: _controller,
            showAlignmentButtons: true,
            showFontSize: true,
            showCodeBlock: false,
            showBackgroundColorButton: false,
            showInlineCode: false,
            showQuote: false,
            showIndent: true,
            showListNumbers: true,
            showListBullets: true,
            showUnderLineButton: true,
            showStrikeThrough: false,
            showClearFormat: true,
            showHeaderStyle: true,
            showUndo: true,
            showRedo: true,
            showDirection: false,
            showJustifyAlignment: false,
            onImagePickCallback: _onImagePickCallback,
          ),
          // Rich Text Editor
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12.0),
              child: quill.QuillEditor.basic(
                controller: _controller,
                readOnly: false, // Omogućava uređivanje
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Čuva belešku kao JSON i šalje je nazad na prethodni ekran
  void _saveNote() {
    final jsonContent = jsonEncode(_controller.document.toDelta().toJson());
    Navigator.pop(context, jsonContent); // Vraćamo nazad
  }

  // Callback za slike (lokalna putanja slike se koristi)
  Future<String> _onImagePickCallback(File file) async {
    return file.path;
  }
}
