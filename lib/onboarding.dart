import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;
  String _selectedLanguageCode = 'en';
  bool _darkMode = false;
  bool _dynamicTheme = false;

  final List<Color> _accentColors = [
    Colors.red,
    Colors.pink,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.purple,
    Colors.cyan,
    Colors.teal,
    Colors.indigo,
  ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final accentColor = theme.colorScheme.primary;

    SystemChrome.setSystemUIOverlayStyle(
      isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
    );

    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        top: false,
        bottom: false,
        child: Stack(
          children: [
            PageView(
              controller: _controller,
              onPageChanged: (index) => setState(() => _currentPage = index),
              children: [
                _buildWelcomePage(accentColor),
                _buildLanguagePage(accentColor),
                _buildAppearancePage(accentColor),
                _buildDonePage(accentColor),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (index) {
                    final selected = index == _currentPage;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: 8,
                        width: selected ? 24 : 8,
                        decoration: BoxDecoration(
                          color: selected ? accentColor : accentColor.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton.extended(
                onPressed: _onNextPressed,
                label: Text('Next'.tr()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomePage(Color accentColor) => Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Welcome to f.Sentence!'.tr(),
              style: TextStyle(fontSize: 26, color: accentColor),
            ),
          ),
        ),
      );

  Widget _buildLanguagePage(Color accentColor) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select your language'.tr(),
              style: TextStyle(fontSize: 22, color: accentColor),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedLanguageCode,
              decoration: const InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(50)))),
              items: const [
                DropdownMenuItem(value: 'en', child: Text('English')),
                DropdownMenuItem(value: 'sr', child: Text('Српски')),
                DropdownMenuItem(value: 'tr', child: Text('Türkçe')),
              ],
              onChanged: (value) async {
                if (value != null) {
                  setState(() => _selectedLanguageCode = value);
                  await context.setLocale(Locale(value));
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString('language', value);
                }
              },
            ),
          ],
        ),
      );

  Widget _buildAppearancePage(Color accentColor) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 100),
            Text(
              'Personalize appearance'.tr(),
              style: TextStyle(fontSize: 22, color: accentColor),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _accentColors.map((color) {
                return GestureDetector(
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setInt('accent_color', _accentColors.indexOf(color));
                  },
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            CheckboxListTile(
              title: Text('settings_theme_dark'.tr()),
              value: _darkMode,
              onChanged: (val) async {
                setState(() => _darkMode = val ?? false);
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('dark_mode', _darkMode);
              },
            ),
            CheckboxListTile(
              title: Text('settings_theme_dynamic'.tr()),
              value: _dynamicTheme,
              onChanged: (val) async {
                setState(() => _dynamicTheme = val ?? false);
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('dynamic_theme', _dynamicTheme);
              },
            ),
          ],
        ),
      );

  Widget _buildDonePage(Color accentColor) => Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'You are all done!'.tr(),
              style: TextStyle(fontSize: 24, color: accentColor),
            ),
          ),
        ),
      );

  void _onNextPressed() async {
    if (_currentPage < 3) {
      _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboarding_complete', true);
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/main');
    }
  }
}