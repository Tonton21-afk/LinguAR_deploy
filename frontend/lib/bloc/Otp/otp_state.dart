part of 'otp_bloc.dart';

abstract class OtpState {}

class OtpInitial extends OtpState {}

class OtpLoading extends OtpState {}

class OtpSentSuccess extends OtpState {}

class OtpSentFailure extends OtpState {}

class OtpVerifiedSuccess extends OtpState {}

class OtpVerifiedFailure extends OtpState {}