import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'onboarding.dart'; // Važno: obavezno importuj svoj onboarding fajl

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> _checkOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('onboarding_complete') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkOnboardingComplete(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }

        final onboardingComplete = snapshot.data!;
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'f.Sentence',
          initialRoute: onboardingComplete ? '/main' : '/onboarding',
          routes: {
            '/onboarding': (context) => const OnboardingScreen(),
            '/main': (context) => const MainScreen(),
          },
        );
      },
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Welcome to f.Sentence main screen!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}