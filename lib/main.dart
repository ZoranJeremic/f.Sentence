import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:file_picker/file_picker.dart';

// Ispravljene putanje za import fajlove (pretpostavka da su SVI fajlovi direktno u lib folderu)
import 'archive.dart';
import 'favorites.dart';
import 'folders.dart';
import 'settings.dart';
import 'trash.dart';
import 'search_bar.dart'; // Npr. klasa SearchBarWidget
import 'notes_screen.dart'; // Npr. klasa NotesScreen
import 'drawing.dart'; // Npr. klasa DrawingScreen
import 'pdf.dart'; // Npr. klasa PdfScreen


void main() {
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
  bool _isFirstLaunch = true; // Pretpostavljamo da je prvo pokretanje dok ne proverimo

  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    // Ako 'isFirstLaunch' nije postavljen, podrazumeva se true
    _isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

    setState(() {
      _isLoading = false; // Gotovo učitavanje, UI može da se prikaže
    });
  }

  Future<void> _setFirstLaunchToFalse() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstLaunch', false); // Snimi da nije više prvo pokretanje
    setState(() {
      _isFirstLaunch = false; // Ažuriraj stanje UI
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      // Prikazuje se indikator dok se učitava stanje iz SharedPreferences
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (_isFirstLaunch) {
      // Ako je prvo pokretanje, prikaži Welcome Screen
      return WelcomeScreen(
        onBegin: _setFirstLaunchToFalse, // Prosleđujemo callback funkciju
      );
    } else {
      // Ako nije prvo pokretanje, prikaži Home Screen
      return const HomeScreen();
    }
  }
}

