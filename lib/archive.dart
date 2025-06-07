import 'package:flutter/material.dart';

class ArchiveScreen extends StatelessWidget {
  const ArchiveScreen({super.key}); // Konstruktor se zove kao klasa!

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Archive'), // Obavezno const
      ),
      body: const Center(child: Text('Archive Screen Content')), // Obavezno const
    );
  }
}
