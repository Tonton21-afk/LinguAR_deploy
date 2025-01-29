import 'package:flutter/material.dart';
import 'feature/gesture_translator.dart';
import 'feature/text_to_speech.dart';

void main() {
  runApp(MaterialApp(
    home: HomePage(),
    debugShowCheckedModeBanner: false,
  ));
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEFFFE),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Shortcuts section title
              const Text(
                'Shortcuts',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // Shortcuts section with adjusted spacing
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 140,
                    height: 120,
                    child: ShortcutButton(
                      icon: Icons.fingerprint,
                      label: 'Gesture Translator',
                      backgroundColor: Color(0xFF4A90E2),
                      onTap: () {
                        // Navigate to Gesture Translator screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GestureTranslator(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 15),
                  SizedBox(
                    width: 140,
                    height: 120,
                    child: ShortcutButton(
                      icon: Icons.volume_up,
                      label: 'Text to Speech',
                      backgroundColor: Color(0xFF273236),
                      onTap: () {
                        // Navigate to Text to Speech screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TextToSpeech(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              const Text(
                'Currently Playing',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: double.infinity,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: Offset(2, 4),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'Daily Communication, Basic Phrases',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // History section
              const Text(
                'History',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ShortcutButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color backgroundColor;
  final VoidCallback onTap; // added onTap callback

  const ShortcutButton({
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.onTap, // initialized onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // use the onTap here
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
