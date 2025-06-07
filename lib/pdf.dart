import 'package:flutter/material.dart';

class PdfScreen extends StatelessWidget { // Ime klase je PdfScreen
  const PdfScreen({super.key}); // Konstruktor se zove kao klasa!

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Annotate PDF'), // Obavezno const
      ),
      body: const Center(child: Text('PDF Annotator Here')), // Obavezno const
    );
  }
}
