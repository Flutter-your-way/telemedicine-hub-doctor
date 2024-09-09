import 'package:shared_preferences/shared_preferences.dart';

class LocalDataManager {
  static const String _loginKey = "LOGINKEY";
  static const String _splashKey = "Splash";
  static const String _refreshToken = "RefershToken";

  static Future<bool> storeToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_loginKey, token);
  }

  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_loginKey);
  }

  static Future<bool> deleteToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(_loginKey);
  }

  static Future<bool> storeRefreshToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_refreshToken, token);
  }

  static Future<String?> getRefreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshToken);
  }

  static Future<bool> deleteRefreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(_refreshToken);
  }

  static Future<bool> appOpened() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_splashKey) ?? false;
  }

  static Future<bool> setOpened(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(_splashKey, value);
  }

  static Future<bool> deleteOpened() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(_splashKey);
  }
}
