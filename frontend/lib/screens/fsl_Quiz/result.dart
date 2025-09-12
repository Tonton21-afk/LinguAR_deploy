import 'package:flutter/material.dart';
import 'package:lingua_arv1/model/Quiz_result.dart';
import 'package:lingua_arv1/screens/fsl_Quiz/answerFeedback.dart';

class QuizResultScreen extends StatelessWidget {
  final QuizResult result;
  const QuizResultScreen({Key? key, required this.result}) : super(key: key);

  // 🔐 Robust finisher: pop current; if not, pop root
  void _finishWithSuccess(BuildContext context) {
    final nav = Navigator.of(context);
    if (nav.canPop()) {
      print('DEBUG[Result]: pop(true) via local navigator');
      nav.pop(true);
    } else {
      print('DEBUG[Result]: local cannot pop; pop(true) via root navigator');
      Navigator.of(context, rootNavigator: true).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final int totalQuestions = result.correctAnswers + result.wrongAnswers;
    final double scorePercentage =
        totalQuestions > 0 ? (result.correctAnswers / totalQuestions) * 100 : 0;

    String feedbackMessage;
    Color feedbackColor;
    if (scorePercentage >= 80) {
      feedbackMessage = "🎉 Excellent Job!";
      feedbackColor = Colors.green;
    } else if (scorePercentage >= 50) {
      feedbackMessage = "Good Try!";
      feedbackColor = Colors.orange;
    } else {
      feedbackMessage = "Keep Practicing!";
      feedbackColor = Colors.red;
    }

    return WillPopScope(
      onWillPop: () async {
        // System/gesture back should also unlock & go back to FSLTranslate.
        print('DEBUG[Result]: system/back -> finishing with success');
        _finishWithSuccess(context);
        return false; // we handled the pop
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF273236)
            : Colors.grey[100],
        appBar: AppBar(
          // Keep invisible app bar; WillPopScope covers system back.
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF273236)
              : Colors.white,
          elevation: 1,
          toolbarHeight: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.emoji_events, size: 36, color: Colors.amber),
                  const SizedBox(width: 10),
                  Text(
                    "Your Results",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.amber
                          : Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildFeedbackCard(feedbackMessage, feedbackColor),
              const SizedBox(height: 20),
              _buildScoreCard(scorePercentage, context),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildAnswerStat("Correct", result.correctAnswers,
                      Icons.check_circle, Colors.green),
                  _buildAnswerStat(
                      "Wrong", result.wrongAnswers, Icons.cancel, Colors.red),
                ],
              ),
              const SizedBox(height: 40),
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeedbackCard(String message, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        message,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildScoreCard(double percentage, BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color.fromARGB(255, 57, 65, 65) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            "Your Score",
            style: TextStyle(
              fontSize: 18,
              color: isDarkMode ? Colors.white : Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const SizedBox(height: 4),
          Text(
            "${percentage.toStringAsFixed(1)}%",
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.purple,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerStat(String label, int count, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, size: 36, color: color),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 18,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 22,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            // Restart stays within the lesson flow; no unlock signal needed here.
            print('DEBUG[Result]: pushReplacement -> AnswerFeedback(category=${result.category})');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => AnswerFeedback(category: result.category),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text("Restart Quiz",
              style: TextStyle(fontSize: 18, color: Colors.white)),
        ),
        const SizedBox(height: 20),
        OutlinedButton(
          onPressed: () {
            print('DEBUG[Result]: submit -> finish & return true');
            _finishWithSuccess(context); // ✅ go back to FSLTranslatePage via chain
          },
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            side: const BorderSide(color: Colors.purple, width: 2),
          ),
          child: const Text("Submit",
              style: TextStyle(fontSize: 18, color: Colors.purple)),
        ),
      ],
    );
  }
}
