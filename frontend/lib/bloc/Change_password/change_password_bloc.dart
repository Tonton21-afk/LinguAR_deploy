import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingua_arv1/repositories/change_password_repositories/reset_password_repository.dart';
part 'change_password_event.dart';
part 'change_password_state.dart';

class ChangePasswordBloc extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final ResetPasswordRepository _resetpasswordRepository;

  ChangePasswordBloc(this._resetpasswordRepository) : super(ChangePasswordInitial()) {
    on<ResetPasswordEvent>(_onResetPasswordEvent);
  }

  Future<void> _onResetPasswordEvent(ResetPasswordEvent event, Emitter<ChangePasswordState> emit) async {
    emit(ChangePasswordLoading());
    try {
      final success = await _resetpasswordRepository.resetPassword(
        event.email,
        event.otp,
        event.newPassword,
      );
      if (success) {
        emit(ChangePasswordSuccess());
      } else {
        emit(ChangePasswordFailure());
      }
    } catch (e) {
      emit(ChangePasswordFailure());
    }
  }
}