import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:lingua_arv1/repositories/Config.dart';

class GestureTranslator extends StatefulWidget {
  @override
  _GestureTranslatorState createState() => _GestureTranslatorState();
}

class _GestureTranslatorState extends State<GestureTranslator> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  int _cameraIndex = 1;
  String predictedCharacter = "";
  bool isPredicting = false;
  String url = BasicUrl.baseURL;
  String formedWord = "";
  bool _isFlipping = false;
  bool _isMounted = true;
  bool _stopPrediction = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  /// Initializes the camera and restarts prediction
  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();

    // Stop the previous prediction loop
    _stopPrediction = true;

    // Dispose the old camera before creating a new one
    if (_cameraController != null) {
      await _cameraController!.dispose();
    }

    _cameraController = CameraController(
      _cameras![_cameraIndex],
      ResolutionPreset.medium,
      enableAudio: false, // Disable audio for better performance
    );

    try {
      await _cameraController!.initialize();
      if (!_isMounted) return;

      setState(() {
        _isFlipping = false;
        _stopPrediction = false; // Allow prediction again
      });

      // Delay before restarting prediction to avoid conflicts
      Future.delayed(Duration(milliseconds: 500), _startPrediction);
    } catch (e) {
      print("❌ Camera initialization failed: $e");
    }
  }

  /// Flip the camera and restart prediction
  void _flipCamera() async {
    if (_isFlipping || _cameras == null || _cameras!.isEmpty) return;

    setState(() {
      _isFlipping = true;
      _stopPrediction = true; // Stop API calls while flipping
      _cameraIndex = (_cameraIndex == 0) ? 1 : 0;
    });

    await _initializeCamera();
  }

  /// Captures an image and sends it to the API for gesture recognition
  void _startPrediction() async {
    while (_isMounted && !_stopPrediction) {
      if (!isPredicting && _cameraController != null && _cameraController!.value.isInitialized) {
        setState(() {
          isPredicting = true;
        });

        try {
          XFile? imageFile = await _cameraController!.takePicture();
          Uint8List imageBytes = await imageFile.readAsBytes();

          var request = http.MultipartRequest('POST', Uri.parse('$url/gesture/hands'));
          request.files.add(http.MultipartFile.fromBytes('file', imageBytes, filename: "gesture.jpg"));

          var response = await request.send();
          if (response.statusCode == 200) {
            var jsonResponse = jsonDecode(await response.stream.bytesToString());
            setState(() {
              predictedCharacter = jsonResponse["predicted_character"];
            });
          } else {
            print("❌ API Error: ${response.statusCode}");
          }
        } catch (e) {
          print("❌ Prediction error: $e");
        }

        if (_isMounted && !_stopPrediction) {
          setState(() {
            isPredicting = false;
          });
        }

        await Future.delayed(Duration(seconds: 2));
      } else {
        await Future.delayed(Duration(milliseconds: 2000));
      }
    }
  }

  @override
  void dispose() {
    _isMounted = false;
    _stopPrediction = true;
    _cameraController?.dispose();
    super.dispose();
  }

  void _addToWord() {
    setState(() {
      formedWord += predictedCharacter;
    });
  }

  void _clearWord() {
    setState(() {
      formedWord = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Gesture Translator'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.cameraswitch, color: Colors.white),
            onPressed: _flipCamera,
          ),
        ],
      ),
      body: Stack(
        children: [
          if (_cameraController != null && _cameraController!.value.isInitialized)
            Center(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width * _cameraController!.value.aspectRatio,
                  child: CameraPreview(_cameraController!),
                ),
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
                  Text("Predicted Character:", style: TextStyle(fontSize: 18, color: Colors.white)),
                  SizedBox(height: 8),
                  Text(predictedCharacter, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue)),
                  SizedBox(height: 20),
                  Text("Formed Word:", style: TextStyle(fontSize: 18, color: Colors.white)),
                  SizedBox(height: 8),
                  Text(formedWord, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blue)),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _addToWord,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        child: Text("Add to Word", style: TextStyle(fontSize: 16)),
                      ),
                      SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: _clearWord,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        child: Text("Clear Word", style: TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
