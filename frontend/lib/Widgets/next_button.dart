import 'package:flutter/material.dart';

class NextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isEnabled;

  const NextButton({Key? key, required this.onPressed, required this.isEnabled})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled ? const Color(0xFF273236) : Colors.grey,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 80),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: const Text(
          "NEXT",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}
