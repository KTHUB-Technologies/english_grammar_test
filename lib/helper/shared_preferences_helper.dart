import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const String LANGUAGE_CODE = 'languageCode';
  static const String USER = 'user';

  static saveStringValue(String key, String value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(key, value);
  }

  static saveIntValue(String key, int value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt(key, value);
  }

  static saveListStringValue(String key, List<String> listStrings) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setStringList(key, listStrings);
  }

  static Future<String> getStringValue(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String value = preferences.getString(key) ?? '';
    return value;
  }

  static Future<int> getIntValue(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int value = preferences.getInt(key) ?? 0;
    return value;
  }

  static Future<List<String>> getListString(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String> listString = preferences.getStringList(key);
    return listString;
  }

  remove(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove(key);
  }
}
