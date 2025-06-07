import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget { // Ime klase je SearchBarWidget
  const SearchBarWidget({super.key}); // Konstruktor se zove kao klasa!

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'), // Obavezno const
      ),
      body: const Center(child: Text('Search Functionality Here')), // Obavezno const
    );
  }
}
