import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:lingua_arv1/model/hand_model.dart';
import 'package:lingua_arv1/repositories/hand_gesture/hand_repository.dart';
import 'package:meta/meta.dart';

part 'hand_event.dart';
part 'hand_state.dart';

class GestureBloc extends Bloc<HandEvent, HandState> {
  final HandRepository _handRepository;
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isPredicting = false;

  GestureBloc(this._handRepository) : super(HandInitial()) {
    on<InitializeCameraEvent>(_onInitializeCamera);
    on<StartPredictionEvent>(_onStartPrediction);
    on<RecognizeHandEvent>(_onRecognizeGestureEvent);
  }

  /// Initialize Camera
  Future<void> _onInitializeCamera(
    InitializeCameraEvent event,
    Emitter<HandState> emit,
  ) async {
    try {
      _cameras = await availableCameras();
      if (_cameras!.isEmpty) throw Exception("No cameras available");
      _cameraController = CameraController(_cameras!.first, ResolutionPreset.high);
      await _cameraController!.initialize();
      emit(CameraInitialized(_cameraController!));

      /// Start automatic prediction after camera is ready
      add(StartPredictionEvent());
    } catch (e) {
      emit(HandError("Camera initialization failed: ${e.toString()}"));
    }
  }

  /// Start Prediction Loop
  Future<void> _onStartPrediction(
    StartPredictionEvent event,
    Emitter<HandState> emit,
  ) async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      emit(HandError("Camera is not ready"));
      return;
    }

    _isPredicting = true;

    while (_isPredicting) {
      try {
        final XFile file = await _cameraController!.takePicture();
        add(RecognizeHandEvent(file.path)); // Dispatch event for recognition
      } catch (e) {
        emit(HandError("Error capturing image: ${e.toString()}"));
      }
      await Future.delayed(Duration(seconds: 2)); // Adjust delay as needed
    }
  }

  /// Recognize Gesture
  Future<void> _onRecognizeGestureEvent(
    RecognizeHandEvent event,
    Emitter<HandState> emit,
  ) async {
    try {
      final gestureModel = await _handRepository.recognizeGesture(event.imagePath);
      emit(HandRecognized(gestureModel));
    } catch (e) {
      emit(HandError("Error recognizing gesture: ${e.toString()}"));
    }
  }

  /// Dispose camera when Bloc is closed
  @override
  Future<void> close() {
    _cameraController?.dispose();
    return super.close();
  }
}
