import 'package:shared_preferences/shared_preferences.dart';

class PrefService {
  static const String _keyName = 'user_name';
  static const String _keyId = 'user_id';
  static const String _keyToken = 'user_token';
  static const String _keyEmail = 'user_email';

  static Future<void> saveUserLogin({
    required String id,
    required String token,
    String? name,
    String? email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyId, id);
    await prefs.setString(_keyToken, token);
    if (name != null && name.isNotEmpty) {
      await prefs.setString(_keyName, name);
    }
    if (email != null && email.isNotEmpty) {
      await prefs.setString(_keyEmail, email);
    }
  }

  static Future<String?> getName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyName);
  }

  static Future<String?> getId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyId);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  static Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyEmail);
  }

  static Future<bool> isLoggedIn() async {
    final id = await getId();
    final token = await getToken();
    return (id != null && id.isNotEmpty) &&
        (token != null && token.isNotEmpty);
  }

  static Future<void> clearUserLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyName);
    await prefs.remove(_keyId);
    await prefs.remove(_keyToken);
    await prefs.remove(_keyEmail);
  }
}
