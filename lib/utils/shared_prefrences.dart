import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static SharedPreferences prefs;

  void saveToken(String token) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString("token", "Bearer $token");
  }

  void saveValue(String key, String value) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  Future<String> getToken() async {
    prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
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
