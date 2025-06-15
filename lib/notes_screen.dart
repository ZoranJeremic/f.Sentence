import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:image_picker/image_picker.dart';

class NotesScreen extends StatefulWidget {
  final String initialTitle;
  const NotesScreen({Key? key, required this.initialTitle}) : super(key: key);

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  late quill.QuillController _controller;
  final FocusNode _focusNode = FocusNode();
  late TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);

    _controller = quill.QuillController.basic();

    // Možeš da učitaš dokument iz baze ili fajla ovde ako hoćeš
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _titleController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _setHeader(int level) {
    if (level == 0) {
      _controller.formatSelection(quill.Attribute.header);
    } else {
      _controller.formatSelection(quill.Attribute('header', quill.AttributeScope.BLOCK, level));
      // Ako ti AttributeScope.BLOCK pravi problem, probaj ovako:
      // _controller.formatSelection(quill.Attribute('header', level));
    }
  }

  Future<void> _insertImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final String imageUrl = image.path;
      final index = _controller.selection.baseOffset;
      _controller.document.insert(index, '\n');
      _controller.formatSelection(quill.Attribute.embed);
      _controller.document.insert(index + 1, quill.BlockEmbed.image(imageUrl));
    }
  }

  Widget _buildToolbar() {
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
              icon: Icon(Icons.title),
              onSelected: (value) {
                _setHeader(value);
              },
              itemBuilder: (context) => [
                PopupMenuItem(value: 0, child: Text('Normal')),
                PopupMenuItem(value: 1, child: Text('H1')),
                PopupMenuItem(value: 2, child: Text('H2')),
                PopupMenuItem(value: 3, child: Text('H3')),
                PopupMenuItem(value: 4, child: Text('H4')),
                PopupMenuItem(value: 5, child: Text('H5')),
                PopupMenuItem(value: 6, child: Text('H6')),
              ],
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: GestureDetector(
          onTap: () async {
            final newTitle = await showDialog<String>(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Preimenuj belešku'),
                content: TextField(
                  controller: _titleController,
                  decoration: InputDecoration(hintText: 'Unesi novi naziv'),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, null),
                    child: Text('Otkaži'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, _titleController.text),
                    child: Text('Sačuvaj'),
                  ),
                ],
              ),
            );
            if (newTitle != null && newTitle.isNotEmpty) {
              setState(() {
                _titleController.text = newTitle;
              });
            }
          },
          child: Text(
            _titleController.text,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              // ovde implementiraj čuvanje beleške
            },
          ),
          IconButton(
            icon: Icon(Icons.redo),
            onPressed: () {
              _controller.redo();
            },
          ),
          IconButton(
            icon: Icon(Icons.undo),
            onPressed: () {
              _controller.undo();
            },
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(child: Text('Opcija 1')),
              PopupMenuItem(child: Text('Opcija 2')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: quill.QuillEditor.basic(
              controller: _controller,
              readOnly: false, // U ovoj verziji možda treba da izbaciš ovo ako baca grešku, ali probaj prvo ovako
            ),
          ),
          _buildToolbar(),
        ],
      ),
    );
  }
}