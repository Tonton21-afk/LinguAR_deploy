import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'get_started_page4.dart';

class GetStartedPage3 extends StatefulWidget {
  @override
  _GetStartedPage3State createState() => _GetStartedPage3State();
}

class _GetStartedPage3State extends State<GetStartedPage3> {
  String detectedLabel = 'Waiting for gesture...';

  // Function to send request to Python server and get the label
  Future<void> detectGesture() async {
    try {
      final response =
          await http.get(Uri.parse('http://127.0.0.1:5000/detect'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        String label = data['label'];

        setState(() {
          detectedLabel = label;
        });

        // Navigate based on label using Navigator.push()
        if (RegExp(r'^[A-Z]$').hasMatch(label)) {
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF273236),
      appBar: AppBar(title: Text('Gesture Detection')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF4A90E2),
              ),
              child: Center(
                child: Text(
                  'Step 3',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),
            Text(detectedLabel, style: TextStyle(fontSize: 24)),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: detectGesture,
              child: Text('Detect Gesture'),
            ),
          ],
        ),
      ),
    );
  }
}
