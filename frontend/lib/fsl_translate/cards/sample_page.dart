import 'package:flutter/material.dart';

class SamplePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text to Speech'),
        centerTitle: true,
      ),
      backgroundColor: Color(0xFFFEFFFE), // Sets the background color
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              'Welcome to the Sample Page!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF191E20),
              ),
            ),
            SizedBox(height: 16),

            // Description
            Text(
              'This page serves as an example of how you can display content after navigating from the main page.',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF4A90E2),
              ),
            ),
            SizedBox(height: 24),

            // A button to go back to the main page
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                    context); // Navigates back to the previous page (FSLTranslatePage)
              },
              child: Text('Go Back'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                backgroundColor: Color(0xff191E20),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
