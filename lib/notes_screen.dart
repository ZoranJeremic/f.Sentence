import 'dart:async'; // <- Dodato za Timer
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:path_provider/path_provider.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  late QuillController _controller;
  final FocusNode _focusNode = FocusNode();

  late String _filePath;
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _initFile().then((_) {
      _loadDocument();
    });
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
        final doc = Document.fromJson(jsonDecode(jsonStr));
        _controller = QuillController(
          document: doc,
          selection: const TextSelection.collapsed(offset: 0),
        );
      } catch (e) {
        // Ako nešto nije u redu, kreiraj prazan dokument
        _controller = QuillController.basic();
      }
    } else {
      _controller = QuillController.basic();
    }

    // Slušaj promene da auto-save radi
    _controller.document.changes.listen((event) {
      // Promenjeno: event.source umesto event.item1
      if (event.source == ChangeSource.LOCAL) {
        _autoSave();
      }
    });

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveDocument() async {
    setState(() {
      _isSaving = true;
    });

    final file = File(_filePath);
    final jsonStr = jsonEncode(_controller.document.toDelta().toJson());
    await file.writeAsString(jsonStr);

    setState(() {
      _isSaving = false;
    });
  }

  Timer? _debounce;

  // Auto-save posle kratke pauze da ne čuva svaki karakter posebno
  void _autoSave() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(seconds: 2), () {
      _saveDocument();
    });
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
        title: const Text('Beleške'),
        backgroundColor: Colors.orange,
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
                      const SnackBar(content: Text('Beleške sačuvane')),
                    );
                  },
          ),
        ],
      ),
      body: Column(
        children: [
          QuillToolbar.basic(controller: _controller),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: QuillEditor(
                controller: _controller,
                scrollController: ScrollController(),
                focusNode: _focusNode,
                readOnly: false,
                expands: true,
                padding: EdgeInsets.zero,
                scrollable: true,
                // Uklonjen: autoFocus: true
              ),
            ),
          ),
        ],
      ),
    );
  }
}