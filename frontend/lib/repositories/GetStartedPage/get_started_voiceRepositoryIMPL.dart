import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lingua_arv1/repositories/Config.dart';
import 'package:lingua_arv1/repositories/GetStartedPage/get_started_voiceRepository.dart';

class VoiceRepositoryImpl implements VoiceRepository {
  String baseUrl = BasicUrl.baseURL;

  @override
  Future<Map<String, dynamic>> sendVoiceData(String voiceData) async {
    final url = Uri.parse('$baseUrl/recognize');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'voice_data': voiceData}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to send voice data');
    }
  }
}
