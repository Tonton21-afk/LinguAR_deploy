import 'package:flutter/material.dart';

class GuideOverlay extends StatelessWidget {
  final VoidCallback onClose;
  const GuideOverlay({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: const Color.fromRGBO(0, 0, 0, 0.7),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Welcome to FSL Quiz!",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              " Welcome to the FSL Quiz!\n\n"
              "• First, you’ll see the sign.\n"
              "• Then, you’ll answer the question.\n\n"
              " Tips:\n"
              "- Try to mimic each sign as you go.\n"
              "- You can review by going back anytime.\n\n"
              "This quiz has 15 questions to help you learn basic Filipino Sign Language (FSL) phrases.\n\n"
              "Good luck and have fun!",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 16, height: 1.4),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: onClose,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text("Got it!",
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
