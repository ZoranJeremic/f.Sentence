import 'package:flutter/material.dart';

class ArchiveScreen extends StatelessWidget { 
  const FavoritesScreen({super.key}); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Archive'),
      ),
      body: const Center(child: Text('Archive is coming soon!')),
    );
  }
}
