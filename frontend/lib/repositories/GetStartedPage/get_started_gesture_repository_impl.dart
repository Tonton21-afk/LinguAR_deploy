import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:lingua_arv1/repositories/GetStartedPage/get_started_gesture_repository.dart';

class GestureRepositoryImpl implements GestureRepository {
  final String baseUrl;

  GestureRepositoryImpl({required this.baseUrl});

  @override
  Future<String> detectGesture(Uint8List imageBytes) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/gesture/detect'),
    );

    request.files.add(http.MultipartFile.fromBytes(
      'image',
      imageBytes,
      filename: 'gesture_image.jpg',
    ));

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final Map<String, dynamic> data = json.decode(responseData);
      return data['label'];
    } else {
      throw Exception('Failed to detect gesture');
    }
  }
}