import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'dart:convert';

class NotesScreen extends StatefulWidget {
  final String initialTitle;
  const NotesScreen({Key? key, required this.initialTitle}) : super(key: key);

  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  late quill.QuillController _controller;
  bool _isEditingTitle = false;
  late TextEditingController _titleController;

  @override
  void initState() {
    super.initState();

    // Inicijalni prazan dokument
    final doc = quill.Document()..insert(0, ''); 
    _controller = quill.QuillController(document: doc, selection: TextSelection.collapsed(offset: 0));
    _titleController = TextEditingController(text: widget.initialTitle);
  }

  void _toggleEditTitle() {
    setState(() {
      _isEditingTitle = !_isEditingTitle;
      if (!_isEditingTitle) {
        FocusScope.of(context).unfocus();
      }
    });
  }

  void _undo() {
    if (_controller.canUndo) {
      _controller.undo();
    }
  }

  void _redo() {
    if (_controller.canRedo) {
      _controller.redo();
    }
  }

  void _saveNote() {
    // Ovde ide logika za čuvanje beleške, možeš da sačuvaš JSON _controller.document.toDelta().toJson()
    print('Saving note...');
  }

  // Otvori dijalog za ubacivanje slike (samo dummy funkcija ovde)
  void _insertImage() {
    // Implementacija ubacivanja slike ide ovde
    print('Insert image tapped');
  }

  // Widget za naslov sa inline editom
  Widget _buildTitle() {
    if (_isEditingTitle) {
      return SizedBox(
        width: 200,
        child: TextField(
          controller: _titleController,
          autofocus: true,
          decoration: InputDecoration(
            border: UnderlineInputBorder(),
            isDense: true,
          ),
          onSubmitted: (value) => _toggleEditTitle(),
        ),
      );
    }
    return GestureDetector(
      onTap: _toggleEditTitle,
      child: Text(
        _titleController.text,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Toolbar dugmad na dnu ekrana
  Widget _buildBottomToolbar() {
    return Container(
      color: Colors.grey[200],
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
              tooltip: 'Bold',
            ),
            IconButton(
              icon: Icon(Icons.format_italic),
              onPressed: () {
                _controller.formatSelection(quill.Attribute.italic);
              },
              tooltip: 'Italic',
            ),
            IconButton(
              icon: Icon(Icons.format_underline),
              onPressed: () {
                _controller.formatSelection(quill.Attribute.underline);
              },
              tooltip: 'Underline',
            ),
            PopupMenuButton<String>(
              tooltip: 'Headings',
              icon: Icon(Icons.title),
              itemBuilder: (context) => [
                PopupMenuItem(value: 'h1', child: Text('Heading 1')),
                PopupMenuItem(value: 'h2', child: Text('Heading 2')),
                PopupMenuItem(value: 'h3', child: Text('Heading 3')),
                PopupMenuItem(value: 'h4', child: Text('Heading 4')),
                PopupMenuItem(value: 'h5', child: Text('Heading 5')),
                PopupMenuItem(value: 'h6', child: Text('Heading 6')),
              ],
              onSelected: (value) {
                int level = int.parse(value.substring(1));
                _controller.formatSelection(quill.Attribute.header.level(level));
              },
            ),
            IconButton(
              icon: Icon(Icons.image),
              onPressed: _insertImage,
              tooltip: 'Insert Image',
            ),
            IconButton(
              icon: Icon(Icons.format_indent_increase),
              onPressed: () {
                _controller.formatSelection(quill.Attribute.indentL1);
              },
              tooltip: 'Indent',
            ),
            IconButton(
              icon: Icon(Icons.format_list_bulleted),
              onPressed: () {
                _controller.formatSelection(quill.Attribute.ul);
              },
              tooltip: 'Bullet List',
            ),
            IconButton(
              icon: Icon(Icons.format_list_numbered),
              onPressed: () {
                _controller.formatSelection(quill.Attribute.ol);
              },
              tooltip: 'Numbered List',
            ),
          ],
        ),
      ),
    );
  }

  // AppBar sa ikonama i naslovom
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
        tooltip: 'Back',
      ),
      title: _buildTitle(),
      actions: [
        IconButton(
          icon: Icon(Icons.undo),
          onPressed: _undo,
          tooltip: 'Undo',
        ),
        IconButton(
          icon: Icon(Icons.redo),
          onPressed: _redo,
          tooltip: 'Redo',
        ),
        IconButton(
          icon: Icon(Icons.save),
          onPressed: _saveNote,
          tooltip: 'Save',
        ),
        PopupMenuButton<String>(
          icon: Icon(Icons.more_vert),
          itemBuilder: (context) => [
            PopupMenuItem(value: 'delete', child: Text('Delete Note')),
            // Dodaj druge opcije po želji
          ],
          onSelected: (value) {
            if (value == 'delete') {
              // Logika za brisanje beleške
              print('Delete note tapped');
            }
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10),
              child: quill.QuillEditor.basic(
                controller: _controller,
                readOnly: false,
              ),
            ),
          ),
          _buildBottomToolbar(),
        ],
      ),
    );
  }
}