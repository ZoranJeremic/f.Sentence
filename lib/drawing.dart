import 'package:flutter/material.dart';

class DrawingScreen extends StatelessWidget { // Ime klase je DrawingScreen
  const DrawingScreen({super.key}); // Konstruktor se zove kao klasa!

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Drawing'), // Obavezno const
      ),
      body: const Center(child: Text('Drawing Canvas Here')), // Obavezno const
    );
  }
}
