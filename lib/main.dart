import 'package:flutter/material.dart';
import 'drawing.dart';
import 'folders.dart';
import 'pdf.dart';
import 'search_bar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'f.Sentence',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      home: MainHome(),
    );
  }
}

class MainHome extends StatefulWidget {
  const MainHome({super.key});

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    FoldersScreen(),
    DrawingScreen(),
    PDFScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // ako kasnije hoćeš hamburger menu, možeš dodati Drawer
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('f.Sentence'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // možeš otvoriti modalnu pretragu ili posebnu stranicu
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // isto, otvori stranicu sa podešavanjima
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SearchBarWidget(), // možeš i ovo da izbaciš ako koristiš samo ikoncu
          Expanded(child: _screens[_selectedIndex]),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // dodavanje nove beleške/dokumenta
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.folder), label: 'Folders'),
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: 'Draw'),
          BottomNavigationBarItem(icon: Icon(Icons.picture_as_pdf), label: 'PDF'),
        ],
      ),
    );
  }
}