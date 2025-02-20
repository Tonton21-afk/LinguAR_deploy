import 'package:flutter/material.dart';

class FeedbackIndicator extends StatelessWidget {
  final bool isCorrect;

  const FeedbackIndicator({Key? key, required this.isCorrect}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          isCorrect ? Icons.check_circle : Icons.cancel,
          color: isCorrect ? Colors.green : Colors.red,
          size: 40,
        ),
        const SizedBox(height: 10),
        Text(
          isCorrect ? "Correct!" : "Incorrect",
          style: TextStyle(
            fontSize: 18,
            color: isCorrect ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
