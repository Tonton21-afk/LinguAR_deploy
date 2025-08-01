import 'package:flutter/material.dart';

class CardTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final Widget nextPage;
  final Color iconColor;

  const CardTile({
    super.key,
    required this.icon,
    required this.text,
    required this.nextPage,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => nextPage),
        );
      },
      child: Card(
        color: iconColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.06),
        ),
        elevation: 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: screenWidth * 0.06,
              backgroundColor: Colors.white,
              child: Icon(icon, size: screenWidth * 0.06, color: iconColor),
            ),
            SizedBox(height: screenWidth * 0.02),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: screenWidth * 0.03,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
