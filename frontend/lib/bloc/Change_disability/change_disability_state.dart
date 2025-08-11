part of 'change_disability_bloc.dart';

abstract class ChangeDisabilityState extends Equatable {
  const ChangeDisabilityState();

  @override
  List<Object?> get props => [];
}

class ChangeDisabilityInitial extends ChangeDisabilityState {}

class ChangeDisabilityLoading extends ChangeDisabilityState {}

class ChangeDisabilitySuccess extends ChangeDisabilityState {
  final String disability;
  ChangeDisabilitySuccess(this.disability);
}
class ChangeDisabilityFailure extends ChangeDisabilityState {
  final String error;

  const ChangeDisabilityFailure(this.error);

  @override
  List<Object?> get props => [error];
}