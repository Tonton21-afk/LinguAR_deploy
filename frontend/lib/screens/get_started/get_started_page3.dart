import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:camera/camera.dart';
import 'package:lingua_arv1/bloc/Get_Started_Gesture/get_started_gesture_bloc.dart';
import 'package:lingua_arv1/repositories/GetStartedPage/get_started_gesture_repository_impl.dart';
import 'dart:typed_data';
import 'get_started_page4.dart';
import 'dart:async';

class GetStartedPage3 extends StatefulWidget {
  @override
  _GetStartedPage3State createState() => _GetStartedPage3State();
}

class _GetStartedPage3State extends State<GetStartedPage3> {
  CameraController? _cameraController;
  List<CameraDescription>? cameras;
  Timer? _timer;
  bool isNavigating = false;
  final GlobalKey<_GetStartedPage3State> _globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    _cameraController = CameraController(
      cameras![1],
      ResolutionPreset.medium,
    );
    await _cameraController!.initialize();
    if (!mounted) return;
    setState(() {});

    _startAutomaticDetection();
  }

  void _startAutomaticDetection() {
    _timer = Timer.periodic(Duration(seconds: 2), (timer) async {
      if (_cameraController != null &&
          _cameraController!.value.isInitialized &&
          !isNavigating) {
        final XFile imageFile = await _cameraController!.takePicture();
        final Uint8List imageBytes = await imageFile.readAsBytes();

        if (mounted) {
          _globalKey.currentContext
              ?.read<GestureBloc>()
              .add(DetectGestureEvent(imageBytes: imageBytes));
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double circleSize =
        screenWidth > 600 ? screenWidth * 0.4 : screenWidth * 0.7;
    double fontSize = screenWidth > 600 ? 28 : 20;

    return BlocProvider(
      create: (context) => GestureBloc(GestureRepositoryImpl()),
      child: Scaffold(
        key: _globalKey,
        backgroundColor: Color(0xFFFEFEFF),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Place your hand inside the circle",
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screenHeight * 0.02),

                // Circular Camera Preview
                if (_cameraController != null &&
                    _cameraController!.value.isInitialized)
                  Container(
                    width: circleSize,
                    height: circleSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF4A90E2),
                      border: Border.all(
                        color: Color(0xFF4A90E2),
                        width: screenWidth > 600 ? 8 : 5,
                      ),
                    ),
                    child: ClipOval(child: CameraPreview(_cameraController!)),
                  )
                else
                  Container(
                    width: circleSize,
                    height: circleSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black12,
                      border: Border.all(
                        color: Color(0xFF4A90E2),
                        width: screenWidth > 600 ? 8 : 5,
                      ),
                    ),
                    child: Center(child: CircularProgressIndicator()),
                  ),

                SizedBox(height: screenHeight * 0.05),
                BlocBuilder<GestureBloc, GestureState>(
                  builder: (context, state) {
                    String detectedLabel = 'Waiting for gesture...';
                    if (state is GestureDetected) detectedLabel = state.label;
                    if (state is GestureError) detectedLabel = state.message;

                    return Text(
                      detectedLabel,
                      style: TextStyle(fontSize: screenWidth > 600 ? 32 : 24),
                    );
                  },
                ),

                SizedBox(height: screenHeight * 0.05),
                ElevatedButton(
                  onPressed: () {
                    _timer?.cancel();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GetStartedPage4()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.02,
                      horizontal: screenWidth > 600
                          ? screenWidth * 0.05
                          : screenWidth * 0.1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(screenWidth > 600 ? 16 : 12),
                    ),
                  ),
                  child: Text(
                    'DEBUG: Skip Gesture Detection',
                    style: TextStyle(
                      fontSize: screenWidth > 600 ? 24 : 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
