import 'package:shared_preferences/shared_preferences.dart';

class OnceService {
  OnceService._internal();
  static final OnceService _instance = OnceService._internal();
  factory OnceService() => _instance;

  static Future<bool> beenDone(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }

  static Future<void> markDone(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, true);
  }
}
