import 'package:flutter/material.dart';

class FeedbackIndicator extends StatelessWidget {
  final bool isCorrect;

  const FeedbackIndicator({Key? key, required this.isCorrect}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center( // Ensures everything is centered
      child: Column(
        mainAxisSize: MainAxisSize.min, // Prevents taking up extra space
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isCorrect ? Icons.check_circle : Icons.cancel,
            color: isCorrect ? Colors.green : Colors.red,
            size: 120, // Increased size
          ),
          const SizedBox(height: 20), // Added spacing
          Text(
            isCorrect ? "Correct!" : "Incorrect",
            style: TextStyle(
              fontSize: 40, // Increased font size
              color: isCorrect ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
