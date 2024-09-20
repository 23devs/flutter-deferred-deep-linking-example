import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();
  static const String wasLaunchedBeforeKey = 'launched';

  Future<void> setBoolValue(String key, bool value) async {
    await asyncPrefs.setBool(key, value);
  }

  Future<bool> getBoolValue(String key) async {
    bool? value = await asyncPrefs.getBool(wasLaunchedBeforeKey);
    return value ?? false;
  }
}
