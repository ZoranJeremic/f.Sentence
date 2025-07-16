import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentPage = 0;
  Locale _selectedLocale = const Locale('en');
  Color? _selectedColor;
  bool _isDarkMode = false;
  bool _isDynamic = false;

  final List<Color> _accentColors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.purple,
    Colors.pink,
    Colors.teal,
    Colors.indigo,
    Colors.brown,
  ];

  void _nextPage() async {
    if (_currentPage == 3) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboarding_complete', true);
      await prefs.setString('language_code', _selectedLocale.languageCode);
      await prefs.setString('theme_color', _selectedColor?.value.toRadixString(16) ?? '');
      await prefs.setBool('dark_mode', _isDarkMode);
      await prefs.setBool('dynamic_theme', _isDynamic);
      if (context.mounted) {
        Navigator.of(context).pushReplacementNamed('/main');
      }
    } else {
      setState(() {
        _currentPage++;
      });
    }
  }

  Widget _buildPageContent() {
    final accentColor = Theme.of(context).colorScheme.secondary;
    final textStyle = GoogleFonts.inter(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: accentColor,
    );

    switch (_currentPage) {
      case 0:
        return Center(
          child: Text(
            'app_store_title'.tr(),
            style: textStyle,
            textAlign: TextAlign.left,
          ),
        );
      case 1:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('settings_additional_language'.tr(), style: textStyle),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<Locale>(
                  value: _selectedLocale,
                  borderRadius: BorderRadius.circular(20),
                  items: const [
                    DropdownMenuItem(value: Locale('en'), child: Text('English')),
                    DropdownMenuItem(value: Locale('sr'), child: Text('Srpski')),
                    DropdownMenuItem(value: Locale('tr'), child: Text('Türkçe')),
                  ],
                  onChanged: (Locale? newValue) {
                    if (newValue != null) {
                      setState(() => _selectedLocale = newValue);
                      context.setLocale(newValue);
                    }
                  },
                ),
              ),
            ),
          ],
        );
      case 2:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('settings_theme_tooltip'.tr(), style: textStyle),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _accentColors.map((color) {
                final selected = _selectedColor == color;
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = color),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color,
                      border: selected
                          ? Border.all(color: Colors.black, width: 3)
                          : null,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              title: Text('settings_theme_dark'.tr()),
              value: _isDarkMode,
              onChanged: (value) => setState(() => _isDarkMode = value ?? false),
            ),
            CheckboxListTile(
              title: Text('settings_theme_dynamic'.tr()),
              value: _isDynamic,
              onChanged: (value) => setState(() => _isDynamic = value ?? false),
            ),
          ],
        );
      case 3:
        return Center(
          child: Text('You are all done!', style: textStyle),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        final isActive = index == _currentPage;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? Theme.of(context).colorScheme.primary : Colors.grey,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        backgroundColor: backgroundColor,
        body: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Expanded(child: _buildPageContent()),
                _buildPageIndicator(),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: _nextPage,
                    child: Text(_currentPage == 3 ? 'Done' : 'Next'),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

