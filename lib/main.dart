import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // Definišemo osnovne **Frutiger Aero** boje
  final Color aeroPrimary = Color(0xFF00BFFF); // Svetlo plava
  final Color aeroSecondary = Color(0xFFB0E0E6); // Plavičasto bela
  final Color aeroAccent = Color(0xFF40E0D0); // Tirkizna
  final Color aeroBackground = Color(0xFFE0FFFF); // Svetlo plava pozadina
  final Color aeroSurface = Color(0xFFFFFFFF); // Bela površina

  // Boje za tamni režim
  final Color aeroDarkPrimary = Color(0xFF009ACD); // Tamno plava
  final Color aeroDarkBackground = Color(0xFF121212); // Skoro crna
  final Color aeroDarkSurface = Color(0xFF1E1E1E); // Tamna površina

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'f.Sentence',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: aeroPrimary,
          onPrimary: Colors.white,
          secondary: aeroSecondary,
          onSecondary: Colors.black,
          background: aeroBackground,
          onBackground: Colors.black,
          surface: aeroSurface,
          onSurface: Colors.black,
          error: Colors.redAccent,
          onError: Colors.white,
        ),
        scaffoldBackgroundColor: aeroBackground,
        appBarTheme: AppBarTheme(
          backgroundColor: aeroPrimary,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: aeroAccent,
          foregroundColor: Colors.black,
        ),
        textTheme: ThemeData.light().textTheme.apply(
              fontFamily: 'Frutiger',
              bodyColor: Colors.black87,
              displayColor: Colors.black87,
            ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: aeroDarkPrimary,
          onPrimary: Colors.white,
          secondary: aeroAccent,
          onSecondary: Colors.black,
          background: aeroDarkBackground,
          onBackground: Colors.white,
          surface: aeroDarkSurface,
          onSurface: Colors.white,
          error: Colors.redAccent,
          onError: Colors.white,
        ),
        scaffoldBackgroundColor: aeroDarkBackground,
        appBarTheme: AppBarTheme(
          backgroundColor: aeroDarkPrimary,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: aeroAccent,
          foregroundColor: Colors.black,
        ),
        textTheme: ThemeData.dark().textTheme.apply(
              fontFamily: 'Frutiger',
              bodyColor: Colors.white,
              displayColor: Colors.white,
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

  void _showPopupMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.note_add, color: Theme.of(context).colorScheme.primary),
            title: Text('New note'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.picture_as_pdf, color: Theme.of(context).colorScheme.primary),
            title: Text('Open PDF'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.draw, color: Theme.of(context).colorScheme.primary),
            title: Text('New drawing'),
            onTap: () {},
          ),
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
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(doc.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Created: ${doc.created}'),
            Text('Modified: ${doc.modified}'),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final docCount = documents.length;
    return Scaffold(
      appBar: AppBar(
        title: Text('f.Sentence'),
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
              onTap: () => Navigator.pop(context),
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