import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  static const _key = 'is_arabic';
  Locale _locale = const Locale('en');

  LanguageProvider() {
    _loadLocale();
  }

  Locale get locale => _locale;
  bool get isArabic => _locale.languageCode == 'ar';

  Future<void> _loadLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isAr = prefs.getBool(_key);

      if (isAr != null) {
        _locale = isAr ? const Locale('ar') : const Locale('en');
        notifyListeners();
      }
    } catch (e) {
      // debugPrint('SharedPreferences load error: $e');
    }
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_key, locale.languageCode == 'ar');
    } catch (e) {
      // debugPrint('SharedPreferences save error: $e');
    }
  }
}
