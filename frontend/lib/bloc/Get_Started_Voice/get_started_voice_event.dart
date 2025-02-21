part of 'get_started_voice_bloc.dart';
abstract class VoiceEvent {}

class SendVoiceDataEvent extends VoiceEvent {
  final String voiceData;

  SendVoiceDataEvent(this.voiceData);
}