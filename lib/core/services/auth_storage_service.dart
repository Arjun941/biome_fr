import 'package:shared_preferences/shared_preferences.dart';

class AuthStorageService {
  static const _tokenKey = 'access_token';
  static const _refreshKey = 'refresh_token';
  static const _userIdKey = 'user_id';
  static const _usernameKey = 'username';
  static const _emailKey = 'email';

  Future<void> saveAuthData({
    required String accessToken,
    required String refreshToken,
    required String userId,
    required String username,
    required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, accessToken);
    await prefs.setString(_refreshKey, refreshToken);
    await prefs.setString(_userIdKey, userId);
    await prefs.setString(_usernameKey, username);
    await prefs.setString(_emailKey, email);
  }

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_refreshKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_usernameKey);
    await prefs.remove(_emailKey);
  }

  Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }
}
