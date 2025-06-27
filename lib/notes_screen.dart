import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'dart:io';

class NotesScreen extends StatefulWidget {
  Color _getColor(String key) {
  final attrs = _controller.getSelectionStyle().attributes;
  return attrs.containsKey(key) ? Colors.blue : Colors.black;
}

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
    _controller.document.insert(index, 'New note');
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
            child: quill.QuillEditor(
              controller: _controller,
              focusNode: _editorFocusNode,
              scrollController: ScrollController(),
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
              IconButton(
  icon: const Icon(Icons.format_bold),
  onPressed: () {
    final attrs = _controller.getSelectionStyle().attributes;
    if (attrs.containsKey(quill.Attribute.bold.key)) {
      _controller.formatSelection(quill.Attribute.clone(quill.Attribute.bold, null));
    } else {
      _controller.formatSelection(quill.Attribute.bold);
    }
  },
),
              IconButton(
  icon: Icon(Icons.format_italic, color: _getColor(quill.Attribute.italic.key)),
  onPressed: () {
    final isItalic = attrs.containsKey(quill.Attribute.italic.key);
    _controller.formatSelection(
      isItalic ? quill.Attribute.clone(quill.Attribute.italic, null) : quill.Attribute.italic,
    );
  },
),
              IconButton(
  icon: Icon(Icons.format_underline, color: _getColor(quill.Attribute.underline.key)),
  onPressed: () {
    final isUnderline = attrs.containsKey(quill.Attribute.underline.key);
    _controller.formatSelection(
      isUnderline ? quill.Attribute.clone(quill.Attribute.underline, null) : quill.Attribute.underline,
    );
  },
),
              IconButton(
  icon: Icon(Icons.title, color: _getColor(quill.Attribute.h1.key)),
  onPressed: () {
    final isH1 = attrs.containsKey(quill.Attribute.h1.key);
    _controller.formatSelection(
      isH1 ? quill.Attribute.clone(quill.Attribute.h1, null) : quill.Attribute.h1,
    );
  },
),
              IconButton(
  icon: Icon(Icons.title_outlined, color: _getColor(quill.Attribute.h2.key)),
  onPressed: () {
    final isH2 = attrs.containsKey(quill.Attribute.h2.key);
    _controller.formatSelection(
      isH2 ? quill.Attribute.clone(quill.Attribute.h2, null) : quill.Attribute.h2,
    );
  },
),
              IconButton(
  icon: Icon(Icons.format_list_bulleted, color: _getColor(quill.Attribute.ul.key)),
  onPressed: () {
    final isUl = attrs.containsKey(quill.Attribute.ul.key);
    _controller.formatSelection(
      isUl ? quill.Attribute.clone(quill.Attribute.ul, null) : quill.Attribute.ul,
    );
  },
),
              IconButton(
  icon: Icon(Icons.format_list_numbered, color: _getColor(quill.Attribute.ol.key)),
  onPressed: () {
    final isOl = attrs.containsKey(quill.Attribute.ol.key);
    _controller.formatSelection(
      isOl ? quill.Attribute.clone(quill.Attribute.ol, null) : quill.Attribute.ol,
    );
  },
),
              IconButton(
  icon: Icon(Icons.check_box, color: _getColor(quill.Attribute.unchecked.key)),
  onPressed: () {
    final isCheck = attrs.containsKey(quill.Attribute.unchecked.key);
    _controller.formatSelection(
      isCheck ? quill.Attribute.clone(quill.Attribute.unchecked, null) : quill.Attribute.unchecked,
    );
  },
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
  onPressed: _pickAndInsertImage,
              ),
            ],
          ),
        ),
      ),
    );
  }
}