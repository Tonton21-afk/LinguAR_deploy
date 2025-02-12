import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeech extends StatefulWidget {
  @override
  State<TextToSpeech> createState() => _TextToSpeechState();
}

class _TextToSpeechState extends State<TextToSpeech> {
  // Speech-to-Text
  stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _recognizedText = 'Kumusta ka aking kaibigan!';

  // Text-to-Speech
  FlutterTts _flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _initializeSpeech();
    _initializeTts();
  }

  // Initialize Speech-to-Text
  void _initializeSpeech() async {
    bool available = await _speech.initialize(
      onStatus: (status) => print('Speech status: $status'),
      onError: (error) => print('Speech error: $error'),
    );
    if (available) {
      print('Speech-to-Text initialized');
    } else {
      print('Speech-to-Text not available');
    }
  }

  // Initialize Text-to-Speech
  void _initializeTts() async {
    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.5);
    print('Text-to-Speech initialized');
  }

  // Start listening for Speech-to-Text
  void _startListening() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (result) => setState(() {
            _recognizedText = result.recognizedWords;
          }),
        );
      }
    }
  }

  // Stop listening for Speech-to-Text
  void _stopListening() async {
    if (_isListening) {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  // Speak the text using Text-to-Speech
  void _speakText() async {
    await _flutterTts.speak(_recognizedText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Text to Speech'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/illustrations/mic.png',
                width: 190,
                height: 190,
              ),
              const SizedBox(height: 20),
              const Text('Hold the button and speak to display the text.'),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text('Results'),
                  TextButton(
                    onPressed: () {
                      print("See History clicked");
                    },
                    child: Row(
                      children: [
                        Text(
                          'See History',
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                        const Icon(Icons.arrow_forward, size: 20),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                width: 340,
                height: 170,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: Colors.blueAccent,
                    width: 2,
                  ),
                ),
                child: Text(
                  _recognizedText,
                  style: TextStyle(fontSize: 22),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Volume button for Text-to-Speech
                  GestureDetector(
                    onTap: _speakText,
                    child: Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.4),
                            spreadRadius: 2,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.volume_up, // Volume icon
                        size: 32,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(width: 30),

                  // Mic button for Speech-to-Text
                  GestureDetector(
                    onTapDown: (_) {
                      _startListening();
                      print('Mic button pressed');
                    },
                    onTapUp: (_) {
                      _stopListening();
                      print('Mic button released');
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isListening ? Icons.mic : Icons.mic_none,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 30),

                  // Reset button
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _recognizedText = '';
                      });
                      print("Reset button clicked");
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.4),
                            spreadRadius: 2,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.refresh,
                        size: 32,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}