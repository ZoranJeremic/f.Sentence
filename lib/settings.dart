import 'package:flutter/material.dart';
import 'theme_settings.dart';
// Ovde kasnije importuj ostale ekrane: documents_settings.dart itd.

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCategory(
            context,
            icon: Icons.color_lens_outlined,
            title: 'Theme',
            screen: const ThemeSettingsScreen(),
          ),
          _buildCategory(
            context,
            icon: Icons.description_outlined,
            title: 'Documents preferences',
          ),
          _buildCategory(
            context,
            icon: Icons.note_alt_outlined,
            title: 'Notes preferences',
          ),
          _buildCategory(
            context,
            icon: Icons.brush_outlined,
            title: 'Drawings preferences',
          ),
          _buildCategory(
            context,
            icon: Icons.picture_as_pdf_outlined,
            title: 'PDF preferences',
          ),
          _buildCategory(
            context,
            icon: Icons.dashboard_customize_outlined,
            title: 'Whiteboards preferences',
          ),
          _buildCategory(
            context,
            icon: Icons.accessibility_new_outlined,
            title: 'Accessibility',
          ),
          _buildCategory(
            context,
            icon: Icons.delete_outline,
            title: 'Trash preferences',
          ),
          _buildCategory(
            context,
            icon: Icons.info_outline,
            title: 'About app',
          ),
          _buildCategory(
            context,
            icon: Icons.settings_backup_restore_outlined,
            title: 'Additional',
          ),
        ],
      ),
    );
  }

  Widget _buildCategory(
    BuildContext context, {
    required IconData icon,
    required String title,
    Widget? screen,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: screen != null
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => screen),
              );
            }
          : null,
    );
  }
}