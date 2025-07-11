import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'onboarding.dart'; // Uvozimo naš onboarding
// import 'home.dart';  // Tvoj pravi glavni ekran kad ga napraviš

void main() {
  runApp(const SentenceApp());
}

class SentenceApp extends StatefulWidget {
  const SentenceApp({super.key});

  @override
  State<SentenceApp> createState() => _SentenceAppState();
}

class _SentenceAppState extends State<SentenceApp> {
  bool _onboardingComplete = false;
  bool _isDarkTheme = false;
  Color _accentColor = Colors.blue;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _onboardingComplete = prefs.getBool('onboarding_complete') ?? false;
      _isDarkTheme = prefs.getBool('is_dark_theme') ?? false;
      _accentColor = _parseAccentColor(prefs.getString('accent_color')) ?? Colors.blue;
    });
  }

  // Ako želiš da boju sačuvaš kao string (npr. "#FF0000"), ovo ti pomaže
  Color? _parseAccentColor(String? colorString) {
    if (colorString == null) return null;
    try {
      return Color(int.parse(colorString.replaceFirst('#', '0xff')));
    } catch (_) {
      return null;
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
      ),
      themeMode: _isDarkTheme ? ThemeMode.dark : ThemeMode.light,
      home: _onboardingComplete ? const MainScreen() : const OnboardingScreen(),
      routes: {
        '/main': (context) => const MainScreen(),
      },
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('f.Sentence'),
      ),
      body: const Center(
        child: Text('This is your main app screen!'),
      ),
    );
  }
}