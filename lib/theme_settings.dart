import 'package:flutter/material.dart';

class ThemeSettingsScreen extends StatelessWidget {
  const ThemeSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Theme')),
      body: ListView(
        children: [
          const ListTile(
            title: Text('Select mode'),
            subtitle: Text('Dark / Light'),
            trailing: Icon(Icons.chevron_right),
          ),
          const ListTile(
            title: Text('Accent colour'),
            subtitle: Text('White, Yellow, Pink...'),
            trailing: Icon(Icons.chevron_right),
          ),
          const ListTile(
            title: Text('Dynamic (Android 12+)'),
            trailing: Icon(Icons.chevron_right),
          ),
          // Ovdje možeš voditi ka još specifičnijim ekranima ako želiš
        ],
      ),
    );
  }
}