import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingua_arv1/bloc/Quiz/quiz_bloc.dart';
import 'package:lingua_arv1/bloc/Quiz/quiz_event.dart';
import 'package:lingua_arv1/bloc/Quiz/quiz_state.dart';
import 'package:lingua_arv1/widgets/correct_button.dart';
import 'package:lingua_arv1/widgets/display_gif.dart';

class QuizQuestionView extends StatelessWidget {
  final QuestionLoaded state;
  final bool animate; // so you can keep/remove animation easily

  const QuizQuestionView({
    super.key,
    required this.state,
    this.animate = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        GifDisplay(gifUrl: state.gifUrl),
        const SizedBox(height: 5),

 
        animate
            ? AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                transitionBuilder: (child, anim) =>
                    FadeTransition(opacity: anim, child: SizeTransition(sizeFactor: anim, child: child)),
                child: _answers(context),
              )
            : _answers(context),
      ],
    );
  }

  Widget _answers(BuildContext context) {
    return Column(
      key: ValueKey('answers-${state.isCorrect != null}'),
      children: [
        SizedBox(
          width: double.infinity,
          child: CorrectButton(
            text: state.question["answer1"]!,
            isCorrect: state.isCorrect != null
                ? state.question["answer1"] == state.question["correct"]
                : null,
            isDisabled: state.isCorrect != null,
            onPressed: () => context
                .read<QuizBloc>()
                .add(CheckAnswer(state.question["answer1"]!)),
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          width: double.infinity,
          child: CorrectButton(
            text: state.question["answer2"]!,
            isCorrect: state.isCorrect != null
                ? state.question["answer2"] == state.question["correct"]
                : null,
            isDisabled: state.isCorrect != null,
            onPressed: () => context
                .read<QuizBloc>()
                .add(CheckAnswer(state.question["answer2"]!)),
          ),
        ),
        const SizedBox(height: 5),
      ],
    );
  }
}
