import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill_toolbar/flutter_quill_toolbar.dart';
import 'package:path_provider/path_provider.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  late quill.QuillController _controller;
  final FocusNode _focusNode = FocusNode();
  late String _filePath;
  bool _isLoading = true;
  bool _isSaving = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _initFile().then((_) => _loadDocument());
  }

  Future<void> _initFile() async {
    final dir = await getApplicationDocumentsDirectory();
    _filePath = '${dir.path}/notes.json';
  }

  Future<void> _loadDocument() async {
    final file = File(_filePath);
    if (await file.exists()) {
      try {
        final jsonStr = await file.readAsString();
        final doc = quill.Document.fromJson(jsonDecode(jsonStr));
        _controller = quill.QuillController(
          document: doc,
          selection: const TextSelection.collapsed(offset: 0),
        );
      } catch (_) {
        _controller = quill.QuillController.basic();
      }
    } else {
      _controller = quill.QuillController.basic();
    }

    _controller.addListener(_onEditorChanged);

    setState(() => _isLoading = false);
  }

  void _onEditorChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 2), _saveDocument);
  }

  Future<void> _saveDocument() async {
    setState(() => _isSaving = true);
    final file = File(_filePath);
    final jsonStr = jsonEncode(_controller.document.toDelta().toJson());
    await file.writeAsString(jsonStr);
    setState(() => _isSaving = false);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
          IconButton(
            icon: _isSaving
                ? const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.save),
            onPressed: _isSaving
                ? null
                : () async {
                    await _saveDocument();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Notes saved')),
                    );
                  },
          ),
        ],
      ),
      body: Column(
        children: [
          quill.QuillToolbar.basic(controller: _controller),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: quill.QuillEditor.basic(
                controller: _controller,
                focusNode: _focusNode,
                scrollController: ScrollController(),
                readOnly: false,
                expands: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
