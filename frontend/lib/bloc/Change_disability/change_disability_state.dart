part of 'change_disability_bloc.dart';

abstract class ChangeDisabilityState {}

class ChangeDisabilityInitial extends ChangeDisabilityState {}

class ChangeDisabilityLoading extends ChangeDisabilityState {}

class ChangeDisabilitySuccess extends ChangeDisabilityState {
  final String? disability;

  ChangeDisabilitySuccess(this.disability);
}

class ChangeDisabilityFailure extends ChangeDisabilityState {
  final String error;

  ChangeDisabilityFailure(this.error);
}