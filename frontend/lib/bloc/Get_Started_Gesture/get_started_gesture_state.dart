part of 'get_started_gesture_bloc.dart';

abstract class GestureState {}

class GestureInitial extends GestureState {}

class GestureLoading extends GestureState {}

class GestureDetected extends GestureState {
  final String label;

  GestureDetected(this.label);
}

class GestureError extends GestureState {
  final String message;

  GestureError(this.message);
}