// Welcome Screen (prikazuje se samo pri prvom pokretanju aplikacije)
class WelcomeScreen extends StatelessWidget {
  final VoidCallback onBegin; // Callback koji se poziva kada se pritisne 'Begin' dugme

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
              // Prikaz ikonice aplikacije (mora biti u assets/images folderu i definisana u pubspec.yaml)
              Image.asset(
                'lib/assets/images/ic_launcher.png', // PROVERI OVU PUTANJU: ako si koristio flutter_launcher_icons bez kopiranja, ovo možda neće raditi.
                width: 150,
                height: 150,
              ),
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
              // Izbornik za jezik (trenutno samo 'English')
              DropdownButton<String>(
                value: 'English',
                items: const [
                  DropdownMenuItem(value: 'English', child: Text('English')),
                ],
                onChanged: (String? newValue) {
                  // Ovde ide logika za promenu jezika
                },
              ),
              const SizedBox(height: 50),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton.icon(
                  onPressed: onBegin, // Poziva _setFirstLaunchToFalse iz SplashScreenWrappera
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

// Home Screen - Glavni ekran aplikacije
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Lista dummy dokumenata za prikaz
  final List<String> _documents = [];

  // Funkcija za otvaranje File Pickera
  Future<void> _openFilePicker() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        // Korisnik je izabrao fajl, obradi ga ovde
        PlatformFile file = result.files.first;
        print('Izabran fajl: ${file.name}, Putanja: ${file.path}');
        // Ovde bi dodao logiku za učitavanje fajla u aplikaciju
      } else {
        // Korisnik je otkazao biranje fajla
        print('Korisnik je otkazao biranje fajla.');
      }
    } catch (e) {
      print('Greška pri otvaranju file pickera: $e');
      // Prikazati korisniku neku poruku o grešci
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('f.Sentence', textAlign: TextAlign.center),
        centerTitle: true, // Centriranje naslova u AppBaru
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
      drawer: Drawer( // Hamburger meni
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary, // Koristi primarnu boju teme
              ),
              child: Center( // Centriranje teksta u headeru
                child: Text(
                  'f.Sentence',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary, // Boja teksta koja se dobro vidi na primarnoj boji
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
                Navigator.pop(context); // Zatvori drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FolderScreen()), // Navigacija do FolderScreen
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
                  MaterialPageRoute(builder: (context) => const FavoritesScreen()), // Navigacija do FavoritesScreen
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
                // Ovde bi trebalo implementirati otvaranje file managera sistema
                // Za ovo ti treba neka platform-specific implementacija ili paket kao 'open_filex'
                print('Otvaranje File Managera...');
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Trash'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TrashScreen()), // Navigacija do TrashScreen
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
      body: _documents.isEmpty // Uslovni prikaz sadržaja
          ? const Center( // Ako nema dokumenata
              child: Text(
                'Your creations will show up here',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : Column( // Ako ima dokumenata
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
                        leading: const Icon(Icons.insert_drive_file), // Ikona za prikaz fajla
                        title: Text(docName), // Ime fajla
                        subtitle: const Text('Created: 2025-06-07'), // Placeholder datum
                        trailing: IconButton( // Meni sa tri tačkice
                          icon: const Icon(Icons.more_vert),
                          onPressed: () {
                            _showFileOptions(context, docName); // Poziva opcije za fajl
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: SpeedDial( // Glavni FAB sa pod-opcijama
        icon: Icons.add, // Ikona za glavni FAB
        activeIcon: Icons.close, // Ikona kada je FAB otvoren
        spacing: 10, // Razmak između glavnog FAB-a i pod-opcija
        spaceBetweenChildren: 8, // Razmak između pod-opcija
        children: [
          SpeedDialChild(
            child: const Icon(Icons.note_add),
            label: 'New note',
            onTap: () {
              print('New note created');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotesScreen()), // Navigacija do NotesScreen
              );
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.description),
            label: 'New document',
            onTap: () {
              print('New document created');
              setState(() {
                _documents.add('New Document ${DateTime.now().second}'); // Dodaje dummy dokument u listu
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
                MaterialPageRoute(builder: (context) => const PdfScreen()), // Navigacija do PdfScreen
              );
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.folder_open),
            label: 'Open from storage',
            onTap: () {
              print('Open from storage');
              _openFilePicker(); // Poziva funkciju za otvaranje file pickera
            },
          ),
        ],
      ),
    );
  }

  // Prikaz opcija za fajl (share, delete, rename, archive)
  void _showFileOptions(BuildContext context, String fileName) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea( // Za sigurno područje na dnu ekrana
          child: Wrap( // Omotava listu opcija
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Share'),
                onTap: () {
                  Navigator.pop(bc);
                  print('Deljenje fajla: $fileName');
                  // Ovde bi koristio paket share_plus za deljenje
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Delete'),
                onTap: () {
                  Navigator.pop(bc);
                  _confirmDelete(context, fileName); // Poziva dijalog za potvrdu brisanja
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Rename'),
                onTap: () {
                  Navigator.pop(bc);
                  _renameFile(context, fileName); // Poziva dijalog za preimenovanje
                },
              ),
              ListTile(
                leading: const Icon(Icons.archive),
                title: const Text('Archive'),
                onTap: () {
                  Navigator.pop(bc);
                  _confirmArchive(context, fileName); // Poziva dijalog za potvrdu arhiviranja
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Dijalog za potvrdu brisanja fajla
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
                  _documents.remove(fileName); // Ukloni fajl iz liste
                  // Ovde dodaj stvarnu logiku premeštanja fajla u Trash
                  print('Fajl "$fileName" prebačen u Trash');
                });
              },
            ),
          ],
        );
      },
    );
  }

  // Dijalog za preimenovanje fajla
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
                      print('Fajl "$oldFileName" preimenovan u "$newFileName"');
                      // Ovde dodaj stvarnu logiku preimenovanja fajla na disku
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

  // Dijalog za potvrdu arhiviranja fajla
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
                  _documents.remove(fileName); // Ukloni fajl iz liste
                  // Ovde dodaj stvarnu logiku premeštanja fajla u Archive
                  print('Fajl "$fileName" prebačen u Archive');
                });
              },
            ),
          ],
        );
      },
    );
  }
}
