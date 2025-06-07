import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key}); // Konstruktor se zove kao klasa!

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'), // Obavezno const
      ),
      body: const Center(child: Text('Settings Screen Content')), // Obavezno const
    );
  }
}
