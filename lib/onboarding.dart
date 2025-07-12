import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  String _selectedLanguage = 'English';
  bool _isDarkTheme = false;
  Color _accentColor = Colors.blue;

  // Dodao sam još boja, plus razmak između redova
  final List<Color> accentColors = [
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

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = _getLanguageName(prefs.getString('language_code') ?? 'en');
      _isDarkTheme = prefs.getBool('is_dark_theme') ?? false;
      int savedColorIndex = prefs.getInt('accent_color_index') ?? 6; // default blue index
      if (savedColorIndex >= 0 && savedColorIndex < accentColors.length) {
        _accentColor = accentColors[savedColorIndex];
      } else {
        _accentColor = Colors.blue;
      }
    });
  }

  void _nextPage() {
    if (_currentPage < 3) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  Future<void> _finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);
    await prefs.setBool('is_dark_theme', _isDarkTheme);
    await prefs.setString('language_code', _getLanguageCode(_selectedLanguage));
    await prefs.setInt('accent_color_index', accentColors.indexOf(_accentColor));
    Navigator.of(context).pushReplacementNamed('/main'); // Idi na glavni ekran
  }

  String _getLanguageCode(String lang) {
    switch (lang) {
      case 'English':
        return 'en';
      case 'Српски':
        return 'sr';
      case 'Türkçe':
        return 'tr';
      case 'Español':
        return 'es';
      case 'Deutsch':
        return 'de';
      default:
        return 'en';
    }
  }

  String _getLanguageName(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'sr':
        return 'Српски';
      case 'tr':
        return 'Türkçe';
      case 'es':
        return 'Español';
      case 'de':
        return 'Deutsch';
      default:
        return 'English';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'f.Sentence',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: _accentColor,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: _accentColor,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black, // Pitch black za tamnu temu
        colorScheme: ColorScheme.fromSeed(seedColor: _accentColor, brightness: Brightness.dark),
      ),
      themeMode: _isDarkTheme ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        body: PageView(
          controller: _controller,
          onPageChanged: (index) => setState(() => _currentPage = index),
          children: [
            _buildWelcomePage(),
            _buildLanguagePage(),
            _buildThemePage(),
            _buildFinishPage(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomePage() => _buildPage(
        title: 'Welcome to f.Sentence!',
        subtitle: 'Your new creative workspace — fast, private, and offline-ready.',
      );

  Widget _buildLanguagePage() => _buildPage(
        title: 'Choose Language',
        subtitle: 'You can change this later in Settings.',
        child: DropdownButton<String>(
          value: _selectedLanguage,
          onChanged: (value) async {
            if (value != null) {
              setState(() => _selectedLanguage = value);
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('language_code', _getLanguageCode(value));
            }
          },
          items: ['English', 'Српски', 'Türkçe', 'Español', 'Deutsch']
              .map((lang) => DropdownMenuItem(
                    value: lang,
                    child: Text(lang),
                  ))
              .toList(),
        ),
      );

  Widget _buildThemePage() => _buildPage(
        title: 'Choose Theme & Color',
        subtitle: 'Customize the look of your app.',
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('Dark Theme (AMOLED)'),
              value: _isDarkTheme,
              onChanged: (value) async {
                setState(() => _isDarkTheme = value);
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('is_dark_theme', value);
              },
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 12, // Razmak između redova
              children: accentColors.asMap().entries.map((entry) {
                int idx = entry.key;
                Color color = entry.value;
                return GestureDetector(
                  onTap: () async {
                    setState(() => _accentColor = color);
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setInt('accent_color_index', idx);
                  },
                  child: CircleAvatar(
                    backgroundColor: color,
                    radius: 20,
                    child: _accentColor == color
                        ? const Icon(Icons.check, color: Colors.black)
                        : null,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      );

  Widget _buildFinishPage() => _buildPage(
        title: "You're Ready!",
        subtitle: 'Tap below to start writing, drawing, or brainstorming.',
        buttonText: 'Get Started',
      );

  Widget _buildPage({
    required String title,
    required String subtitle,
    Widget? child,
    String buttonText = 'Next',
  }) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              subtitle,
              textAlign: TextAlign.center,
            ),
            if (child != null) ...[
              const SizedBox(height: 24),
              child,
            ],
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: _nextPage,
              child: Text(buttonText),
            ),
          ],
        ),
      ),
    );
  }
}