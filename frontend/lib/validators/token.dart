import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class TokenService {
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'auth_user_id';

  /// Save the JWT token and extract the user ID (_id from MongoDB)
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);

    // Decode JWT and extract user ID
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    print("Decoded Token: $decodedToken"); // ✅ Debugging

    String? userId = decodedToken['_id']; // ✅ Now _id exists!

    if (userId != null) {
      await prefs.setString(_userIdKey, userId);
      print("User ID Saved: $userId"); // ✅ Debugging
    } else {
      print("Error: _id not found in token!"); // This should no longer appear
    }
  }

  /// Get the stored user ID (_id from MongoDB)
  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString(_userIdKey);
    print(
        "Retrieved User ID: $userId"); // ✅ Debugging: Check if user ID is retrieved
    return userId;
  }

  /// Logout function to clear token and user ID
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userIdKey);
    print("User logged out, token and user ID removed."); // Debugging
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
