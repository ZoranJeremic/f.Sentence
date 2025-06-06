import 'package:flutter/material.dart';
import 'drawing.dart';
import 'folders.dart';
import 'notes_screen.dart';
import 'pdf.dart';
import 'search_bar.dart';

void main() {
  runApp(SentenceApp());
}

class SentenceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'f.Sentence',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        useMaterial3: true,
      ),
      home: MainHome(),
    );
  }
}

class MainHome extends StatefulWidget {
  @override
  _MainHomeState createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('f.Sentence'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchBarWidget()),
              );
            },
          ),
          PopupMenuButton<String>(
            onSelected: (String value) {
              if (value == 'New note') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotesScreen()),
                );
              } else if (value == 'New drawing') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DrawingScreen()),
                );
              } else if (value == 'Open PDF') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PDFScreen()),
                );
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(value: 'New note', child: Text('New note')),
              PopupMenuItem(value: 'New drawing', child: Text('New drawing')),
              PopupMenuItem(value: 'Open PDF', child: Text('Open PDF')),
            ],
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Text('f.Sentence', style: TextStyle(fontSize: 24, color: Colors.white)),
              decoration: BoxDecoration(color: Colors.orange),
            ),
            ListTile(
              leading: Icon(Icons.folder),
              title: Text('Folders'),
              onTap: () {
                Navigator.pop(context); // Zatvori drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FoldersScreen()),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        title: Text('Create'),
        onPressed: () {
          // idk
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Wrap(
                children: [
                  ListTile(
                    leading: Icon(Icons.note_add),
                    title: Text('New note'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NotesScreen()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.brush),
                    title: Text('New drawing'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DrawingScreen()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.picture_as_pdf),
                    title: Text('Open PDF'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PDFScreen()),
                      );
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
      body: Center(child: Text("Your drawings, PDFs and documents will appear here after you create or edit them.")),
    );
  }
}