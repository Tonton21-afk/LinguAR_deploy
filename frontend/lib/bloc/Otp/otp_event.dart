part of 'otp_bloc.dart';

abstract class OtpEvent {}

class SendOtpEvent extends OtpEvent {
  final String email;

  SendOtpEvent({required this.email});
}

class VerifyOtpEvent extends OtpEvent {
  final String email;
  final String otp;

  VerifyOtpEvent({required this.email, required this.otp});
}