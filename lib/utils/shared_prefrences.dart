import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static late SharedPreferences prefs;

  void saveToken(String? token) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString("token", "Bearer $token");
  }

  Future<dynamic> setValue(String key, dynamic value) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  Future<dynamic> setBoolValue(String key, bool value) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  Future<dynamic> setDoubleValue(String key, double value) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setDouble(key, value);
  }

  Future<String?> getToken() async {
    prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<dynamic> getValue(String key) async {
    prefs = await SharedPreferences.getInstance();
    return prefs.get(key);
  }

  removeValue(String key) async {
    prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  clearSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<bool> checkValue(String key) async {
    prefs = await SharedPreferences.getInstance();

    bool present = prefs.containsKey(key);
    return present;
  }
}
