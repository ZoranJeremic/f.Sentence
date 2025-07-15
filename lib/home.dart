import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('settings_theme'.tr()),
      ),
      body: Center(
        child: Text(
          'settings_theme_tooltip'.tr(),
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}