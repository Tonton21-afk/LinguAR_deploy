
import 'package:lingua_arv1/model/hand_model.dart';

abstract class HandRepository {
  Future<GestureModel> recognizeGesture(String imagePath);
}
