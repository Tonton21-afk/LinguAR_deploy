import 'package:bloc/bloc.dart';
import 'package:lingua_arv1/repositories/change_disability_repositories/change_disability_repository.dart';
part 'change_disability_event.dart';
part 'change_disability_state.dart';

class ChangeDisabilityBloc extends Bloc<ChangeDisabilityEvent, ChangeDisabilityState> {
  final DisabilityRepository disabilityRepository;

  ChangeDisabilityBloc({required this.disabilityRepository}) 
      : super(ChangeDisabilityInitial()) {
    on<UpdateDisabilityEvent>((event, emit) async {
      emit(ChangeDisabilityLoading());
      try {
        // Get user ID from your token service or similar
        final userId = await _getUserId();
        
        final success = await disabilityRepository.updateDisability(
          userId: userId,
          disability: event.disability,
        );

        if (success) {
          emit(ChangeDisabilitySuccess(event.disability));
        } else {
          emit(ChangeDisabilityFailure('Failed to update disability'));
        }
      } catch (e) {
        emit(ChangeDisabilityFailure(e.toString()));
      }
    });
  }

  Future<String> _getUserId() async {
    // Implement your actual user ID retrieval logic
    // Example: return await TokenService.getUserId();
    throw UnimplementedError('User ID retrieval not implemented');
  }
}