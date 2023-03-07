import 'package:shared_preferences/shared_preferences.dart';

abstract class PreferenceManager {
  static String isOpenedApp = "isOpenedApp";

  static SharedPreferences? _prefsInstance;

  static Future<SharedPreferences> get _instance async =>
      _prefsInstance ??= await SharedPreferences.getInstance();

  static Future<SharedPreferences?> init() async {
    _prefsInstance = await _instance;
    return _prefsInstance;
  }

  static String getString(String key, [String? defValue]) {
    return _prefsInstance?.getString(key) ?? defValue ?? "";
  }

  static bool getBool(String key, [bool? defValue]) {
    return _prefsInstance?.getBool(key) ?? defValue!;
  }

  static Future<bool> setString(String key, String value) async {
    var pref = await _instance;
    return pref.setString(key, value);
  }

  static Future<bool> setBool(String key, bool value) async {
    var pref = await _instance;
    return pref.setBool(key, value);
  }

  static clear() async {
    await _prefsInstance?.clear();
  }
}
