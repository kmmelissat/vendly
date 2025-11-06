import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class OnboardingService {

  static Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(AppConstants.onboardingCompletedKey) ?? false;
  }

  static Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.onboardingCompletedKey, true);
  }

  static Future<void> resetOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.onboardingCompletedKey);
  }
}
