import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lingua_arv1/model/Authentication.dart';
import 'package:lingua_arv1/repositories/register_repositories/register_repository.dart';

class RegisterRepositoryImpl implements RegisterRepository {
  //final String apiUrl = 'http://10.0.2.2:5000/auth/register';
  //final String apiUrl = 'http://127.0.0.1:5000/auth/register';
  // final String apiUrl = 'http://192.168.100.53/auth/register';
  final String apiUrl = 'http://192.168.157.7:5000/auth/register';

  @override
  Future<Authentication> register(String email, String password) async {
    print("Sending registration request to: $apiUrl");
    print("Request payload: {email: $email, password: $password}");

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    print("Register Response Code: ${response.statusCode}");
    print("Register Response Body: ${response.body}");

    if (response.statusCode == 201) {
      // Registration successful
      final responseData = jsonDecode(response.body);
      return Authentication.fromJson({
        'message': responseData['message'],
        'token': '',
        'email': email,
      });
    } else {
      // Handle errors
      final responseData = jsonDecode(response.body);
      throw Exception(responseData['message'] ?? 'Failed to register user');
    }
  }
}
