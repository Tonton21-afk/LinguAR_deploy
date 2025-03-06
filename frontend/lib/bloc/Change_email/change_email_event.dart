part of 'change_email_bloc.dart';

abstract class ResetEmailEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SubmitResetEmail extends ResetEmailEvent {
  final String email;
  final String otp;
  final String newEmail;

  SubmitResetEmail({
    required this.email,
    required this.otp,
    required this.newEmail,
  });

  @override
  List<Object> get props => [email, otp, newEmail];
}