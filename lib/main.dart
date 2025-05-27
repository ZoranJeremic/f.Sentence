import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;
  bool _swipeGesturesEnabled = true;
  bool _askBeforeArchive = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt('themeMode') ?? 0;
    final swipeGestures = prefs.getBool('swipeGesturesEnabled') ?? true;
    final askBeforeArchive = prefs.getBool('askBeforeArchive') ?? true;

    setState(() {
      _themeMode = ThemeMode.values[themeIndex];
      _swipeGesturesEnabled = swipeGestures;
      _askBeforeArchive = askBeforeArchive;
    });
  }

  Future<void> _updateThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', mode.index);
    setState(() {
      _themeMode = mode;
    });
  }

  Future<void> _updateSwipeGestures(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('swipeGesturesEnabled', enabled);
    setState(() {
      _swipeGesturesEnabled = enabled;
    });
  }

  Future<void> _updateAskBeforeArchive(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('askBeforeArchive', enabled);
    setState(() {
      _askBeforeArchive = enabled;
    });
  }

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
      themeMode: _themeMode,
      home: HomeScreen(
        swipeGesturesEnabled: _swipeGesturesEnabled,
        askBeforeArchive: _askBeforeArchive,
        onOpenSettings: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => SettingsScreen(
              themeMode: _themeMode,
              swipeGesturesEnabled: _swipeGesturesEnabled,
              askBeforeArchive: _askBeforeArchive,
              onThemeModeChanged: _updateThemeMode,
              onSwipeGesturesChanged: _updateSwipeGestures,
              onAskBeforeArchiveChanged: _updateAskBeforeArchive,
            ),
          ));
        },
      ),
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
  final bool swipeGesturesEnabled;
  final bool askBeforeArchive;
  final VoidCallback onOpenSettings;

  HomeScreen({
    required this.swipeGesturesEnabled,
    required this.askBeforeArchive,
    required this.onOpenSettings,
  });

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

  void _onDelete(Document doc) {
    setState(() {
      documents.remove(doc);
    });
  }

  void _onArchive(Document doc) async {
    if (widget.askBeforeArchive) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Archive Document'),
          content: Text('Are you sure you want to archive "${doc.title}"?'),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text('Cancel')),
            TextButton(onPressed: () => Navigator.of(context).pop(true), child: Text('Archive')),
          ],
        ),
      );
      if (confirm != true) return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Archived "${doc.title}"')),
    );
  }

  Widget _buildDocumentCard(Document doc) {
    return widget.swipeGesturesEnabled
        ? Dismissible(
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
            child: _buildCardContent(doc),
          )
        : _buildCardContent(doc);
  }

  Widget _buildCardContent(Document doc) {
    return Column(
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
          IconButton(icon: Icon(Icons.search), onPressed: () {}),
          IconButton(icon: Icon(Icons.delete), onPressed: () {}),
          IconButton(icon: Icon(Icons.add), onPressed: () => _showPopupMenu(context)),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(child: Text('Settings')),
            ListTile(
              leading: Icon(Icons.color_lens),
              title: Text('Theme Settings'),
              onTap: widget.onOpenSettings,
            ),
            ListTile(
              leading: Icon(Icons.swipe),
              title: Text('Swipe Gestures'),
              onTap: widget.onOpenSettings,
            ),
            ListTile(
              leading: Icon(Icons.archive),
              title: Text('Archive Settings'),
              onTap: widget.onOpenSettings,
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
                        itemBuilder: (context, index) => _buildDocumentCard(documents[index]),
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
  final ThemeMode themeMode;
  final bool swipeGesturesEnabled;
  final bool askBeforeArchive;
  final ValueChanged<ThemeMode> onThemeModeChanged;
  final ValueChanged<bool> onSwipeGesturesChanged;
  final ValueChanged<bool> onAskBeforeArchiveChanged;

  SettingsScreen({
    required this.themeMode,
    required this.swipeGesturesEnabled,
    required this.askBeforeArchive,
    required this.onThemeModeChanged,
    required this.onSwipeGesturesChanged,
    required this.onAskBeforeArchiveChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            title: Text('Theme Mode'),
            subtitle: Text(themeMode == ThemeMode.system
                ? 'System default'
                : themeMode == ThemeMode.light
                    ? 'Light'
                    : 'Dark'),
            onTap: () {
              showDialog<ThemeMode>(
                context: context,
                builder: (context) => SimpleDialog(
                  title: Text('Select Theme Mode'),
                  children: [
                    SimpleDialogOption(
                      child: Text('System'),
                      onPressed: () => Navigator.of(context).pop(ThemeMode.system),
                    ),
                    SimpleDialogOption(
                      child: Text('Light'),
                      onPressed: () => Navigator.of(context).pop(ThemeMode.light),
                    ),
                    SimpleDialogOption(
                      child: Text('Dark'),
                      onPressed: () => Navigator.of(context).pop(ThemeMode.dark),
                    ),
                  ],
                ),
              ).then((value) {
                if (value != null) onThemeModeChanged(value);
              });
            },
          ),
          SwitchListTile(
            title: Text('Enable Swipe Gestures'),
            value: swipeGesturesEnabled,
            onChanged: onSwipeGesturesChanged,
          ),
          SwitchListTile(
            title: Text('Ask Before Archiving'),
            value: askBeforeArchive,
            onChanged: onAskBeforeArchiveChanged,
          ),
        ],
      ),
    );
  }
}