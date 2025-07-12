import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'onboarding.dart'; // obavezno da fajl postoji
import 'home.dart'; // tvoja glavna aplikacija

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final bool isDarkTheme = prefs.getBool('is_dark_theme') ?? false;
  final bool onboardingComplete = prefs.getBool('onboarding_complete') ?? false;

  // Podešavanje system bar-ova (navigation + status bar)
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: isDarkTheme ? Colors.black : Colors.white,
    systemNavigationBarIconBrightness:
        isDarkTheme ? Brightness.light : Brightness.dark,
    statusBarColor: Colors.transparent,
    statusBarIconBrightness:
        isDarkTheme ? Brightness.light : Brightness.dark,
  ));

  runApp(MyApp(
    isDarkTheme: isDarkTheme,
    onboardingComplete: onboardingComplete,
  ));
}

class MyApp extends StatelessWidget {
  final bool isDarkTheme;
  final bool onboardingComplete;

  const MyApp({
    super.key,
    required this.isDarkTheme,
    required this.onboardingComplete,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Under construction 🚧',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black, // AMOLED crna
      ),
      themeMode: isDarkTheme ? ThemeMode.dark : ThemeMode.light,
      initialRoute: onboardingComplete ? '/main' : '/',
      routes: {
        '/': (context) => const OnboardingScreen(),
        '/main': (context) => const HomeScreen(),
      },
    );
  }
}