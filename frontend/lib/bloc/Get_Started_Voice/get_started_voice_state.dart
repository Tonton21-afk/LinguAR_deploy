part of 'get_started_voice_bloc.dart';
abstract class VoiceState {}

class VoiceInitial extends VoiceState {}

class VoiceLoading extends VoiceState {}

class VoiceRecognized extends VoiceState {}

class VoiceError extends VoiceState {
  final String message;

  VoiceError(this.message);
}