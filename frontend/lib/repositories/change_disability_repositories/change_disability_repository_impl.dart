import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lingua_arv1/repositories/Config.dart';
import 'package:lingua_arv1/repositories/change_disability_repositories/change_disability_repository.dart';

class DisabilityRepositoryImpl implements DisabilityRepository {
  String url = BasicUrl.baseURL;

  @override
  Future<bool> updateDisability({
    required String userId,
    required String? disability,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$url/auth/update-disability'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await _getToken()}',
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

  Future<String> _getToken() async {
    // Implement your token retrieval logic here
    // For example:
    // return await TokenService.getToken();
    throw UnimplementedError('Token retrieval not implemented');
  }
}