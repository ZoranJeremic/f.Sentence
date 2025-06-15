import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class NotesScreen extends StatefulWidget {
  final String initialTitle;

  const NotesScreen({Key? key, required this.initialTitle}) : super(key: key);

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  late quill.QuillController _controller;
  late TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _loadNote();
  }

  Future<void> _loadNote() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedContent = prefs.getString('note_content');
    final String? savedTitle = prefs.getString('note_title');

    final doc = savedContent != null
        ? quill.Document.fromJson(jsonDecode(savedContent))
        : quill.Document();

    setState(() {
      _controller = quill.QuillController(
        document: doc,
        selection: const TextSelection.collapsed(offset: 0),
      );

      if (savedTitle != null) {
        _titleController.text = savedTitle;
      }
    });
  }

  Future<void> _saveNote() async {
    final prefs = await SharedPreferences.getInstance();
    final contentJson = jsonEncode(_controller.document.toDelta().toJson());
    await prefs.setString('note_content', contentJson);
    await prefs.setString('note_title', _titleController.text);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Beleška sačuvana!')),
    );
  }

  void _formatText(quill.Attribute attribute) {
    _controller.formatSelection(attribute);
  }

  void _unsetHeader() {
    _controller.formatSelection(quill.Attribute.header.unset);
  }

  @override
  void dispose() {
    _controller.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!mounted || _controller == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _titleController,
          style: const TextStyle(fontSize: 20, color: Colors.white),
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Naslov beleške',
            hintStyle: TextStyle(color: Colors.white54),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          _buildCustomToolbar(),
          const Divider(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: quill.QuillEditor.basic(
                controller: _controller,
                readOnly: false,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomToolbar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.format_bold),
            onPressed: () => _formatText(quill.Attribute.bold),
          ),
          IconButton(
            icon: const Icon(Icons.format_italic),
            onPressed: () => _formatText(quill.Attribute.italic),
          ),
          IconButton(
            icon: const Icon(Icons.format_underline),
            onPressed: () => _formatText(quill.Attribute.underline),
          ),
          IconButton(
            icon: const Icon(Icons.format_strikethrough),
            onPressed: () => _formatText(quill.Attribute.strikeThrough),
          ),
          IconButton(
            icon: const Icon(Icons.format_list_bulleted),
            onPressed: () => _formatText(quill.Attribute.ul),
          ),
          IconButton(
            icon: const Icon(Icons.format_list_numbered),
            onPressed: () => _formatText(quill.Attribute.ol),
          ),
          IconButton(
            icon: const Icon(Icons.title),
            onPressed: () => _formatText(quill.Attribute.h1),
          ),
          IconButton(
            icon: const Icon(Icons.text_fields),
            onPressed: _unsetHeader,
          ),
        ],
      ),
    );
  }
}