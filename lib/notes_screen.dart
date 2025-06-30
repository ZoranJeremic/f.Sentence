import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill/flutter_quill.dart'
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class NotesScreen extends StatefulWidget {
  final String initialTitle;
  final quill.Document? initialDoc;

  const NotesScreen({
    Key? key,
    required this.initialTitle,
    this.initialDoc,
  }) : super(key: key);

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  late quill.QuillController _controller;
  late TextEditingController _titleController;
  final FocusNode _editorFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // Inicijalizacija kontrolera za naslov i za Quill editor
    _titleController = TextEditingController(text: widget.initialTitle);
    _controller = quill.QuillController(
      document: widget.initialDoc ?? quill.Document(),
      selection: const TextSelection.collapsed(offset: 0),
    );

    _controller.addListener(_autoSave);
    _requestStoragePermission();
  }

  Future<void> _requestStoragePermission() async {
    await Permission.storage.request();
  }

  void _autoSave() async {
  final box = Hive.box<String>('notes');
  await box.put(
    _titleController.text,
    jsonEncode(_controller.document.toDelta().toJson()),
  );
  debugPrint("Autosave saved your note named: ${_titleController.text}");
  }

  // Toggle stilizacije — ovo radi on/off za format
  void _toggleAttribute(quill.Attribute attr) {
    final attrs = _controller.getSelectionStyle().attributes;
    if (attrs.containsKey(attr.key)) {
      _controller.formatSelection(quill.Attribute.clone(attr, null)); // poništi
    } else {
      _controller.formatSelection(attr); // uključi
    }
  }

  // Dobij boju dugmeta (plava ako je aktivno, crna ako nije)
  Color _getColor(String key) {
    final attrs = _controller.getSelectionStyle().attributes;
    return attrs.containsKey(key) ? Colors.blue : Colors.black;
  }

  // Ubacivanje slike kao pravi embed, ne samo tekst
  void _pickAndInsertImage() async {
    final picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage == null) return;

    final file = File(pickedImage.path);
    final imageUrl = await _uploadImage(file);

    final index = _controller.selection.baseOffset;
    // Ubaci embed za sliku na trenutnu poziciju kursora
    _controller.document.insert(index, '\n'); // novi red pre slike
    _controller.document.insert(index, {'image': imageUrl});
    _controller.document.insert(index + 1, '\n');
    _controller.updateSelection(
    TextSelection.collapsed(offset: index + 2),
    ChangeSource.local,
    );
  }


  Future<String> _uploadImage(File file) async {
    // Za sad samo vraćamo lokalni path, možeš kasnije uploadovati na server
    return file.path;
  }

  void _renameNote() async {
    final newTitle = await showDialog<String>(
      context: context,
      builder: (_) {
        final renameController = TextEditingController(text: _titleController.text);
        return AlertDialog(
          title: const Text('Rename'),
          content: TextField(controller: renameController),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, renameController.text),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (newTitle != null && newTitle.trim().isNotEmpty) {
      setState(() {
        _titleController.text = newTitle.trim();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: _renameNote,
          child: Text(
            _titleController.text.isEmpty ? 'Bez naslova' : _titleController.text,
            style: const TextStyle(fontSize: 18),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12), 
              child: quill.QuillEditor(
                controller: _controller,
                focusNode: _editorFocusNode,
                scrollController: ScrollController(),
                placeholderText: 'Tap here to start typing...',
                expands: true,
                autoFocus: true,
                scrollable: true,
              ),
            ),
          ),
          if (isKeyboardOpen) _buildToolbar(),
        ],
      ),
    );
  }

  Widget _buildToolbar() {
    return SafeArea(
      child: Container(
        color: Colors.grey[100],
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              // Bold dugme — toggle
              IconButton(
                icon: Icon(Icons.format_bold, color: _getColor(quill.Attribute.bold.key)),
                onPressed: () => _toggleAttribute(quill.Attribute.bold),
              ),
              // Italic dugme — toggle
              IconButton(
                icon: Icon(Icons.format_italic, color: _getColor(quill.Attribute.italic.key)),
                onPressed: () => _toggleAttribute(quill.Attribute.italic),
              ),
              // Underline dugme — toggle
              IconButton(
                icon: Icon(Icons.format_underline, color: _getColor(quill.Attribute.underline.key)),
                onPressed: () => _toggleAttribute(quill.Attribute.underline),
              ),
              // Heading 1
              IconButton(
                icon: Icon(Icons.title, color: _getColor(quill.Attribute.h1.key)),
                onPressed: () => _toggleAttribute(quill.Attribute.h1),
              ),
              // Heading 2
              IconButton(
                icon: Icon(Icons.title_outlined, color: _getColor(quill.Attribute.h2.key)),
                onPressed: () => _toggleAttribute(quill.Attribute.h2),
              ),
              // Bullet list
              IconButton(
                icon: Icon(Icons.format_list_bulleted, color: _getColor(quill.Attribute.ul.key)),
                onPressed: () => _toggleAttribute(quill.Attribute.ul),
              ),
              // Numbered list
              IconButton(
                icon: Icon(Icons.format_list_numbered, color: _getColor(quill.Attribute.ol.key)),
                onPressed: () => _toggleAttribute(quill.Attribute.ol),
              ),
              // Checkbox
              IconButton(
                icon: Icon(Icons.check_box, color: _getColor(quill.Attribute.unchecked.key)),
                onPressed: () => _toggleAttribute(quill.Attribute.unchecked),
              ),
              // Undo
              IconButton(
                icon: const Icon(Icons.undo),
                onPressed: () => _controller.undo(),
              ),
              // Redo
              IconButton(
                icon: const Icon(Icons.redo),
                onPressed: () => _controller.redo(),
              ),
              // Insert image
              IconButton(
                icon: const Icon(Icons.image),
                onPressed: _pickAndInsertImage,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
