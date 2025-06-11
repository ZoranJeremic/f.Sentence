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
  final FocusNode _focusNode = FocusNode();

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
          quill.QuillToolbar(
            controller: _controller,
            multiRowsDisplay: false,
            children: [
              const quill.HistoryButton(isUndo: true),
              const quill.HistoryButton(isUndo: false),
              const quill.BoldButton(),
              const quill.ItalicButton(),
              const quill.UnderlineButton(),
              const quill.FontSizeButton(),
              const quill.ListNumbersButton(),
              const quill.ListBulletsButton(),
              quill.ImageButton(
                onImagePickCallback: _onImagePickCallback,
              ),
            ],
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

  void _saveNote() {
    final jsonContent = jsonEncode(_controller.document.toDelta().toJson());
    Navigator.pop(context, jsonContent);
  }

  Future<String> _onImagePickCallback(File file) async {
    return file.path;
  }
}
