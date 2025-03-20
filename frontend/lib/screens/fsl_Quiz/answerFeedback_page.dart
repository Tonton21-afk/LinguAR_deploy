import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingua_arv1/bloc/Quiz/quiz_bloc.dart';
import 'package:lingua_arv1/bloc/Quiz/quiz_event.dart';
import 'package:lingua_arv1/bloc/Quiz/quiz_state.dart';
import 'package:lingua_arv1/widgets/correct_button.dart';
import 'package:lingua_arv1/widgets/display_gif.dart';
import 'package:lingua_arv1/widgets/feedback_indicator.dart';
import 'package:lingua_arv1/widgets/next_button.dart';
import 'package:lingua_arv1/screens/fsl_quiz/result.dart';

class AnswerFeedbackPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<QuizBloc, QuizState>(
      listener: (context, state) {
        if (state is QuizCompleted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => QuizResultScreen(result: state.result),
            ),
          );
        }

        if (state is QuestionLoaded && state.isCorrect != null) {
          // Show feedback pop-up when an answer is selected
          _showFeedbackDialog(context, state.isCorrect!);
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Color(0xFF273236) // Dark mode color
            : const Color(0xFFFCEEFF),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? const Color.fromARGB(255, 29, 29, 29) // Dark mode color
              : Colors.white,
          elevation: 0,
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            // **GIF Section**
            Padding(
              padding: const EdgeInsets.only(top: 1),
              child: BlocBuilder<QuizBloc, QuizState>(
                builder: (context, state) {
                  if (state is QuizLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is QuestionLoaded) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GifDisplay(gifUrl: state.gifUrl),
                        const SizedBox(height: 5),
                        SizedBox(
                          width: double.infinity,
                          child: CorrectButton(
                            text: state.question["answer1"]!,
                            isCorrect: state.isCorrect != null
                                ? state.question["answer1"] ==
                                    state.question["correct"]
                                : null,
                            isDisabled: state.isCorrect != null,
                            onPressed: () {
                              context
                                  .read<QuizBloc>()
                                  .add(CheckAnswer(state.question["answer1"]!));
                            },
                          ),
                        ),
                        const SizedBox(height: 5),
                        SizedBox(
                          width: double.infinity,
                          child: CorrectButton(
                            text: state.question["answer2"]!,
                            isCorrect: state.isCorrect != null
                                ? state.question["answer2"] ==
                                    state.question["correct"]
                                : null,
                            isDisabled: state.isCorrect != null,
                            onPressed: () {
                              context
                                  .read<QuizBloc>()
                                  .add(CheckAnswer(state.question["answer2"]!));
                            },
                          ),
                        ),
                        const SizedBox(height: 5),
                      ],
                    );
                  }
                  return const Center(child: Text("Loading..."));
                },
              ),
            ),
            const Spacer(),
            // **NEXT Button (Fixed at Bottom)**
            Padding(
              padding: const EdgeInsets.only(bottom: 55),
              child: BlocBuilder<QuizBloc, QuizState>(
                builder: (context, state) {
                  bool isEnabled =
                      state is QuestionLoaded && state.isCorrect != null;

                  return NextButton(
                    isEnabled: isEnabled,
                    onPressed: () {
                      if (isEnabled) {
                        context.read<QuizBloc>().add(NextQuestion());
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Function to show a pop-up feedback dialog that closes automatically after 3 seconds
  void _showFeedbackDialog(BuildContext context, bool isCorrect) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent manual dismissal
      builder: (BuildContext dialogContext) {
        Future.delayed(const Duration(seconds: 1), () {
          if (Navigator.canPop(dialogContext)) {
            Navigator.pop(dialogContext); // Auto-close after 3 seconds
          }
        });

        return Dialog(
          backgroundColor: Colors.transparent, // Transparent for better effect
          child: Container(
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.center,
            child: FeedbackIndicator(isCorrect: isCorrect), // Centered content
          ),
        );
      },
    );
  }
}
