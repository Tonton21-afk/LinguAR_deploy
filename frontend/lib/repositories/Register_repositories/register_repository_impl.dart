import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lingua_arv1/model/Authentication.dart';
import 'package:lingua_arv1/repositories/register_repositories/register_repository.dart';

class RegisterRepositoryImpl implements RegisterRepository {
  final String apiUrl = 'http://127.0.0.1:5000/register';

  @override
  Future<Authentication> register(String email, String password) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      return Authentication.fromJson(responseData);  
    } else if (response.statusCode == 400) {
      throw Exception('User already exists');
    } else {
      throw Exception('Failed to register user');
    }
  }
}
