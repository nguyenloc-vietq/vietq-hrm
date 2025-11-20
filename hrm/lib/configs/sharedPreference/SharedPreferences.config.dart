import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesConfig {
  static late SharedPreferences _prefs;

  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  //getter setter users
  static String? get users => _prefs.getString('users');
  static set users(String? value) => _prefs.setString('users', value ?? '');
  static String? get userProfile => _prefs.getString('user-profile');
  static set userProfile(String? value) => _prefs.setString('user-profile', value ?? '');
  //getter setter themes
  static bool get darkMode => _prefs.getBool('darkMode') ?? false;
  static set darkMode(bool value) => _prefs.setBool('darkMode', value);

  static bool get allowNotification => _prefs.getBool('allowNotification') ?? true;
  static set allowNotification(bool value) => _prefs.setBool('allowNotification', value);
  static Color get themeColor {
    int colorValue = _prefs.getInt('themeColor') ?? 0xFFF6C951; // default
    return Color(colorValue);
  }

  // Lưu màu
  static set themeColor(Color color) {
    _prefs.setInt('themeColor', color.value);
  }
  //delete all preferences
  static Future deleteAll() async => _prefs.clear();

  //delete preferences
  static Future delete(String key) async => _prefs.remove(key);

  //add preferences
  static Future add(String key, String value) async => _prefs.setString(key, value);
}
