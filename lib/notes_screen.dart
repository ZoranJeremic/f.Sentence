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
  quill.QuillController? _controller;
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
    if (_controller == null) return;
    final prefs = await SharedPreferences.getInstance();
    final contentJson = jsonEncode(_controller!.document.toDelta().toJson());
    await prefs.setString('note_content', contentJson);
    await prefs.setString('note_title', _titleController.text);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Beleška je sačuvana!')),
    );
  }

  void _createNewNote() {
    setState(() {
      _controller = quill.QuillController.basic();
      _titleController.text = '';
    });
  }

  void _formatText(quill.Attribute attribute) {
    if (_controller == null) return;
    _controller!.formatSelection(attribute);
  }

  void _unsetHeader() {
    if (_controller == null) return;
    _controller!.formatSelection(quill.Attribute.header);
  }

  @override
  void dispose() {
    _controller?.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _titleController,
          style: TextStyle(
            fontSize: 20,
            color: isDark ? Colors.white : Colors.black,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Naslov beleške',
            hintStyle: TextStyle(
              color: isDark ? Colors.white54 : Colors.black54,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveNote,
          ),
          IconButton(
            icon: const Icon(Icons.note_add),
            tooltip: "Nova beleška",
            onPressed: _createNewNote,
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: quill.QuillEditor.basic(
                controller: _controller!,
                readOnly: false,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: _buildCustomToolbar(),
      ),
    );
  }

  Widget _buildCustomToolbar() {
    return Material(
      color: Theme.of(context).bottomAppBarColor,
      elevation: 4,
      child: SingleChildScrollView(
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
      ),
    );
  }
}