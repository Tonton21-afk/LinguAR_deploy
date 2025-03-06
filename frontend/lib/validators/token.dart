import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenService {
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'auth_user_id';
  static const String _emailKey = 'auth_email'; // ✅ Store Email

  /// Save the JWT token and extract user ID & email
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    print("Decoded Token: $decodedToken"); // Debugging

    String? userId = decodedToken['_id'];
    String? email = decodedToken['email']; // ✅ Extract Email

    if (userId != null) {
      await prefs.setString(_userIdKey, userId);
      print("User ID Saved: $userId");
    } else {
      print("Error: _id not found in token!");
    }

    if (email != null) {
      await prefs.setString(_emailKey, email);
      print("Email Saved: $email");
    }
  }

  /// Get the stored email
  static Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey);
  }

  /// Get the stored user ID
  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  /// Logout - Clear token, user ID, and email
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_emailKey);
    print("User logged out, token, email, and user ID removed.");
  }

  /// Get the stored JWT token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// Check if user is logged in
  static Future<bool> isUserLoggedIn() async {
    final token = await getToken();
    return token != null && !JwtDecoder.isExpired(token);
  }
}
