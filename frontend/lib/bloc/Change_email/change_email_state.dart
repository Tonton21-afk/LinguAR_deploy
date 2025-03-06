part of 'change_email_bloc.dart';

abstract class ResetEmailState extends Equatable {
  @override
  List<Object> get props => [];
}

class ResetEmailInitial extends ResetEmailState {}

class ResetEmailLoading extends ResetEmailState {}

class ResetEmailSuccess extends ResetEmailState {
  final String message;

  ResetEmailSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class ResetEmailFailure extends ResetEmailState {
  final String error;

  ResetEmailFailure(this.error);

  @override
  List<Object> get props => [error];
}