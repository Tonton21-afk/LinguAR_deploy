import 'dart:async';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:lingua_arv1/repositories/GetStartedPage/get_started_gesture_repository.dart';

part 'get_started_gesture_event.dart';
part 'get_started_gesture_state.dart';

class GestureBloc extends Bloc<GestureEvent, GestureState> {
  final GestureRepository _gestureRepository;

  GestureBloc( this._gestureRepository) : super(GestureInitial()) {
    on<DetectGestureEvent>(_onDetectGestureEvent);
  }

  Future<void> _onDetectGestureEvent(
    DetectGestureEvent event,
    Emitter<GestureState> emit,
  ) async {
    emit(GestureLoading());
    try {
      final label = await _gestureRepository.detectGesture(event.imageBytes);
      emit(GestureDetected(label));
    } catch (e) {
      emit(GestureError('Failed to detect gesture: $e'));
    }
  }
}