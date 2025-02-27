import 'package:flutter/material.dart';
import 'package:lingua_arv1/screens/fsl_Quiz/answerFeedback.dart';
import 'package:lingua_arv1/screens/fsl_quiz/answerFeedback_page.dart';

class CardPage5 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Family & Relationships'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Learning, Work, and Technology',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Communicate in academic, professional, and digital settings.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Navigate to the AnswerFeedback screen with the correct category
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AnswerFeedback(category: "Emergency"),
                  ),
                );
              },
              child: Text('Start Quiz'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                backgroundColor: Colors.purple[300],
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}