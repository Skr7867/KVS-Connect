import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/utill.dart';

class _AppString {
  final String tokenKey = "token";
  final appversion = "appVersion";
}

var appString = _AppString();

class AppPrefrence {
  static Future<bool> getBoolean(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }

  static Future<bool> putBoolean(String key, bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(key, value);
  }

  static Future<String> getString(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? '';
  }

  static Future<bool> putString(String key, String? value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(key, value!);
  }

  static Future putToken(String? value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(appString.tokenKey, value!);
  }

  static Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString(appString.tokenKey);
  }

  static Future<Map?> getAppInfo() async {
    // return "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6InZpa3JhbUBnbWFpbC5jb20iLCJ1c2VySWQiOiJhNzJjYzZlNSIsInRva2VucyI6W10sIl9pZCI6IjY2NWRlZjAyNjBkNzdiNDViMWNjZDZlYiIsImlhdCI6MTcxNzQzMjA2NiwiZXhwIjoxNzE4MDM2ODY2fQ.uYtnFu8WHGe8-8EQZ2FzVC3lY4RB4UgWf3d3JruCOLc";
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = await prefs.getString(appString.appversion);
    if (data != null) {
      return stringToMap(data);
    }
    return null;
  }

  static Future AppInfo(String? value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(appString.appversion, value!);
  }

  static Future removeToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.remove(appString.tokenKey);
  }
}
