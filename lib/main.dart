import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'welcome_screen.dart';
import 'folders.dart';
import 'favorites.dart';
import 'settings.dart';
import 'trash.dart';
import 'archive.dart';
import 'search_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

  runApp(MyApp(isFirstLaunch: isFirstLaunch));
}

class MyApp extends StatelessWidget {
  final bool isFirstLaunch;

  const MyApp({super.key, required this.isFirstLaunch});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return MaterialApp(
          title: 'f.Sentence',
          theme: ThemeData(
            colorScheme: lightDynamic ?? ColorScheme.fromSeed(seedColor: Colors.deepOrange),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: darkDynamic ?? ColorScheme.fromSeed(seedColor: Colors.deepOrange, brightness: Brightness.dark),
            useMaterial3: true,
          ),
          themeMode: ThemeMode.system,
          home: isFirstLaunch ? const WelcomeScreen() : const HomePage(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool hasDocuments = false; // Placeholder, kasnije dinamički
  int fileCount = 0; // Broj fajlova (dummy za sad)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DrawerHeader(
                child: Center(
                  child: Text(
                    'f.Sentence',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.folder),
                title: const Text('Folders'),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FolderScreen())),
              ),
              ListTile(
                leading: const Icon(Icons.star),
                title: const Text('Favorites'),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoritesScreen())),
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
              ),
              ListTile(
                leading: const Icon(Icons.storage),
                title: const Text('Storage'),
                onTap: () {
                  // TODO: Dodati logiku za otvaranje File Explorer-a zavisno od OS-a
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Trash'),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TrashScreen())),
              ),
              ListTile(
                leading: const Icon(Icons.archive),
                title: const Text('Archive'),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ArchiveScreen())),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text(
          'f.Sentence',
          textAlign: TextAlign.center,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchBarWidget()));
            },
          ),
        ],
      ),
      body: hasDocuments ? _buildFileList() : _buildEmptyState(),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text(
        'Your creations will show up here',
        style: TextStyle(fontSize: 16),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildFileList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            '$fileCount files on your device',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        // TODO: Dodati ListView za fajlove
      ],
    );
  }
}