import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lingua_arv1/repositories/change_disability_repositories/change_disability_repository_impl.dart';
import 'package:lingua_arv1/validators/token.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'change_disability_event.dart';
part 'change_disability_state.dart';

class ChangeDisabilityBloc
    extends Bloc<ChangeDisabilityEvent, ChangeDisabilityState> {
  final DisabilityRepositoryImpl _disabilityRepository;

  ChangeDisabilityBloc(this._disabilityRepository)
      : super(ChangeDisabilityInitial()) {
    on<UpdateDisabilityEvent>(_onUpdateDisability);
  }

  Future<void> _onUpdateDisability(
    UpdateDisabilityEvent event,
    Emitter<ChangeDisabilityState> emit,
  ) async {
    emit(ChangeDisabilityLoading());
    try {
      final success = await _disabilityRepository.updateDisability(
        userId: event.userId,
        disability: event.disability,
      );

      if (success) {
        final updatedDisability = event.disability ?? "None";

        await TokenService.saveDisability(updatedDisability);

        emit(ChangeDisabilitySuccess(updatedDisability));
      } else {
        emit(const ChangeDisabilityFailure("Failed to update disability"));
      }
    } catch (e) {
      emit(ChangeDisabilityFailure(e.toString()));
    }
  }
}
