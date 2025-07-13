import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle('Theme'),
          _buildTile('Select mode', 'Dark / Light'),
          _buildTile('Accent colour', 'Choose from 9 options'),

          _buildSectionTitle('Documents preferences'),
          _buildTile('Select default format', '.odt, .doc, .docx, .fdoc'),
          _buildTile('Dark theme inside documents', 'On / Off'),
          _buildTile('Default view', 'Mobile / Desktop'),

          _buildSectionTitle('Notes preferences'),
          _buildTile('Default format', '.json, .txt, .odt, .fsen'),
          _buildTile('Enable Markdown', 'Yes / No'),
          _buildTile('Share with Markdown enabled?', 'Yes / No'),
          _buildTile('Notes alerts', 'Clock / Notification'),

          _buildSectionTitle('Drawings preferences'),
          _buildTile('Default brush', '(Coming soon)'),
          _buildTile('Default format', '.bmp, .jpg, .jpeg, .img, .png, .gif, .webp, .fdr'),
          _buildTile('Prevent accidental touches with stylus', 'Toggle switch'),

          _buildSectionTitle('PDF preferences'),
          _buildTile('Start annotation automatically', 'Yes / No'),
          _buildTile('Default view', 'Mobile / Desktop'),
          _buildTile('Add your signature', 'Draw your signature'),

          _buildSectionTitle('Whiteboards preferences'),
          _buildTile('Whiteboard matches app theme', 'Yes / No'),
          _buildTile('Default format', '.jpg, .jpeg, .png, .gif, .bmp, .img, .webp, .fwb'),
          _buildTile('Prevent accidental touches with stylus', 'Toggle switch'),

          _buildSectionTitle('Accessibility'),
          _buildTile('High contrast themes', 'Blue on Black / Yellow on Black'),
          _buildTile('Increase font size', '100%, 125%, 150%, 200%, Based on device'),
          _buildTile('Color correction', 'System / Grayscale / Protanomaly / etc.'),
          _buildTile('Remove animations', 'Yes / No'),

          _buildSectionTitle('Trash preferences'),
          _buildTile('Delete automatically after', '1d / 5d / 1w / Custom'),

          _buildSectionTitle('About app'),
          _buildTile('Version', 'v1.0.0'),
          _buildTile('Open Source Licenses', 'View all licenses'),
          _buildTile('App license', 'GPLv3'),
          _buildTile('©2025 Flake', ''),
          _buildTile('Links', 'Website / Docs / Support'),

          _buildSectionTitle('Additional'),
          _buildTile('Language', 'Change language'),
          _buildTile('Restore default settings', 'Reset'),
          _buildTile('Backup your settings', 'Export to file'),
          _buildTile('Restore settings from backup', 'Import from file'),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildTile(String title, String subtitle) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // Ovde ćeš ubacivati navigaciju ka podešavanjima
      },
    );
  }
}