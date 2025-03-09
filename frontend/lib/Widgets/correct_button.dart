import 'package:flutter/material.dart';

class CorrectButton extends StatelessWidget {
  final String text;
  final bool? isCorrect;
  final bool isDisabled;
  final VoidCallback onPressed;

  const CorrectButton({
    Key? key,
    required this.text,
    required this.isCorrect,
    required this.isDisabled,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // ✅ Default colors (based on theme)
    Color textColor = isDarkMode ? Colors.white : Colors.black;
    Color borderColor = isDarkMode ? Colors.white : Colors.black;

    // Only change color if the button is disabled (i.e., after selection)
    if (isDisabled) {
      borderColor = isCorrect! ? Colors.green : Colors.red;
      textColor = isCorrect! ? Colors.green : Colors.red;
    }

    return OutlinedButton(
      onPressed: isDisabled ? null : onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
        side: BorderSide(color: borderColor, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          color: isDisabled
              ? textColor
              : Theme.of(context).brightness == Brightness.dark
                  ? Colors.white // Dark mode color
                  : Colors.black, // Grey when disabled
        ),
      ),
    );
  }
}
