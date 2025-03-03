// lib/repository/gesture_repository_impl.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:lingua_arv1/model/hand_model.dart';
import 'package:lingua_arv1/repositories/Config.dart';
import 'package:lingua_arv1/repositories/hand_gesture/hand_repository.dart';


class HandRepositoryImpl implements HandRepository {
  String baseUrl = BasicUrl.baseURL;

  @override
  Future<GestureModel> recognizeGesture(String imagePath) async {
    try {
      // Read the image file
      final file = File(imagePath);
      final bytes = await file.readAsBytes();

      // Create a multipart request
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/gesture/hands'));
      request.files.add(http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: 'image.jpg',
      ));

      // Send the request
      var response = await request.send();

      // Check the response
      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final jsonResponse = jsonDecode(responseData);
        return GestureModel.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to recognize gesture: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}