import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lingua_arv1/repositories/Config.dart';

class FavoritesRepository {
  final String baseUrl = BasicUrl.baseURL;

  /// Fetch user's favorite phrases using token authentication
  Future<List<String>> getFavorites(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/favorites'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<String>.from(data['favorites']);
    } else {
      throw Exception('Failed to fetch favorites');
    }
  }

  /// Toggle a phrase as favorite (add/remove)
  Future<void> toggleFavorite(String token, String phrase) async {
    final response = await http.post(
      Uri.parse('$baseUrl/favorites/toggle'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'phrase': phrase}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update favorite');
    }
  }
}
