import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart'; 

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  String _selectedLanguage = 'English';
  bool _isDarkTheme = false;
  Color _accentColor = Colors.blue;

  List<Color> accentColors = [
    Colors.white,
    Colors.yellow,
    Colors.pink,
    Colors.orange,
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.grey,
  ];

  void _nextPage() {
    if (_currentPage < 3) {
      _controller.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);

    if (!mounted) return;

    // Ovde preusmerava na glavni ekran definisan u main.dart
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => MainAppScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        onPageChanged: (index) => setState(() => _currentPage = index),
        children: [
          _buildPage(
            title: 'Welcome to f.Sentence!',
            subtitle: 'Your creative space. Fast, offline, private.',
          ),
          _buildPage(
            title: 'Choose Language',
            subtitle: 'You can change it later in Settings.',
            child: DropdownButton<String>(
              value: _selectedLanguage,
              onChanged: (value) => setState(() => _selectedLanguage = value!),
              items: ['English', 'Српски', 'Español', 'Deutsch'].map((lang) {
                return DropdownMenuItem(value: lang, child: Text(lang));
              }).toList(),
            ),
          ),
          _buildPage(
            title: 'Choose Theme & Color',
            subtitle: 'Customize your experience.',
            child: Column(
              children: [
                SwitchListTile(
                  title: Text('Dark Theme'),
                  value: _isDarkTheme,
                  onChanged: (value) => setState(() => _isDarkTheme = value),
                ),
                Wrap(
                  spacing: 8,
                  children: accentColors.map((color) {
                    return GestureDetector(
                      onTap: () => setState(() => _accentColor = color),
                      child: CircleAvatar(
                        backgroundColor: color,
                        radius: 20,
                        child: _accentColor == color
                            ? Icon(Icons.check, color: Colors.black)
                            : null,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          _buildPage(
            title: 'Ready to Start!',
            subtitle: 'Click below and let the ideas flow.',
            buttonText: 'Get Started',
          ),
        ],
      ),
    );
  }

  Widget _buildPage({
    required String title,
    required String subtitle,
    Widget? child,
    String buttonText = 'Next',
  }) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          Text(subtitle, textAlign: TextAlign.center),
          if (child != null) ...[
            SizedBox(height: 24),
            child,
          ],
          SizedBox(height: 48),
          ElevatedButton(
            onPressed: _nextPage,
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }
}