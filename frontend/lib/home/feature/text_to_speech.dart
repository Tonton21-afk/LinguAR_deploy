import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeech extends StatefulWidget {
  @override
  State<TextToSpeech> createState() => _TextToSpeechState();
}

class _TextToSpeechState extends State<TextToSpeech>
    with SingleTickerProviderStateMixin {
  // Speech-to-Text
  stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _recognizedText = 'Kumusta ka aking kaibigan!';

  // Text-to-Speech
  FlutterTts _flutterTts = FlutterTts();

  // Animation
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _initializeSpeech();
    _initializeTts();

    // Initialize AnimationController
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    // Initialize Animation
    _animation = Tween<double>(begin: 0.0, end: 1.7).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Repeat the animation
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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

  void _initializeTts() async {
    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.5);
    print('Text-to-Speech initialized');
  }

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
        _animationController.forward();
      }
    }
  }

  void _stopListening() async {
    if (_isListening) {
      setState(() => _isListening = false);
      _speech.stop();
      _animationController.reverse();
    }
  }

  void _speakText() async {
    await _flutterTts.speak(_recognizedText);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Text to Speech'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 10 : 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/illustrations/mic.png',
                width: isSmallScreen ? 150 : 190,
                height: isSmallScreen ? 150 : 190,
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
                          style: TextStyle(color: Colors.blue),
                        ),
                        const Icon(Icons.arrow_forward, size: 20),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                width: screenWidth * 0.9,
                height: screenHeight * 0.2,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.blueAccent, width: 2),
                ),
                child: Text(
                  _recognizedText,
                  style: TextStyle(fontSize: isSmallScreen ? 18 : 22),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                  height:
                      isSmallScreen ? 40 : 60), // Increased spacing dynamically
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildIconButton(
                    icon: Icons.volume_up,
                    onTap: _speakText,
                    size: isSmallScreen ? 28 : 32,
                  ),
                  const SizedBox(width: 20),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return Container(
                            width: 80 +
                                (_animation.value * (isSmallScreen ? 30 : 50)),
                            height: 80 +
                                (_animation.value * (isSmallScreen ? 30 : 50)),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blueAccent.withOpacity(0.2),
                            ),
                          );
                        },
                      ),
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
                            size: isSmallScreen ? 50 : 60,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  _buildIconButton(
                    icon: Icons.refresh,
                    onTap: () {
                      setState(() {
                        _recognizedText = '';
                      });
                      print("Reset button clicked");
                    },
                    size: isSmallScreen ? 28 : 32,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton(
      {required IconData icon,
      required VoidCallback onTap,
      required double size}) {
    return GestureDetector(
      onTap: onTap,
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
        child: Icon(icon, size: size, color: Colors.black),
      ),
    );
  }
}
