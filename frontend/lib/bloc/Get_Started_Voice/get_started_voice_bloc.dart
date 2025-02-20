import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingua_arv1/repositories/GetStartedPage/get_started_voiceRepository.dart';
part 'get_started_voice_event.dart';
part 'get_started_voice_state.dart';

class VoiceBloc extends Bloc<VoiceEvent, VoiceState> {
  final VoiceRepository _voiceRepository;

  VoiceBloc(this._voiceRepository) : super(VoiceInitial()) {
    on<SendVoiceDataEvent>(_onSendVoiceData);
  }

  Future<void> _onSendVoiceData(
      SendVoiceDataEvent event, Emitter<VoiceState> emit) async {
    emit(VoiceLoading());
    try {
      final response = await _voiceRepository.sendVoiceData(event.voiceData);
      if (response['recognized'] == true) {
        emit(VoiceRecognized());
      } else {
        emit(VoiceError('Voice not recognized'));
      }
    } catch (e) {
      emit(VoiceError('Failed to send voice data: $e'));
    }
  }
}