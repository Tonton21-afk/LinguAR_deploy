import 'package:flutter/material.dart';

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
                  GestureDetector(
                    onTap: () {
                      // Navigate to Filipino Sign Language page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FilipinoSignLanguagePage(),
                        ),
                      );
                    },
                    child: SizedBox(
                      width: 140,
                      height: 120,
                      child: ShortcutButton(
                        icon: Icons.fingerprint,
                        label: 'Gesture Translator',
                        backgroundColor: Color(0xFF4A90E2),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  GestureDetector(
                    onTap: () {
                      // Navigate to Text to Speech page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TextToSpeechPage(),
                        ),
                      );
                    },
                    child: SizedBox(
                      width: 140,
                      height: 120,
                      child: ShortcutButton(
                        icon: Icons.volume_up,
                        label: 'Text to Speech',
                        backgroundColor: Color(0xFF273236),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Currently Playing',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {
                      // Placeholder for function
                    },
                    child: SizedBox(
                      width: double.infinity,
                      child: Container(
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey,
                            width: 1.5,
                          ),
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
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Favorites section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Favorites',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Placeholder for function
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFF4A90E2),
                    ),
                    child: const Text('Add +'),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Cards section
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.7,
                  ),
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      // Placeholder for function
                    },
                    child: FavoriteCard(
                      title: index == 0 ? 'Sample Text' : 'Sample Text',
                    ),
                  ),
                  itemCount: 2,
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

  const ShortcutButton({
    required this.icon,
    required this.label,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
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

class FavoriteCard extends StatelessWidget {
  final String title;

  const FavoriteCard({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Center(
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// Filipino Sign Language Feature Page
class FilipinoSignLanguagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Filipino Sign Language')),
      body: const Center(
        child: Text('Welcome to the Filipino Sign Language feature!'),
      ),
    );
  }
}

// Text to Speech Feature Page
class TextToSpeechPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Text to Speech')),
      body: const Center(
        child: Text('Welcome to the Text to Speech feature!'),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: HomePage(),
    debugShowCheckedModeBanner: false, // To remove the debug banner
  ));
}
