import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lingua_arv1/repositories/Config.dart';
import 'otp_repository.dart';

class OtpRepositoryImpl implements OtpRepository {
  String baseUrl = BasicUrl.baseURL;

  @override
  Future<bool> sendOtp(String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/otp/send-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to send OTP');
    }
  }

  @override
  Future<bool> verifyOtp(String email, String otp) async {
    final response = await http.post(
      Uri.parse('$baseUrl/otp/verify-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'otp': otp}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Invalid OTP');
    }
  }
}