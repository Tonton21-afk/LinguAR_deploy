import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingua_arv1/api/quiz_mappings.dart';
import 'package:lingua_arv1/bloc/Quiz/quiz_bloc.dart';
import 'package:lingua_arv1/bloc/Quiz/quiz_event.dart';
import 'package:lingua_arv1/screens/fsl_Quiz/answerFeedback_page.dart';
import 'package:lingua_arv1/screens/fsl_Quiz/LearningCardPage.dart';
import 'package:lingua_arv1/screens/fsl_Quiz/lessontitle.dart';

class LessonFlowPage extends StatelessWidget {
  final String category;
  const LessonFlowPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final quizData = generateQuizData(category);

    if (quizData.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Lesson')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('No quiz data available for this category.'),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Go back'),
              ),
            ],
          ),
        ),
      );
    }

    final first = quizData.first;
    final title = titleForCategory(category);

    Future<void> onNext() async {
      final bloc = QuizBloc(quizData: quizData, category: category);
      bloc.add(ProceedToQuiz());

      final bool? completed = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: bloc,
            child: const AnswerFeedbackPage(),
          ),
        ),
      );
      await bloc.close();

    }

    return Learningcardpage(
      title: title,
      phrase: first['phrase']!,
      gifPath: first['gifPath']!,
      onNext: onNext,
    );
  }
}
