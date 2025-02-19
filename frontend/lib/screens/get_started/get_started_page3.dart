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
  bool isNavigating = false; // Flag to track if navigation has already occurred

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

    // Start automatic gesture detection
    _startAutomaticDetection();
  }

  void _startAutomaticDetection() {
    _timer = Timer.periodic(Duration(seconds: 2), (timer) async {
      if (_cameraController != null &&
          _cameraController!.value.isInitialized &&
          !isNavigating) {
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
        Uri.parse('http://192.168.157.7:5000/gesture/detect'),
      );

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

        if (RegExp(r'^[A-Z]$').hasMatch(label)) {
          _timer?.cancel();
          setState(() {
            isNavigating = true;
          });
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GetStartedPage4()),
          ).then((_) {
            setState(() {
              isNavigating = false;
            });
          });
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
    _timer?.cancel();
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double circleSize = screenWidth * 0.7;

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
            Text(
              "Place your hand inside the circle",
              style: TextStyle(
                fontSize: screenWidth * 0.05,
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
                    width: 5,
                  ),
                ),
                child: ClipOval(
                  child: CameraPreview(_cameraController!),
                ),
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
                    width: 5,
                  ),
                ),
                child: Center(child: CircularProgressIndicator()),
              ),

            SizedBox(height: screenHeight * 0.05),
            Text(
              detectedLabel,
              style: TextStyle(fontSize: screenWidth * 0.06),
            ),
            SizedBox(height: screenHeight * 0.05),

            ElevatedButton(
              onPressed: () {
                _timer?.cancel();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GetStartedPage4()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.015,
                  horizontal: screenWidth * 0.1,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'DEBUG: Skip Gesture Detection',
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
