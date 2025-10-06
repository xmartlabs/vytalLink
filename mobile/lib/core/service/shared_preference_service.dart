import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService {
  static const String _onboardingKey = 'onboarding_completed';
  static const String _chatGptOnDeviceGuidanceKey =
      'chatgpt_on_device_guidance_skipped';

  Future<void> setOnboardingCompleted(bool completed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, completed);
  }

  Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingKey) ?? false;
  }

  Future<void> setChatGptOnDeviceGuidanceSkipped({
    required bool value,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_chatGptOnDeviceGuidanceKey, value);
  }

  Future<bool> isChatGptOnDeviceGuidanceSkipped() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_chatGptOnDeviceGuidanceKey) ?? false;
  }
}
