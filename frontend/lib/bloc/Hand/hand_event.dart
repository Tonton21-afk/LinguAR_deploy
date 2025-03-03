part of 'hand_bloc.dart';

abstract class HandEvent {}

class InitializeCameraEvent extends HandEvent {}

class StartPredictionEvent extends HandEvent {}

class StopPredictionEvent extends HandEvent {}

class RecognizeHandEvent extends HandEvent {
  final String imagePath;
  RecognizeHandEvent(this.imagePath);
}