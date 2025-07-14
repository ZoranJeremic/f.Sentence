import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleStrings {
  static Map<String, String> _localizedStrings = {};
  static Locale _currentLocale = const Locale('en');

  static Locale get currentLocale => _currentLocale;

  static Future<void> load(Locale locale) async {
    _currentLocale = locale;
    String jsonString = await rootBundle.loadString(
      'lib/lang/${locale.languageCode}.json', // <- OVDE JE IZMENA
    );
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    _localizedStrings = jsonMap.map((key, value) => MapEntry(key, value.toString()));
  }

  static String get(String key) {
    return _localizedStrings[key] ?? '**$key**';
  }

  static Future<void> setLocale(String languageCode) async {
    _currentLocale = Locale(languageCode);
    await load(_currentLocale);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', languageCode);
  }

  static Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString('language_code') ?? 'en';
    await load(Locale(code));
  }
}