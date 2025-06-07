// Primer za 'favorites.dart'
import 'package:flutter/material.dart';

class DrawingScreen extends StatelessWidget {
  const FavoritesScreen({super.key}); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drawings'), 
      ),
      body: const Center(child: Text('Drawings are coming soon!')),
    );
  }
}
