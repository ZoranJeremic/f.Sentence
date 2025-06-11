import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  late QuillController _controller;
  final FocusNode _focusNode = FocusNode();
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _controller = QuillController.basic();
  }

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
          QuillToolbar(
            controller: _controller,
            children: [
              UndoButton(controller: _controller),
              RedoButton(controller: _controller),
              ToggleStyleButton(
                attribute: Attribute.bold,
                icon: Icons.format_bold,
                controller: _controller,
              ),
              ToggleStyleButton(
                attribute: Attribute.italic,
                icon: Icons.format_italic,
                controller: _controller,
              ),
              ToggleStyleButton(
                attribute: Attribute.underline,
                icon: Icons.format_underline,
                controller: _controller,
              ),
              SelectHeaderStyleButton(controller: _controller),
              SelectFontSizeButton(controller: _controller),
              ColorButton(
                icon: Icons.format_color_text,
                background: false,
                controller: _controller,
              ),
              ColorButton(
                icon: Icons.format_color_fill,
                background: true,
                controller: _controller,
              ),
              ImageButton(
                controller: _controller,
                imageSource: ImageSource.gallery,
                onImagePickCallback: _onImagePickCallback,
              ),
              ListNumbersButton(controller: _controller),
              ListBulletsButton(controller: _controller),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: QuillEditor(
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
    final appDocDir = await getApplicationDocumentsDirectory();
    final copiedFile = await file.copy('${appDocDir.path}/${file.path.split('/').last}');
    return copiedFile.path;
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
        var doc = Document.fromJson(json);
        setState(() {
          _controller = QuillController(document: doc, selection: const TextSelection.collapsed(offset: 0));
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