import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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
    _controller = quill.QuillController.basic();
    _titleController = TextEditingController(text: widget.initialTitle);
  }

  @override
  void dispose() {
    _controller.dispose();
    _titleController.dispose();
    super.dispose();
  }

  // Undo i redo - samo pozivaju metode, bez provere
  void _undo() {
    _controller.undo();
  }

  void _redo() {
    _controller.redo();
  }

  // Format header (h1-h6)
  void _setHeader(int level) {
    // level 0 = ukloni header
    if (level == 0) {
      _controller.formatSelection(quill.Attribute.header.unset());
    } else {
      // Za tvoju verziju koristi Attribute.header sa vrednošću level (int)
      _controller.formatSelection(quill.Attribute('header', quill.AttributeScope.BLOCK, level));
    }
  }

  // Ubacivanje slike sa galerije
  Future<void> _insertImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final file = File(picked.path);
      final index = _controller.selection.baseOffset;
      final length = _controller.selection.extentOffset - index;
      _controller.replaceText(index, length, quill.BlockEmbed.image(file.path), null);
    }
  }

  // Toolbar dugmad na dnu
  Widget _buildToolbar() {
    return Container(
      color: Colors.grey.shade200,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.format_bold),
              onPressed: () {
                _controller.formatSelection(quill.Attribute.bold);
              },
            ),
            IconButton(
              icon: Icon(Icons.format_italic),
              onPressed: () {
                _controller.formatSelection(quill.Attribute.italic);
              },
            ),
            IconButton(
              icon: Icon(Icons.format_underline),
              onPressed: () {
                _controller.formatSelection(quill.Attribute.underline);
              },
            ),
            PopupMenuButton<int>(
              onSelected: (level) {
                _setHeader(level);
              },
              itemBuilder: (context) => [
                PopupMenuItem(value: 0, child: Text("Normal")),
                PopupMenuItem(value: 1, child: Text("H1")),
                PopupMenuItem(value: 2, child: Text("H2")),
                PopupMenuItem(value: 3, child: Text("H3")),
                PopupMenuItem(value: 4, child: Text("H4")),
                PopupMenuItem(value: 5, child: Text("H5")),
                PopupMenuItem(value: 6, child: Text("H6")),
              ],
              child: Icon(Icons.title),
              tooltip: "Header nivo",
            ),
            IconButton(
              icon: Icon(Icons.image),
              onPressed: _insertImage,
            ),
            IconButton(
              icon: Icon(Icons.format_indent_increase),
              onPressed: () {
                _controller.formatSelection(quill.Attribute.indentL1);
              },
            ),
            IconButton(
              icon: Icon(Icons.format_list_bulleted),
              onPressed: () {
                _controller.formatSelection(quill.Attribute.ul);
              },
            ),
            IconButton(
              icon: Icon(Icons.format_list_numbered),
              onPressed: () {
                _controller.formatSelection(quill.Attribute.ol);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Rename title dialog
  Future<void> _renameTitleDialog() async {
    final newTitleController = TextEditingController(text: _titleController.text);
    final result = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Preimenuj belešku"),
        content: TextField(
          controller: newTitleController,
          autofocus: true,
          decoration: InputDecoration(hintText: "Unesi novi naziv"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Otkaži")),
          TextButton(onPressed: () => Navigator.pop(context, newTitleController.text), child: Text("Sačuvaj")),
        ],
      ),
    );
    if (result != null && result.isNotEmpty) {
      setState(() {
        _titleController.text = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: GestureDetector(
          onTap: _renameTitleDialog,
          child: Text(
            _titleController.text,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              // TODO: dodaj funkciju za cuvanje
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Beleška sačuvana")));
            },
          ),
          IconButton(
            icon: Icon(Icons.redo),
            onPressed: _redo,
          ),
          IconButton(
            icon: Icon(Icons.undo),
            onPressed: _undo,
          ),
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(child: Text("Opcija 1")),
              PopupMenuItem(child: Text("Opcija 2")),
            ],
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: quill.QuillEditor.basic(
              controller: _controller,
              readOnly: false, // Ovu liniju izbaci ako baca gresku
            ),
          ),
          _buildToolbar(),
        ],
      ),
    );
  }
}