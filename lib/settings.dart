// Primer za 'favorites.dart'
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget { // Pazi da je ime klase ispravno (npr. FavoritesScreen)
  const FavoritesScreen({super.key}); // OVDE DODAJ const

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'), // OVDE DODAJ const
      ),
      body: const Center(child: Text('Favorites are coming soon!')), // OVDE DODAJ const
    );
  }
}
