import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider with ChangeNotifier {
  SharedPreferences? _prefs;
  Locale _locale = const Locale('en'); // Default locale
  String _currentLanguage = 'en'; // Default language

  Locale get locale => _locale;
  String get currentLanguage => _currentLanguage;

  LanguageProvider() {
    initPrefs();
  }

  Future<void> initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    await loadLanguagePreference();
  }

  Future<void> setLocale(String languageCode) async {
    if (_locale.languageCode != languageCode) {
      _locale = Locale(languageCode);
      _currentLanguage = languageCode;
      await _saveLanguagePreference(languageCode);
      notifyListeners();
    }
  }

  Future<void> loadLanguagePreference() async {
    if (_prefs == null) {
      return;
    }
    String? languageCode = _prefs!.getString('languageCode');
    if (languageCode != null) {
      _locale = Locale(languageCode);
      _currentLanguage = languageCode;
    }
    notifyListeners();
  }

  Future<void> _saveLanguagePreference(String languageCode) async {
    if (_prefs == null) {
      return;
    }
    await _prefs!.setString('languageCode', languageCode);
  }
}

// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class LanguageProvider with ChangeNotifier {
//   Locale _locale = const Locale('en'); // Default locale

//   Locale get locale => _locale;

//   Future<void> setLocale(String languageCode) async {
//     print("Set Local : $languageCode");
//     _locale = Locale(languageCode);
//     notifyListeners();
//     await _saveLanguagePreference(languageCode);
//   }

//   Future<void> loadLanguagePreference() async {
//     final prefs = await SharedPreferences.getInstance();
//     String? languageCode = prefs.getString('languageCode');
//     print("Get Local : $languageCode");
//     if (languageCode != null) {
//       _locale = Locale(languageCode);
//       print(_locale);
//     }
//     notifyListeners();
//   }

//   Future<void> _saveLanguagePreference(String languageCode) async {
//     print("Save Local : $languageCode");
//     final prefs = await SharedPreferences.getInstance();

//     prefs.setString('languageCode', languageCode);
//   }
// }