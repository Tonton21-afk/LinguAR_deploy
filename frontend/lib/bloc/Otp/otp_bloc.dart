import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingua_arv1/repositories/otp_repositories/otp_repository.dart';
part 'otp_event.dart';
part 'otp_state.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  final OtpRepository _otpRepository;

  OtpBloc(this._otpRepository) : super(OtpInitial()) {
    // Register event handlers
    on<SendOtpEvent>(_onSendOtpEvent);
    on<VerifyOtpEvent>(_onVerifyOtpEvent);
  }

  Future<void> _onSendOtpEvent(SendOtpEvent event, Emitter<OtpState> emit) async {
    emit(OtpLoading());
    try {
      final success = await _otpRepository.sendOtp(event.email);
      if (success) {
        emit(OtpSentSuccess());
      } else {
        emit(OtpSentFailure());
      }
    } catch (e) {
      emit(OtpSentFailure());
    }
  }

  Future<void> _onVerifyOtpEvent(VerifyOtpEvent event, Emitter<OtpState> emit) async {
    emit(OtpLoading());
    try {
      final success = await _otpRepository.verifyOtp(event.email, event.otp);
      if (success) {
        emit(OtpVerifiedSuccess());
      } else {
        emit(OtpVerifiedFailure());
      }
    } catch (e) {
      emit(OtpVerifiedFailure());
    }
  }
}