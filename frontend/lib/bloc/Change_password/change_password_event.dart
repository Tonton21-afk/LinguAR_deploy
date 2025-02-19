part of 'change_password_bloc.dart';

abstract class ChangePasswordEvent {}

class ResetPasswordEvent extends ChangePasswordEvent {
  final String email;
  final String otp;
  final String newPassword;

  ResetPasswordEvent({
    required this.email,
    required this.otp,
    required this.newPassword,
  });
}