import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingua_arv1/api/basic_phrases.dart';
import 'package:lingua_arv1/api/quiz_mappings.dart';
import 'package:lingua_arv1/bloc/Quiz/quiz_bloc.dart';
import 'package:lingua_arv1/bloc/Quiz/quiz_event.dart';
import 'package:lingua_arv1/screens/fsl_quiz/answerFeedback_page.dart';

class AnswerFeedback extends StatelessWidget {
  final String category;

  const AnswerFeedback({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Generate quiz data for the given category
    final List<Map<String, String>> quizData = generateQuizData(category);

    return BlocProvider(
      create: (context) => QuizBloc(quizData: quizData, category: category)
        ..add(
          FetchGif(
            phrase: quizData[0]["phrase"]!,
            publicId: quizData[0]["gifPath"]!, // Use the correct GIF path
          ),
        ),
      child: AnswerFeedbackPage(), // Navigates to the actual page
    );
  }
}
