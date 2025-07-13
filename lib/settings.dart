import 'package:flutter/material.dart';
import 'theme_settings.dart'; // sledeće kreiramo
// Dodaj i ostale kad budu spremni...

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCategory(context, 'Theme', const ThemeSettingsScreen()),
          _buildCategory(context, 'Documents preferences'),
          _buildCategory(context, 'Notes preferences'),
          _buildCategory(context, 'Drawings preferences'),
          _buildCategory(context, 'PDF preferences'),
          _buildCategory(context, 'Whiteboards preferences'),
          _buildCategory(context, 'Accessibility'),
          _buildCategory(context, 'Trash preferences'),
          _buildCategory(context, 'About app'),
          _buildCategory(context, 'Additional'),
        ],
      ),
    );
  }

  Widget _buildCategory(BuildContext context, String title, [Widget? screen]) {
    return ListTile(
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: screen != null
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => screen),
              );
            }
          : null, // ako nema još ekrana, ne radi ništa
    );
  }
}