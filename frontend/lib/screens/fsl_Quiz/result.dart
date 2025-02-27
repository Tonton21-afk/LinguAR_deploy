import 'package:flutter/material.dart';
import 'package:lingua_arv1/model/Quiz_result.dart';
import 'package:lingua_arv1/screens/fsl_Quiz/answerFeedback.dart';

class QuizResultScreen extends StatelessWidget {
  final QuizResult result;

  const QuizResultScreen({
    Key? key,
    required this.result,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate Score Percentage
    int totalQuestions = result.correctAnswers + result.wrongAnswers;
    double scorePercentage = (totalQuestions > 0)
        ? (result.correctAnswers / totalQuestions) * 100
        : 0;

    String feedbackMessage;
    if (scorePercentage >= 80) {
      feedbackMessage = "🎉 Excellent Job!";
    } else if (scorePercentage >= 50) {
      feedbackMessage = "Good Try!";
    } else {
      feedbackMessage = "Keep Practicing!";
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: const Text("Quiz Results"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Your Results",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),
            Text(
              feedbackMessage,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text(
              "Score: ${scorePercentage.toStringAsFixed(1)}%",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 30),

            // **Correct & Wrong Answers**
            Text(
              "Correct Answers: ${result.correctAnswers}",
              style: const TextStyle(fontSize: 20, color: Colors.green),
            ),
            Text(
              "Wrong Answers: ${result.wrongAnswers}",
              style: const TextStyle(fontSize: 20, color: Colors.red),
            ),

            const SizedBox(height: 40),

            // **Restart Quiz Button**
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AnswerFeedback(category: result.category), // Restart with the same category
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple[300],
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Restart Quiz",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}