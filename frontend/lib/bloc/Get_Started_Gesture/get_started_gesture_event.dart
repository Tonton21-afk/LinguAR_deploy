part of 'get_started_gesture_bloc.dart';


abstract class GestureEvent {}

class DetectGestureEvent extends GestureEvent {
  final Uint8List imageBytes;

  DetectGestureEvent({required this.imageBytes});
}