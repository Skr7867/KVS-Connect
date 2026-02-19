import 'package:shared_preferences/shared_preferences.dart';

class AppPrefrence {
  static SharedPreferences? _prefs;

  /// INIT (call in main)
  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// SAVE STRING
  static Future<bool> putString(String key, String value) async {
    return await _prefs!.setString(key, value);
  }

  /// GET STRING
  static String getString(String key) {
    return _prefs!.getString(key) ?? "";
  }

  /// SAVE BOOL
  static Future<bool> putBool(String key, bool value) async {
    return await _prefs!.setBool(key, value);
  }

  /// GET BOOL
  static bool getBool(String key) {
    return _prefs!.getBool(key) ?? false;
  }

  /// REMOVE KEY
  static Future<bool> remove(String key) async {
    return await _prefs!.remove(key);
  }

  /// CLEAR ALL DATA (Logout)
  static Future<bool> clear() async {
    return await _prefs!.clear();
  }
}
