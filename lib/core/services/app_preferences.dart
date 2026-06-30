import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences extends ChangeNotifier {
  static const _onboardingKey = 'onboarding_complete';

  bool _onboardingComplete = false;
  bool _initialized = false;

  bool get onboardingComplete => _onboardingComplete;
  bool get initialized => _initialized;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _onboardingComplete = prefs.getBool(_onboardingKey) ?? false;
    _initialized = true;
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, true);
    _onboardingComplete = true;
    notifyListeners();
  }
}
