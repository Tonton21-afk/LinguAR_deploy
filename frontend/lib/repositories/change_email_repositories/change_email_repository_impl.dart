import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lingua_arv1/repositories/Config.dart';
import 'package:lingua_arv1/repositories/change_email_repositories/change_email_repository.dart';

class ResetEmailRepositoryImpl implements ResetEmailRepository {
  String baseUrl = BasicUrl.baseURL;

  @override
  Future<String> resetEmail({
    required String email,
    required String otp,
    required String newEmail,
  }) async {
    final url = Uri.parse('$baseUrl/auth/reset-email');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'otp': otp, 'new_email': newEmail}),
    );

    if (response.statusCode == 200) {
      return "Email changed successfully";
    } else {
      final data = jsonDecode(response.body);
      throw Exception(data['message'] ?? 'Failed to change email');
    }
  }
}
