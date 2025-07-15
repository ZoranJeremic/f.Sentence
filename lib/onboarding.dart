import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

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

  final Map<String, String> languageMap = {
    'English': 'en',
    'Српски': 'sr',
    'Türkçe': 'tr',
    'Español': 'es',
    'Deutsch': 'de',
  };

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      String langCode = prefs.getString('language_code') ?? 'en';
      _selectedLanguage = languageMap.entries.firstWhere(
        (e) => e.value == langCode,
        orElse: () => const MapEntry('English', 'en'),
      ).key;

      _isDarkTheme = prefs.getBool('is_dark_theme') ?? false;
      int savedColorIndex = prefs.getInt('accent_color_index') ?? 6;
      if (savedColorIndex >= 0 && savedColorIndex < accentColors.length) {
        _accentColor = accentColors[savedColorIndex];
      } else {
        _accentColor = Colors.blue;
      }
    });

    // Promeni locale easy_localization na izabrani jezik
    await context.setLocale(Locale(languageMap[_selectedLanguage]!));
  }

  void _nextPage() {
    if (_currentPage < 3) {
      _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      _finishOnboarding();
    }
  }

  Future<void> _finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);
    await prefs.setBool('is_dark_theme', _isDarkTheme);
    await prefs.setString('language_code', languageMap[_selectedLanguage]!);
    await prefs.setInt('accent_color_index', accentColors.indexOf(_accentColor));

    // Postavi lokalizaciju kad završavaš
    await context.setLocale(Locale(languageMap[_selectedLanguage]!));

    Navigator.of(context).pushReplacementNamed('/main');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: _accentColor,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: PageView(
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
        ),
      ),
    );
  }

  Widget _buildWelcomePage() => _buildPage(
        title: 'app_store_title'.tr(),
        subtitle: 'app_store_description_1'.tr(),
      );

  Widget _buildLanguagePage() => _buildPage(
        title: 'settings_additional_language'.tr(),
        subtitle: 'settings_additional_description'.tr(),
        child: DropdownButton<String>(
          value: _selectedLanguage,
          onChanged: (value) async {
            if (value != null) {
              setState(() => _selectedLanguage = value);
              await context.setLocale(Locale(languageMap[value]!));
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('language_code', languageMap[value]!);
            }
          },
          items: languageMap.keys
              .map((lang) => DropdownMenuItem(value: lang, child: Text(lang)))
              .toList(),
        ),
      );

  Widget _buildThemePage() => _buildPage(
        title: 'settings_theme'.tr(),
        subtitle: 'settings_theme_tooltip'.tr(),
        child: Column(
          children: [
            SwitchListTile(
              title: Text('settings_theme_mode'.tr()),
              value: _isDarkTheme,
              onChanged: (value) async {
                setState(() => _isDarkTheme = value);
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('is_dark_theme', value);
              },
              secondary: Icon(_isDarkTheme ? Icons.dark_mode : Icons.light_mode),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 12,
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
        title: 'app_store_description_2'.tr(),
        subtitle: 'app_store_description_3'.tr(),
        buttonText: 'settings_about'.tr(),
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
              child: Text(buttonText.tr()),
            ),
          ],
        ),
      ),
    );
  }
}