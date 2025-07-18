import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:lingua_arv1/repositories/Config.dart';

class GestureWordTab extends StatefulWidget {
  final List<CameraDescription> cameras;
  final bool isActive;

  const GestureWordTab({
    required this.cameras,
    required this.isActive,
    Key? key,
  }) : super(key: key);

  @override
  _GestureWordTabState createState() => _GestureWordTabState();
}

class _GestureWordTabState extends State<GestureWordTab> with WidgetsBindingObserver {
  CameraController? _cameraController;
  int _cameraIndex = 1;
  String predictedCharacter = "";
  bool isPredicting = false;
  String url = BasicUrl.baseURL;
  String formedWord = "";
  bool _isFlipping = false;
  bool _isMounted = true;
  bool _stopPrediction = false;
  Timer? _predictionTimer;
  bool _isCameraReady = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (widget.isActive) {
      _initializeCamera();
    }
  }

  @override
  void didUpdateWidget(GestureWordTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _initializeCamera();
    } else if (!widget.isActive && oldWidget.isActive) {
      _stopCamera();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_isMounted) return;
    
    if (state == AppLifecycleState.inactive) {
      _stopCamera();
    } else if (state == AppLifecycleState.resumed && widget.isActive) {
      _initializeCamera();
    }
  }

  Future<void> _stopCamera() async {
    _stopPrediction = true;
    _predictionTimer?.cancel();
    if (_cameraController != null) {
      await _cameraController?.dispose();
    }
    if (_isMounted) {
      setState(() {
        _isCameraReady = false;
      });
    }
  }

  Future<void> _initializeCamera() async {
    if (!_isMounted || !widget.isActive) return;

    setState(() {
      _isFlipping = true;
      _stopPrediction = true;
      _isCameraReady = false;
    });

    try {
      if (_cameraController != null) {
        await _cameraController!.dispose();
      }

      _cameraController = CameraController(
        widget.cameras[_cameraIndex],
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _cameraController!.initialize();
      
      if (!_isMounted || !widget.isActive) return;

      setState(() {
        _isFlipping = false;
        _stopPrediction = false;
        _isCameraReady = true;
      });

      _startPredictionTimer();
    } catch (e) {
      print("❌ Camera initialization failed: $e");
      if (_isMounted) {
        setState(() {
          _isFlipping = false;
        });
        Future.delayed(Duration(seconds: 1), _initializeCamera);
      }
    }
  }

  void _startPredictionTimer() {
    _predictionTimer?.cancel();
    _predictionTimer = Timer.periodic(Duration(seconds: 2), (timer) async {
      if (!_stopPrediction && _isMounted && widget.isActive) {
        await _predictGesture();
      }
    });
  }

  Future<void> _predictGesture() async {
    if (isPredicting || !_isMounted || !_isCameraReady || _stopPrediction || !widget.isActive) {
      return;
    }

    setState(() => isPredicting = true);

    try {
      XFile? imageFile = await _cameraController!.takePicture();
      Uint8List imageBytes = await imageFile.readAsBytes();

      var request = http.MultipartRequest('POST', Uri.parse('$url/gesture/hands'));
      request.files.add(http.MultipartFile.fromBytes('file', imageBytes,
          filename: "gesture.jpg"));

      var response = await request.send();
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(await response.stream.bytesToString());
        if (_isMounted) {
          setState(() => predictedCharacter = jsonResponse["predicted_character"]);
        }
      } else {
        print("❌ API Error: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Prediction error: $e");
      if (_isMounted && !_stopPrediction && widget.isActive) {
        await _initializeCamera();
      }
    } finally {
      if (_isMounted) {
        setState(() => isPredicting = false);
      }
    }
  }

  void _addToWord() {
    if (_isMounted) {
      setState(() => formedWord += predictedCharacter);
    }
  }

  void _clearWord() {
    if (_isMounted) {
      setState(() => formedWord = "");
    }
  }

  Future<void> _flipCamera() async {
    if (_isFlipping || !_isMounted) return;

    setState(() => _cameraIndex = (_cameraIndex == 0) ? 1 : 0);
    await _initializeCamera();
  }

  @override
  void dispose() {
    _isMounted = false;
    WidgetsBinding.instance.removeObserver(this);
    _stopPrediction = true;
    _predictionTimer?.cancel();
    _cameraController?.dispose().then((_) {
      _cameraController = null;
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (_isCameraReady && _cameraController != null)
          Center(
            child: AspectRatio(
              aspectRatio: _cameraController!.value.aspectRatio,
              child: CameraPreview(_cameraController!),
            ),
          )
        else
          Center(child: CircularProgressIndicator()),
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text("Predicted Character:",
                    style: TextStyle(fontSize: 18, color: Colors.white)),
                SizedBox(height: 8),
                Text(predictedCharacter,
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue)),
                SizedBox(height: 20),
                Text("Formed Word:",
                    style: TextStyle(fontSize: 18, color: Colors.white)),
                SizedBox(height: 8),
                Text(formedWord,
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue)),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _addToWord,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                      child: Text(
                        "Add to Word",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                    SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: _clearWord,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                      child: Text(
                        "Clear Word",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: IconButton(
            icon: Icon(Icons.cameraswitch, color: Colors.white),
            onPressed: _flipCamera,
          ),
        ),
      ],
    );
  }
}