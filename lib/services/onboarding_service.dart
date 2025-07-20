

import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _isOnboardedKey = 'isOnboarded';

  // A method to check if the user has completed onboarding
  Future<bool> checkOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isOnboardedKey) ?? false;
  }

  // A method to mark onboarding as complete
  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isOnboardedKey, true);
  }
}