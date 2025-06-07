import 'package:flutter/material.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key}); // Konstruktor se zove kao klasa!

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'), // Obavezno const
      ),
      body: const Center(child: Text('Favorites are coming soon!')), // Obavezno const
    );
  }
}
