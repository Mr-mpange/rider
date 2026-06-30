import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences extends ChangeNotifier {
  static const _onboardingKey = 'onboarding_complete';
  static const _localeKey = 'locale_code';

  bool _onboardingComplete = false;
  bool _initialized = false;
  String _localeCode = 'en';

  bool get onboardingComplete => _onboardingComplete;
  bool get initialized => _initialized;
  String get localeCode => _localeCode;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _onboardingComplete = prefs.getBool(_onboardingKey) ?? false;
    _localeCode = prefs.getString(_localeKey) ?? 'en';
    _initialized = true;
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, true);
    _onboardingComplete = true;
    notifyListeners();
  }

  Future<void> setLocaleCode(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, code);
    _localeCode = code;
    notifyListeners();
  }
}
