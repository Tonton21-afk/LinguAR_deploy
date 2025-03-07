import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lingua_arv1/repositories/Config.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'dart:convert';
import 'get_started_page5.dart';

class GetStartedPage4 extends StatefulWidget {
  @override
  _GetStartedPage4State createState() => _GetStartedPage4State();
}

class _GetStartedPage4State extends State<GetStartedPage4> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _voiceText = '';
  String baseurl = BasicUrl.baseURL;

  Future<void> _sendVoiceData(String voiceData, BuildContext context) async {
    final url = Uri.parse('$baseurl/recognize');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'voice_data': voiceData}),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['recognized'] == true) {
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
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      status = await Permission.microphone.request();
    }

    if (status.isGranted) {
      bool available = await _speech.initialize();
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

  void _stopListening() {
    if (_isListening) {
      _speech.stop();
      setState(() => _isListening = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final bool isLargeScreen = screenWidth > 600;

    return Scaffold(
      backgroundColor: Color(0xFFFEFEFF),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: isLargeScreen ? 32 : screenWidth * 0.05,
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
              SizedBox(height: screenHeight * 0.03),
              IconButton(
                icon: Icon(
                  _isListening ? Icons.mic : Icons.mic_none,
                  size: isLargeScreen ? 100 : screenWidth * 0.2,
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
              SizedBox(height: screenHeight * 0.03),
              Text(
                _voiceText,
                style: TextStyle(
                  fontSize: isLargeScreen ? 24 : screenWidth * 0.04,
                  color: Colors.black,
                ),
              ),
              // SizedBox(height: screenHeight * 0.05),
              // ElevatedButton(
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Colors.red,
              //     padding: EdgeInsets.symmetric(
              //       vertical: screenHeight * 0.02,
              //       horizontal:
              //           isLargeScreen ? screenWidth * 0.05 : screenWidth * 0.1,
              //     ),
              //   ),
              //   onPressed: () {
              //     Navigator.pushReplacement(
              //       context,
              //       MaterialPageRoute(builder: (context) => GetStartedPage5()),
              //     );
              //   },
              //   child: Text(
              //     "DEBUG: Skip Voice Detection",
              //     style: TextStyle(
              //       color: Colors.white,
              //       fontSize: isLargeScreen ? 24 : screenWidth * 0.04,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
