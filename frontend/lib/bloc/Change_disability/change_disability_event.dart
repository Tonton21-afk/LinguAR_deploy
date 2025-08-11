part of 'change_disability_bloc.dart';

abstract class ChangeDisabilityEvent {}

class UpdateDisabilityEvent extends ChangeDisabilityEvent {
  final String? disability;

  UpdateDisabilityEvent(this.disability);
}