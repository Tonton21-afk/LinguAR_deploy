import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lingua_arv1/repositories/change_email_repositories/change_email_repository.dart';
import 'package:meta/meta.dart';
part 'change_email_event.dart';
part 'change_email_state.dart';

class ResetEmailBloc extends Bloc<ResetEmailEvent, ResetEmailState> {
  final ResetEmailRepository _repository;

  ResetEmailBloc(this._repository) : super(ResetEmailInitial()) {
    on<SubmitResetEmail>(_onSubmitResetEmail);
  }

  Future<void> _onSubmitResetEmail(
      SubmitResetEmail event, Emitter<ResetEmailState> emit) async {
    emit(ResetEmailLoading());
    try {
      final message = await _repository.resetEmail(
        email: event.email,
        otp: event.otp,
        newEmail: event.newEmail,
      );
      emit(ResetEmailSuccess(message));
    } catch (e) {
      emit(ResetEmailFailure(e.toString()));
    }
  }
}