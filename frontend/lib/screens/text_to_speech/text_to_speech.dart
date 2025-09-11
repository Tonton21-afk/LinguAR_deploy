import 'dart:async';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:lingua_arv1/api/3d_models_mapping.dart';

class TextToSpeech extends StatefulWidget {
  @override
  State<TextToSpeech> createState() => _TextToSpeechState();
}

class _TextToSpeechState extends State<TextToSpeech>
    with SingleTickerProviderStateMixin {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();

  bool _isListening = false;
  String _recognizedText = 'Kumusta ka aking kaibigan!';
  bool _isMaleVoice = true;

  late AnimationController _animationController;
  late Animation<double> _animation;

  // NEW: 3D/GIF model state
  List<String> _modelsToShow = [];
  int _currentModelIndex = 0;
  Timer? _modelTimer;
  final Duration _modelFrameDuration = const Duration(seconds: 3);

  @override
  void initState() {
    super.initState();
    _initializeSpeech();
    _initializeTts();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _refreshModelsFromText(_recognizedText);
  }

  @override
  void dispose() {
    _modelTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void _initializeSpeech() async {
    bool available = await _speech.initialize(
      onStatus: (status) => debugPrint('Speech status: $status'),
      onError: (error) => debugPrint('Speech error: $error'),
    );
    if (!available) {
      debugPrint('Speech-to-Text not available');
    }
  }

  void _initializeTts() async {
    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.5);
    _setVoice();
  }

  void _setVoice() async {
    List<dynamic> voices = await _flutterTts.getVoices;
    if (voices.isEmpty) return;

    String? selectedVoice =
        _isMaleVoice ? "fil-ph-x-fie-local" : "fil-ph-x-fic-local";

    await _flutterTts.setVoice({"name": selectedVoice, "locale": "fil-PH"});
  }

  void _speakText(String text) async {
    _setVoice();
    await _flutterTts.speak(text);
  }

  void _startListening() async {
    if (_isListening) return;
    bool available = await _speech.initialize();
    if (!available) return;

    setState(() => _isListening = true);
    _speech.listen(
      onResult: (result) => setState(() {
        _recognizedText = result.recognizedWords;
        _refreshModelsFromText(_recognizedText);
      }),
    );
    _animationController.repeat(reverse: true);
  }

  void _stopListening() async {
    if (!_isListening) return;
    setState(() => _isListening = false);
    _speech.stop();
    _animationController.stop();
    _animationController.reset();
  }

  void _refreshModelsFromText(String text) {
    final models = findMatchingModels(text);

    _modelTimer?.cancel();
    setState(() {
      _modelsToShow = models;
      _currentModelIndex = 0;
    });

    if (_modelsToShow.length > 1) {
      _modelTimer = Timer.periodic(_modelFrameDuration, (_) {
        if (!mounted || _modelsToShow.isEmpty) return;
        setState(() {
          _currentModelIndex = (_currentModelIndex + 1) % _modelsToShow.length;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF273236)
          : Colors.white,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF273236)
            : Colors.white,
        actions: [
          IconButton(
            icon: Icon(_isMaleVoice ? Icons.male : Icons.female),
            onPressed: () {
              setState(() {
                _isMaleVoice = !_isMaleVoice;
              });
              _setVoice();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 10 : 20, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: isSmallScreen ? 220 : 300, 
                height: isSmallScreen ? 170 : 200,
                child: _modelsToShow.isEmpty
                    ? Image.asset(
                        'assets/illustrations/mic.png',
                        fit: BoxFit.contain,
                      )
                    : Image.network(
                        letterModels[_modelsToShow[_currentModelIndex]] ?? '',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.error,
                              size: 60, color: Colors.red);
                        },
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                      ),
              ),

              const SizedBox(height: 25),
              const Text('Hold the button and speak to display the text.'),
              const SizedBox(height: 20),

              Container(
                width: screenWidth * 0.9,
                height: screenHeight * 0.2,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.blueAccent, width: 2),
                ),
                child: TextField(
                  controller: TextEditingController(text: _recognizedText)
                    ..selection = TextSelection.fromPosition(
                      TextPosition(offset: _recognizedText.length),
                    ),
                  style: TextStyle(fontSize: isSmallScreen ? 18 : 22),
                  textAlign: TextAlign.center,
                  maxLines: null,
                  onChanged: (value) {
                    setState(() {
                      _recognizedText = value;
                    });
                    _refreshModelsFromText(value);
                  },
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: isSmallScreen ? 40 : 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildIconButton(
                    icon: Icons.volume_up,
                    onTap: () => _speakText(_recognizedText),
                    size: isSmallScreen ? 28 : 32,
                  ),
                  const SizedBox(width: 20),
                  SizedBox(
                    width: 120, 
                    height: 120, 
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        AnimatedBuilder(
                          animation: _animation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: 0.4 +
                                  (_animation.value *
                                      0.8), 
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      Colors.blueAccent.withValues(alpha: 0.2),
                                ),
                              ),
                            );
                          },
                        ),
                        GestureDetector(
                          onTapDown: (_) => _startListening(),
                          onTapUp: (_) => _stopListening(),
                          child: Container(
                            padding: const EdgeInsets.all(12.0),
                            decoration: const BoxDecoration(
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
                  ),
                  const SizedBox(width: 20),
                  _buildIconButton(
                    icon: Icons.refresh,
                    onTap: () {
                      setState(() {
                        _recognizedText = '';
                      });
                      _refreshModelsFromText('');
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

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onTap,
    required double size,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.4),
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
