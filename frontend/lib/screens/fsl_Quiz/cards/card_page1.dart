import 'package:flutter/material.dart';

class CardPage1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Card Page 1'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daily Communication',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Essential phrases for everyday conversations.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 32),
            Text(
              'Content for this page goes here...',
              style: TextStyle(fontSize: 14),
            ),
            // Add more content as needed
          ],
        ),
      ),
    );
  }
}
