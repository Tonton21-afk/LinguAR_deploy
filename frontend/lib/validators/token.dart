// token_service.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decode/jwt_decode.dart';

class TokenService {
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  // Store the token securely
  Future<void> storeToken(String token) async {
    await _storage.write(key: 'token', value: token);
  }

  // Retrieve the token
  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  // Decode the token to get the email
  String getEmailFromToken(String token) {
    Map<String, dynamic> payload = Jwt.parseJwt(token);
    return payload['email']; // Assuming the email is stored in the 'email' claim
  }

  // Clear the token (e.g., on logout)
  Future<void> clearToken() async {
    await _storage.delete(key: 'token');
  }
}