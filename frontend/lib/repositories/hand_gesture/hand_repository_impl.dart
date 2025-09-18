// lib/repository/gesture_repository_impl.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:lingua_arv1/model/hand_model.dart';
import 'package:lingua_arv1/repositories/Config.dart';
import 'package:lingua_arv1/repositories/hand_gesture/hand_repository.dart';

class HandRepositoryImpl implements HandRepository {
  String baseUrl = GestureUrl.baseURL;

  HandRepositoryImpl() {
    print('[HandRepositoryImpl] baseUrl = $baseUrl');
  }

  @override
  Future<GestureModel> recognizeGesture(String imagePath) async {
    try {
      print('[HandRepositoryImpl] Starting recognizeGesture');
      print('[HandRepositoryImpl] imagePath = $imagePath');

      // Read the image file
      final file = File(imagePath);
      if (!file.existsSync()) {
        print('[HandRepositoryImpl] ❌ File not found: $imagePath');
      }
      final bytes = await file.readAsBytes();
      print('[HandRepositoryImpl] Read ${bytes.length} bytes from image');

      // Create a multipart request
      final uri = Uri.parse('$baseUrl/gesture/hands');
      print('[HandRepositoryImpl] POST -> $uri');

      var request = http.MultipartRequest('POST', uri);
      request.files.add(http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: 'image.jpg',
      ));
      print('[HandRepositoryImpl] Added file field "file" with ${bytes.length} bytes');

      // Send the request
      var response = await request.send();
      print('[HandRepositoryImpl] Response status = ${response.statusCode}');

      // Check the response
      final responseData = await response.stream.bytesToString();
      print('[HandRepositoryImpl] Response body = $responseData');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(responseData);
        print('[HandRepositoryImpl] ✅ Parsed JSON = $jsonResponse');
        return GestureModel.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to recognize gesture: ${response.statusCode}');
      }
    } catch (e) {
      print('[HandRepositoryImpl] ❌ Exception: $e');
      throw Exception('Error: $e');
    }
  }
}
