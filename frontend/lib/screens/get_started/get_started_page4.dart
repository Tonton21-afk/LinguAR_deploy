import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'dart:convert';
import 'get_started_page5.dart'; // Import the next page

class GetStartedPage4 extends StatefulWidget {
  @override
  _GetStartedPage4State createState() => _GetStartedPage4State();
}

class _GetStartedPage4State extends State<GetStartedPage4> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _voiceText = '';

  // Function to send voice data to the backend
  Future<void> _sendVoiceData(String voiceData, BuildContext context) async {
    final url = Uri.parse('http://192.168.100.66:5000/recognize'); // Replace with your backend URL
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'voice_data': voiceData}),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['recognized'] == true) {
        // Navigate to the next page if voice is recognized
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => GetStartedPage5()),
        );
      }
    } else {
      print('Failed to recognize voice');
    }
  }

void _startListening() async {
  // Check and request microphone permission
  var status = await Permission.microphone.status;
  if (!status.isGranted) {
    status = await Permission.microphone.request();
  }

  if (status.isGranted) {
    bool available = await _speech.initialize();
    print('Speech recognition available: $available'); // Debug log
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (result) {
          setState(() {
            _voiceText = result.recognizedWords;
          });

          if (_voiceText.toLowerCase().contains('mabuhay')) {
            _sendVoiceData(_voiceText, context);
          }
        },
      );
    } else {
      print('Speech recognition not available on this device');
    }
  } else {
    print('Microphone permission denied');
  }
}
  // Function to stop listening
  void _stopListening() {
    if (_isListening) {
      _speech.stop();
      setState(() => _isListening = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFEFEFF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(text: 'Say '),
                  TextSpan(
                    text: '“Mabuhay”',
                    style: TextStyle(color: Colors.blue),
                  ),
                  TextSpan(text: '\nto recognize your\nvoice'),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Microphone icon button
            IconButton(
              icon: Icon(
                _isListening ? Icons.mic : Icons.mic_none,
                size: 100,
                color: _isListening ? Colors.green : Color(0xFF4A90E2),
              ),
              onPressed: () {
                if (_isListening) {
                  _stopListening();
                } else {
                  _startListening();
                }
              },
            ),
            SizedBox(height: 20),
            // Display recognized text
            Text(
              _voiceText,
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () async {
                // Simulate voice input (for debugging)
                String simulatedVoiceInput = "Mabuhay";
                await _sendVoiceData(simulatedVoiceInput, context);
              },
              child: Text(
                "DEBUG: Skip Voice Detection",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}