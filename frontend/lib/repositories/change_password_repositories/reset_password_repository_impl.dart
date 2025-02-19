import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lingua_arv1/repositories/Config.dart';
import 'package:lingua_arv1/repositories/change_password_repositories/reset_password_repository.dart';

class PasswordRepositoryImpl implements ResetPasswordRepository {
  String baseUrl = Otp.baseURL;

  @override
  Future<bool> resetPassword(
      String email, String otp, String newPassword) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/reset-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'otp': otp,
        'new_password': newPassword,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to reset password: ${response.body}');
    }
  }
}
