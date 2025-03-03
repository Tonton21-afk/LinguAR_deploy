part of 'hand_bloc.dart';

abstract class HandState {}

class HandInitial extends HandState {}

class CameraInitialized extends HandState {
  final CameraController cameraController;
  CameraInitialized(this.cameraController);
}

class HandLoading extends HandState {}

class HandRecognized extends HandState {
  final GestureModel gestureModel;
  HandRecognized(this.gestureModel);
}

class HandError extends HandState {
  final String message;
  HandError(this.message);
}