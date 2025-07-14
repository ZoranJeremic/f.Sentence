import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  // Učitavamo podešavanja
  final isDarkTheme = prefs.getBool('is_dark_theme') ?? false;
  final languageCode = prefs.getString('language_code') ?? 'en';
  final accentColorIndex = prefs.getInt('accent_color_index') ?? 6;

  final accentColors = [
    Colors.white,
    Colors.yellow,
    Colors.pink,
    Colors.orange,
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.grey,
    Colors.teal,
    Colors.deepPurple,
    Colors.brown,
    Colors.cyan,
  ];
  final Color accentColor = accentColors[accentColorIndex];

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('sr'),
        Locale('tr'),
        Locale('es'),
        Locale('de'),
      ],
      path: 'lang',
      fallbackLocale: const Locale('en'),
      startLocale: Locale(languageCode),
      child: MyApp(
        isDarkTheme: isDarkTheme,
        accentColor: accentColor,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isDarkTheme;
  final Color accentColor;

  const MyApp({
    super.key,
    required this.isDarkTheme,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'f.Sentence',
      debugShowCheckedModeBanner: false,
      themeMode: isDarkTheme ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: accentColor,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black, // AMOLED black
        colorScheme: ColorScheme.fromSeed(
          seedColor: accentColor,
          brightness: Brightness.dark,
        ),
      ),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      builder: (context, child) => SafeArea(child: child!),
      home: const Placeholder(), // OVO ZAMENJUJEŠ KASNIJE sa svojim Home/onboarding screenom
    );
  }
}