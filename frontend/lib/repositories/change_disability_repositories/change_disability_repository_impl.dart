import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lingua_arv1/repositories/Config.dart';
import 'package:lingua_arv1/repositories/change_disability_repositories/change_disability_repository.dart';
import 'package:lingua_arv1/validators/token.dart';

class DisabilityRepositoryImpl implements DisabilityRepository {
  String url = BasicUrl.baseURL;

  @override
  Future<bool> updateDisability({
    required String userId,
    required String? disability,
  }) async {
    try {
      final token = await TokenService.getToken();
      if (token == null || token.isEmpty) {
        throw Exception("Token not found");
      }

      final response = await http.post(
        Uri.parse('$url/auth/update-disability'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'disability': disability,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to update disability');
      }
    } catch (e) {
      throw Exception('Failed to update disability: ${e.toString()}');
    }
  }
}
