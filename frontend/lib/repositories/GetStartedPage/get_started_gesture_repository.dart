import 'dart:typed_data';

abstract class GestureRepository {
  Future<String> detectGesture(Uint8List imageBytes);
}