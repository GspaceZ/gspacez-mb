import 'package:shared_preferences/shared_preferences.dart';

class TokenDataSource {
  TokenDataSource._privateConstructor();

  static final TokenDataSource _instance =
      TokenDataSource._privateConstructor();

  static TokenDataSource get instance => _instance;

  static const _tokenKey = 'userToken';

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}
