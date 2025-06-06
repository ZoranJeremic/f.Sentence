import 'package:flutter/material.dart';  
import 'package:dynamic_color/dynamic_color.dart';  
  
void main() => runApp(MyApp());  
  
class MyApp extends StatelessWidget {  
  @override  
  Widget build(BuildContext context) {  
    return DynamicColorBuilder(  
      builder: (lightColorScheme, darkColorScheme) {  
        return MaterialApp(  
          title: 'f.Sentence',  
          theme: ThemeData(  
            useMaterial3: true,  
            colorScheme: lightColorScheme ?? ColorScheme.fromSeed(  
              seedColor: Colors.deepPurple,  
              brightness: Brightness.light,  
            ),  
          ),  
          darkTheme: ThemeData(  
            useMaterial3: true,  
            colorScheme: darkColorScheme ?? ColorScheme.fromSeed(  
              seedColor: Colors.deepPurple,  
              brightness: Brightness.dark,  
            ),  
          ),  
          themeMode: ThemeMode.system,  
          home: HomeScreen(),  
        );  
      },  
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
      title: 'Placeholder document N⁰.1',  
      created: DateTime(2024, 5, 1, 14, 0),  
      modified: DateTime(2024, 5, 10, 16, 30),  
    ),  
    Document(  
      title: 'Placeholder document N⁰.2',  
      created: DateTime(2024, 5, 2, 9, 45),  
      modified: DateTime(2024, 5, 11, 10, 15),  
    ),  
  ];  
  
  void _showPopupMenu(BuildContext context) {  
    showModalBottomSheet(  
      context: context,  
      builder: (_) => Column(  
        mainAxisSize: MainAxisSize.min,  
        children: [  
          ListTile(leading: Icon(Icons.note_add), title: Text('New note')),  
          ListTile(leading: Icon(Icons.picture_as_pdf), title: Text('Open PDF')),  
          ListTile(leading: Icon(Icons.draw), title: Text('New drawing')),
          ListTile(title: Text('New drawing'))  
        ],  
      ),  
    );  
  }  
  
  void _showSnackBar(String message) {  
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));  
  }  
  
  void _onDelete(Document doc) {  
    setState(() {  
      documents.remove(doc);  
    });  
    _showSnackBar('Deleted "${doc.title}"');  
  }  
  
  void _onArchive(Document doc) {  
    _showSnackBar('Archived "${doc.title}"');  
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
      child: ListTile(  
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
            PopupMenuItem(value: 'rename',
child: Text('Rename')),  
          ],  
        ),  
      ),  
    );  
  }  
  
  @override  
  Widget build(BuildContext context) {  
    final docCount = documents.length;  
    return Scaffold(  
      appBar: AppBar(  
        title: Text('f.Sentence'),  
        centerTitle: false,  
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
            icon: Icon(Icons.add),  
            onPressed: () => _showPopupMenu(context),  
          ),  
        ],  
      ),  
      drawer: Drawer(  
        child: ListView(  
          children: [  
            DrawerHeader(  
              decoration: BoxDecoration(  
                color: Theme.of(context).colorScheme.primaryContainer,  
              ),  
              child: Center(  
                child: Text(  
                  'f.Sentence',  
                  style: Theme.of(context).textTheme.titleLarge,  
                ),  
              ),  
            ),  
            ListTile(  
              leading: Icon(Icons.folder),  
              title: Text('Your documents'),  
              onTap: () {  
                Navigator.pop(context);  
              },  
            ),  
            ListTile(  
              leading: Icon(Icons.star),  
              title: Text('Starred'),  
              onTap: () {},  
            ),  
            ListTile(  
              leading: Icon(Icons.folder_special),  
              title: Text('Folders'),  
              onTap: () {},  
            ),  
            ListTile(  
              leading: Icon(Icons.archive),  
              title: Text('Archive'),  
              onTap: () {},  
            ),  
            ListTile(  
              leading: Icon(Icons.delete),  
              title: Text('Trash'),  
              onTap: () {},  
            ),  
            ListTile(  
              leading: Icon(Icons.settings),  
              title: Text('Settings'),  
              onTap: () => Navigator.of(context).push(  
                MaterialPageRoute(builder: (_) => SettingsScreen()),  
              ),  
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
                    child: ListView.builder(  
                      itemCount: documents.length,  
                      itemBuilder: (context, index) => _buildDocumentCard(documents[index]),  
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
    final colorScheme = Theme.of(context).colorScheme;  
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
            title: Text('Accent Color'),  
            subtitle: Text('Pick your favorite'),  
            onTap: () {  
              // Color picker  
            },  
          ),  
        ],  
      ),  
    );  
  }  
}