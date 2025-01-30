import 'package:flutter/material.dart';
import 'get_started_page5.dart';

class GetStartedPage4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFEFEFF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(text: 'Say '),
                  TextSpan(
                    text: '“Mabuhay”',
                    style: TextStyle(color: Colors.blue),
                  ),
                  TextSpan(text: '\nto recognize your\nvoice'),
                ],
              ),
            ),
            SizedBox(height: 20),
            Icon(
              Icons.graphic_eq, // Frequency icon
              size: 100,
              color: Color(0xFF4A90E2),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => GetStartedPage5()),
                );
              },
              child: Text(
                "DEBUG: Skip Voice Detection",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
