import 'package:flutter/material.dart';

class FolderScreen extends StatelessWidget {
  const FolderScreen({super.key}); // Konstruktor se zove kao klasa!

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Folders'), // Obavezno const
      ),
      body: const Center(child: Text('Folders Screen Content')), // Obavezno const
    );
  }
}
