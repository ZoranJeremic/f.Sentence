import 'package:flutter/material.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'f.Sentence',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
      ),

      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
      ),

      themeMode: ThemeMode.system,
      home: HomeScreen(),
    );
  }
}

class Document {
  final String title;
  final DateTime created;
  final DateTime modified;
  Document({
    required this.title,
    required this.created,
    required this.modified,
  });
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Document> documents = [
    Document(
      title: 'First Document',
      created: DateTime(2024, 5, 1, 14, 0),
      modified: DateTime(2024, 5, 10, 16, 30),
    ),
    Document(
      title: 'Second Document',
      created: DateTime(2024, 5, 2, 9, 45),
      modified: DateTime(2024, 5, 11, 10, 15),
    ),
  ];
  int _selectedDrawerIndex = 0;
  void _showPopupMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(leading: Icon(Icons.insert_drive_file), title: Text('Load document from internal storage')),
          ListTile(leading: Icon(Icons.note_add), title: Text('Create new document')),
          ListTile(leading: Icon(Icons.notes), title: Text('New note')),
          ListTile(leading: Icon(Icons.picture_as_pdf), title: Text('Open PDF')),
          ListTile(leading: Icon(Icons.draw), title: Text('New drawing')),
        ],
      ),
    );
  }
  void _showSettings(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => SettingsScreen(),
    ));
  }
  void _onDelete(Document doc) {
    setState(() {
      documents.remove(doc);
    });
  }

  void _onArchive(Document doc) {
 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Archived "${doc.title}"')));
  }
  Widget _buildDocumentCard(Document doc) {
    return Dismissible(
      key: Key(doc.title),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 20),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      secondaryBackground: Container(
        color: Colors.blue,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        child: Icon(Icons.archive, color: Colors.white),
      ),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          _onDelete(doc);
        } else {
          _onArchive(doc);
        }
      },
      child: Column(
        children: [
          ListTile(
            title: Text(doc.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Created: ${doc.created.toString()}'),
                Text('Modified: ${doc.modified.toString()}'),
              ],
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'delete') _onDelete(doc);
                if (value == 'archive') _onArchive(doc);
              },
              itemBuilder: (context) => [
                PopupMenuItem(value: 'delete', child: Text('Delete')),
                PopupMenuItem(value: 'archive', child: Text('Archive')),
                PopupMenuItem(value: 'share', child: Text('Share')),
              ],
            ),
          ),
          Divider(height: 1),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final docCount = documents.length;
    return Scaffold(
      appBar: AppBar(
        title: Text('f.Sentence'),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Search placeholder
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              // Archive/trash
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showPopupMenu(context),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Text('Settings'),
            ),
            ListTile(
              leading: Icon(Icons.color_lens),
              title: Text('Theme Settings'),
              onTap: () => _showSettings(context),
            ),
            ListTile(
              leading: Icon(Icons.swipe),
              title: Text('Swipe Gestures'),
              onTap: () {
                // Will be added
              },
            ),
            ListTile(
              leading: Icon(Icons.archive),
              title: Text('Archive Settings'),
              onTap: () {
                // Will be added
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: documents.isEmpty
            ? Center(child: Text('No documents'))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$docCount documents', style: Theme.of(context).textTheme.titleMedium),
                  SizedBox(height: 16),
                  Expanded(
                    child: Material(
                      elevation: 1,
                      borderRadius: BorderRadius.circular(12),
                      child: ListView.builder(
                        itemCount: documents.length,
                        itemBuilder: (context, index) =>                           _buildDocumentCard(documents[index]),
                      ),
                    ),
                  ),
                ],
              ),
      ),

      floatingActionButton: FloatingActionButton(

        onPressed: () => _showPopupMenu(context),

        child: Icon(Icons.add),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Theme Mode'),
            subtitle: Text('System default'),
            onTap: () {
              // Theme selector
            },
          ),
          ListTile(
            title: Text('Swipe Gestures'),
            subtitle: Text('Enable/Disable swipe'),
            onTap: () {
              // gestures
            },
          ),
          ListTile(
            title: Text('Archive Behavior'),
            subtitle: Text('Ask before archiving'),
            onTap: () {
              // Archive settings
            },
          ),
        ],
      ),
    );
  }
}
