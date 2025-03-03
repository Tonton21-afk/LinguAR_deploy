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

        var request = http.MultipartRequest(
            'POST', Uri.parse('$url/gesture/hands'));
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
    double screenSize = MediaQuery.of(context).size.width * 0.9; // Large square

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Gesture Translator'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_cameraController != null && _cameraController!.value.isInitialized)
            Container(
              width: screenSize,
              height: screenSize, // Large square camera preview
              child: CameraPreview(_cameraController!),
            )
          else
            CircularProgressIndicator(),
          SizedBox(height: 20),
          Text(
            "Predicted: $predictedCharacter",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            "Word: $formedWord",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _addToWord,
                child: Text("Add to Word"),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: _clearWord,
                child: Text("Clear Word"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
