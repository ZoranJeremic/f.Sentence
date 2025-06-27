import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:file_picker/file_picker.dart';
import 'archive.dart';
import 'favorites.dart';
import 'folders.dart';
import 'settings.dart';
import 'trash.dart';
import 'search_bar.dart';
import 'notes_screen.dart';
import 'drawing.dart';
import 'pdf.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox<String>('notes');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return MaterialApp(
          title: 'f.Sentence',
          theme: ThemeData(
            colorScheme: lightDynamic ?? ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: darkDynamic ?? ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark),
            useMaterial3: true,
          ),
          themeMode: ThemeMode.system,
          home: const SplashScreenWrapper(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

// SplashScreenWrapper sa SharedPreferences logikom
class SplashScreenWrapper extends StatefulWidget {
  const SplashScreenWrapper({super.key});

  @override
  State<SplashScreenWrapper> createState() => _SplashScreenWrapperState();
}

class _SplashScreenWrapperState extends State<SplashScreenWrapper> {
  bool _isLoading = true;
  bool _isFirstLaunch = true;

  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    _isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _setFirstLaunchToFalse() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstLaunch', false);
    setState(() {
      _isFirstLaunch = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (_isFirstLaunch) {
      return WelcomeScreen(
        onBegin: _setFirstLaunchToFalse,
      );
    } else {
      return const HomeScreen();
    }
  }
}

class WelcomeScreen extends StatelessWidget {
  final VoidCallback onBegin;

  const WelcomeScreen({super.key, required this.onBegin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              Text(
                'Welcome to f.Sentence!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'More than text editor.',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),
              DropdownButton<String>(
                value: 'English',
                items: const [
                  DropdownMenuItem(value: 'English', child: Text('English')),
                ],
                onChanged: (String? newValue) {
                },
              ),
              const SizedBox(height: 50),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton.icon(
                  onPressed: onBegin,
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Begin'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _documents = [];

  Future<void> _openFilePicker() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        PlatformFile file = result.files.first;
        print('Selected file: ${file.name}, file path: ${file.path}');
      } else {
        print('Deletion cancelled.');
      }
    } catch (e) {
      print('Error while opening file picker: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('f.Sentence', textAlign: TextAlign.center),
        centerTitle: true, 
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchBarWidget()), // Navigacija do SearchBarWidget
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Center(
                child: Text(
                  'f.Sentence',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary, 
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.folder),
              title: const Text('Folders'),
              onTap: () {
                Navigator.pop(context); 
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FolderScreen()), 
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.star),
              title: const Text('Favorites'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FavoritesScreen()), 
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsScreen()), // Navigacija do SettingsScreen
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.storage),
              title: const Text('Storage'),
              onTap: () {
                Navigator.pop(context);
                print('Opening File Manager...');
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Trash'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TrashScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.archive),
              title: const Text('Archive'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ArchiveScreen()), // Navigacija do ArchiveScreen
                );
              },
            ),
          ],
        ),
      ),
      body: _documents.isEmpty
          ? const Center(
              child: Text(
                'Your creations will show up here',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    '${_documents.length} files on your device',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _documents.length,
                    itemBuilder: (context, index) {
                      final docName = _documents[index];
                      return ListTile(
                        leading: const Icon(Icons.insert_drive_file),
                        title: Text(docName), 
                        subtitle: const Text('Created: 2025-06-07'), 
                        trailing: IconButton( 
                          icon: const Icon(Icons.more_vert),
                          onPressed: () {
                            _showFileOptions(context, docName); 
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        spacing: 10,
        spaceBetweenChildren: 8,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.note_add),
            label: 'New note',
            onTap: () {
              print('New note created');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotesScreen(initialTitle: 'New note')),
              );
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.description),
            label: 'New document',
            onTap: () {
              print('New document created');
              setState(() {
                _documents.add('New Document ${DateTime.now().second}'); 
              });
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.brush),
            label: 'New drawing',
            onTap: () {
              print('New drawing created');
               Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DrawingScreen()), // Navigacija do DrawingScreen
              );
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.picture_as_pdf),
            label: 'Annotate PDF',
            onTap: () {
              print('Annotate PDF');
               Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PdfScreen()), 
              );
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.folder_open),
            label: 'Open from storage',
            onTap: () {
              print('Open from storage');
              _openFilePicker(); 
            },
          ),
        ],
      ),
    );
  }

  void _showFileOptions(BuildContext context, String fileName) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Share'),
                onTap: () {
                  Navigator.pop(bc);
                  print('Sharing $fileName');
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Delete'),
                onTap: () {
                  Navigator.pop(bc);
                  _confirmDelete(context, fileName); 
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Rename'),
                onTap: () {
                  Navigator.pop(bc);
                  _renameFile(context, fileName); 
                },
              ),
              ListTile(
                leading: const Icon(Icons.archive),
                title: const Text('Archive'),
                onTap: () {
                  Navigator.pop(bc);
                  _confirmArchive(context, fileName);
                },
              ),
            ],
          ),
        );
      },
    );
  }
  void _confirmDelete(BuildContext context, String fileName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete File?'),
          content: Text('Are you sure you want to delete "$fileName"?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _documents.remove(fileName); 
                  print('File "$fileName" moved to Trash');
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _renameFile(BuildContext context, String oldFileName) {
    TextEditingController _renameController = TextEditingController(text: oldFileName);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Rename File'),
          content: TextField(
            controller: _renameController,
            decoration: const InputDecoration(hintText: "Enter new file name"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Rename'),
              onPressed: () {
                Navigator.of(context).pop();
                final newFileName = _renameController.text.trim();
                if (newFileName.isNotEmpty && newFileName != oldFileName) {
                  setState(() {
                    int index = _documents.indexOf(oldFileName);
                    if (index != -1) {
                      _documents[index] = newFileName; // Ažuriraj ime fajla u listi
                      print('File "$oldFileName" renamed to "$newFileName"');
                    }
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }
  void _confirmArchive(BuildContext context, String fileName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Archive File?'),
          content: Text('Are you sure you want to archive "$fileName"?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Archive'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _documents.remove(fileName);
                  print('File "$fileName" moved to Archive');
                });
              },
            ),
          ],
        );
      },
    );
  }
}
