import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'get_started_page4.dart';
import 'dart:async'; // Import for Timer

class GetStartedPage3 extends StatefulWidget {
  @override
  _GetStartedPage3State createState() => _GetStartedPage3State();
}

class _GetStartedPage3State extends State<GetStartedPage3> {
  String detectedLabel = 'Waiting for gesture...';
  CameraController? _cameraController;
  List<CameraDescription>? cameras;
  Timer? _timer; // Timer for automatic detection

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    _cameraController = CameraController(
      cameras![0],
      ResolutionPreset.medium,
    );
    await _cameraController!.initialize();
    if (!mounted) return;
    setState(() {});

    // Start automatic gesture detection
    _startAutomaticDetection();
  }

  void _startAutomaticDetection() {
    // Set a timer to capture and process images every 2 seconds
    _timer = Timer.periodic(Duration(seconds: 2), (timer) async {
      if (_cameraController != null && _cameraController!.value.isInitialized) {
        await detectGesture();
      }
    });
  }

  Future<void> detectGesture() async {
    try {
      final XFile imageFile = await _cameraController!.takePicture();
      final Uint8List imageBytes = await imageFile.readAsBytes();

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('http://127.0.0.1:5000/detect'),
      );

      // Add the image file to the request
      request.files.add(http.MultipartFile.fromBytes(
        'image',
        imageBytes,
        filename: 'gesture_image.jpg',
      ));

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final Map<String, dynamic> data = json.decode(responseData);
        String label = data['label'];

        setState(() {
          detectedLabel = label;
        });

        // Navigate based on label using Navigator.push()
        if (RegExp(r'^[A-Z]$').hasMatch(label)) {
          _timer?.cancel(); // Stop the timer before navigating
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GetStartedPage4()),
          );
        }
      } else {
        throw Exception('Failed to detect gesture');
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return Scaffold(
        backgroundColor: Color(0xFF273236),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Color(0xFFFEFEFF),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Place your hand inside the circle",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // Circular Container with Camera Preview
            Container(
              width: 350, // Adjust the size of the circle
              height: 350, // Adjust the size of the circle
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF4A90E2),
                border: Border.all(
                  color: Color(0xFF4A90E2),
                  width: 5,
                ),
              ),
              child: ClipOval(
                child: CameraPreview(_cameraController!),
              ),
            ),
            SizedBox(height: 40),
            Text(detectedLabel, style: TextStyle(fontSize: 24)),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GetStartedPage4()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Text('DEBUG: Skip Gesture Detection',
                  style: TextStyle(fontSize: 14, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
