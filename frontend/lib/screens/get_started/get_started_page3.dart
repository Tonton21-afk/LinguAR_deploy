import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:lingua_arv1/repositories/Config.dart';
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
  String url = BasicUrl.baseURL;

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
    // Set a timer to capture and process images every 2 seconds
    _timer = Timer.periodic(Duration(seconds: 2), (timer) async {
      if (_cameraController != null &&
          _cameraController!.value.isInitialized &&
          !isNavigating) {
        print("Timer triggered: Detecting gesture...");
        await detectGesture();
      } else {
        print("Timer skipped: Camera not initialized or already navigating.");
      }
    });
  }

  Future<void> detectGesture() async {
    try {
      final XFile imageFile = await _cameraController!.takePicture();
      final Uint8List imageBytes = await imageFile.readAsBytes();

      final request = http.MultipartRequest(
        'POST',
        //Uri.parse('http://192.168.100.53:5000/gesture/detect'),
        //Uri.parse('http://192.168.147.118:5000/gesture/detect'),
        Uri.parse('$url/gesture/detect'),
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

        print("Detected label: $label");

        // Navigate based on label using Navigator.push()
        if (RegExp(r'^[A-Z]$').hasMatch(label)) {
          print("Valid gesture detected. Stopping timer and navigating...");
          _timer?.cancel(); // Stop the timer before navigating
          setState(() {
            isNavigating = true; // Mark navigation flag as true
          });
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GetStartedPage4()),
          ).then((_) {
            // This callback runs when the user returns to this page
            print("Navigated back to GetStartedPage3.");
            setState(() {
              isNavigating = false; // Reset the flag if the user comes back
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
    print("Disposing GetStartedPage3...");
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    _cameraController?.dispose(); // Dispose the camera when leaving the page
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Color(0xFF191E20)
          // White button in dark mode
          : Color(0xFFFEFEFF),
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
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white // Dark mode color
                      : Color(0xFF273236)),
            ),
            SizedBox(height: 10),

            // Circular Container with Camera Preview (Only if initialized)
            if (_cameraController != null &&
                _cameraController!.value.isInitialized)
              Container(
                width: 350,
                height: 350,
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
              )
            else
              Container(
                width: 350,
                height: 350,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black12, // Placeholder before camera loads
                  border: Border.all(
                    color: Color(0xFF4A90E2),
                    width: 5,
                  ),
                ),
                child: Center(child: CircularProgressIndicator()),
              ),
            SizedBox(height: 40),
            Text(detectedLabel,
                style: TextStyle(
                    fontSize: 24,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white // Dark mode color
                        : Color(0xFF273236))),
            // SizedBox(height: 40),

            // Button appears immediately
            ElevatedButton(
              onPressed: () {
                print("DEBUG: Skipping gesture detection.");
                _timer?.cancel();
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
