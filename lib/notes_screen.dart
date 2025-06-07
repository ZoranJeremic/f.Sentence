import 'package:flutter/material.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key}); // Konstruktor se zove kao klasa!

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Note'), // Obavezno const
      ),
      body: const Center(child: Text('Note Editor Here')), // Obavezno const
    );
  }
}
