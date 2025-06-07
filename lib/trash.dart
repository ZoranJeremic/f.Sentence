import 'package:flutter/material.dart';

class TrashScreen extends StatelessWidget {
  const TrashScreen({super.key}); // Konstruktor se zove kao klasa!

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trash'), // Obavezno const
      ),
      body: const Center(child: Text('Trash Screen Content')), // Obavezno const
    );
  }
}
