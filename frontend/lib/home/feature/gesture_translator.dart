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
  String predictedCharacter = "";
  bool isPredicting = false;
  String url = BasicUrl.baseURL;
  String formedWord = ""; // Holds the word being formed

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    _cameraController = CameraController(_cameras![1], ResolutionPreset.medium);
    await _cameraController!.initialize();
    if (!mounted) return;
    setState(() {});
    _startPrediction();
  }

  void _startPrediction() async {
    while (mounted) {
      if (!isPredicting) {
        setState(() {
          isPredicting = true;
        });

        XFile? imageFile = await _cameraController!.takePicture();
        Uint8List imageBytes = await imageFile.readAsBytes();

        var request =
            http.MultipartRequest('POST', Uri.parse('$url/gesture/hands'));
        request.files.add(http.MultipartFile.fromBytes('file', imageBytes,
            filename: "gesture.jpg"));

        var response = await request.send();
        if (response.statusCode == 200) {
          var jsonResponse = jsonDecode(await response.stream.bytesToString());
          setState(() {
            predictedCharacter = jsonResponse["predicted_character"];
          });
        }

        setState(() {
          isPredicting = false;
        });

        await Future.delayed(Duration(seconds: 2));
      }
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  void _addToWord() {
    setState(() {
      formedWord += predictedCharacter; // Add latest prediction to the word
    });
  }

  void _clearWord() {
    setState(() {
      formedWord = ""; // Clear the formed word
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.black, // Set background to black for full-screen effect
      appBar: AppBar(
        title: const Text('Gesture Translator'),
        centerTitle: true,
        backgroundColor: Colors.transparent, // Make app bar transparent
        elevation: 0, // Remove shadow
      ),
      body: Stack(
        children: [
          // Full-screen camera preview with correct aspect ratio
          if (_cameraController != null &&
              _cameraController!.value.isInitialized)
            Center(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width *
                      _cameraController!.value.aspectRatio,
                  child: CameraPreview(_cameraController!),
                ),
              ),
            )
          else
            Center(child: CircularProgressIndicator()),

          // Overlay UI elements
          Positioned(
            bottom: 20, // Position at the bottom of the screen
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
                  Text(
                    "Predicted Character:",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  SizedBox(height: 8),
                  Text(
                    predictedCharacter,
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Formed Word:",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  SizedBox(height: 8),
                  Text(
                    formedWord,
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
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
                          style: TextStyle(fontSize: 16),
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
                          style: TextStyle(fontSize: 16),
                        ),
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
