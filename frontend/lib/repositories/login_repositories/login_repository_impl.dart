import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lingua_arv1/model/Authentication.dart';
import 'package:lingua_arv1/repositories/login_repositories/login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  final String apiUrl = 'http://10.0.2.2:5000/login';

  @override
  Future<Authentication> login(String email, String password) async {
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
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
       print("Decoded Login Response: $responseData");
      return Authentication.fromJson(responseData);
    } else if (response.statusCode == 400) {
      throw Exception('Invalid email or password');
    } else if (response.statusCode == 404) {
      throw Exception('User not found');
    } else {
      throw Exception('Failed to log in');
    }
  }
}
