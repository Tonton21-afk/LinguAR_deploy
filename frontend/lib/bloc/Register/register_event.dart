part of 'register_bloc.dart';

abstract class RegisterEvent {}

class RegisterButtonPressed extends RegisterEvent {
  final String email;
  final String password;
  final String? disability; 
  
  RegisterButtonPressed({
    required this.email,
    required this.password,
    this.disability, 
  });
}