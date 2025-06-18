import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
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

  void _autoSave() {
    // OVDE će ići logika za čuvanje u bazu (u sledećem koraku)
    debugPrint("Autosave triggered. Title: ${_titleController.text}");
  }

  void _addImage() async {
    final picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage == null) return;

    final file = File(pickedImage.path);
    final imageUrl = await _uploadImage(file);

    final index = _controller.selection.baseOffset;
    _controller.document.insert(index, "\n");
    _controller.formatSelection(quill.Attribute.embed);
    _controller.document.insert(index + 1, {
      "insert": {
        "image": imageUrl,
      }
    });
  }

  Future<String> _uploadImage(File file) async {
    // Placeholder — u budućnosti ćeš ovo povezati sa lokalnim skladištem
    return file.path;
  }

  void _renameNote() async {
    final newTitle = await showDialog<String>(
      context: context,
      builder: (_) {
        final renameController = TextEditingController(text: _titleController.text);
        return AlertDialog(
          title: const Text('Preimenuj belešku'),
          content: TextField(controller: renameController),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text('Otkaži'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, renameController.text),
              child: const Text('Sačuvaj'),
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
            child: quill.QuillEditor(
              controller: _controller,
              scrollController: ScrollController(),
              scrollable: true,
              focusNode: _editorFocusNode,
              autoFocus: true,
              readOnly: false,
              expands: false,
              padding: const EdgeInsets.all(12),
              placeholder: 'Počni da pišeš...',
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
        padding: const EdgeInsets.symmetric(vertical: 8),
        color: Colors.grey[100],
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.format_bold),
                onPressed: () => _controller.formatSelection(quill.Attribute.bold),
              ),
              IconButton(
                icon: const Icon(Icons.format_italic),
                onPressed: () => _controller.formatSelection(quill.Attribute.italic),
              ),
              IconButton(
                icon: const Icon(Icons.format_underline),
                onPressed: () => _controller.formatSelection(quill.Attribute.underline),
              ),
              IconButton(
                icon: const Icon(Icons.title),
                onPressed: () => _controller.formatSelection(quill.Attribute.h1),
              ),
              IconButton(
                icon: const Icon(Icons.format_list_bulleted),
                onPressed: () => _controller.formatSelection(quill.Attribute.ul),
              ),
              IconButton(
                icon: const Icon(Icons.format_list_numbered),
                onPressed: () => _controller.formatSelection(quill.Attribute.ol),
              ),
              IconButton(
                icon: const Icon(Icons.check_box),
                onPressed: () => _controller.formatSelection(quill.Attribute.unchecked),
              ),
              IconButton(
                icon: const Icon(Icons.undo),
                onPressed: () => _controller.undo(),
              ),
              IconButton(
                icon: const Icon(Icons.redo),
                onPressed: () => _controller.redo(),
              ),
              IconButton(
                icon: const Icon(Icons.image),
                onPressed: _addImage,
              ),
            ],
          ),
        ),
      ),
    );
  }
}