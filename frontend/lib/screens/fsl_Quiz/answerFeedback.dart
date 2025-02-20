import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingua_arv1/Widget/next_button.dart';
import 'package:lingua_arv1/api/basic_phrases.dart';
import 'package:lingua_arv1/api/quiz_mappings.dart';
import 'package:lingua_arv1/bloc/Quiz/quiz_bloc.dart';
import 'package:lingua_arv1/bloc/Quiz/quiz_event.dart';
import 'package:lingua_arv1/bloc/Quiz/quiz_state.dart';
import 'package:lingua_arv1/Widget/correct_button.dart';
import 'package:lingua_arv1/Widget/display_gif.dart';
import 'package:lingua_arv1/Widget/feedback_indicator.dart';

class AnswerFeedback extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QuizBloc(quizData: generateQuizData())
        ..add(FetchGif(
          phrase: generateQuizData()[0]["phrase"]!,
          publicId:
              basicPhrasesMappings[generateQuizData()[0]["phrase"]!] ?? "",
        )),
      child: AnswerFeedbackPage(),
    );
  }
}

class AnswerFeedbackPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCEEFF),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
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
                      const SizedBox(height: 20),

                      // **Answer Buttons (Now Randomized Position)**
                      CorrectButton(
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
                      const SizedBox(height: 15),
                      CorrectButton(
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

                      const SizedBox(height: 15),

                      // **Correct / Incorrect Indicator**
                      if (state.isCorrect != null) ...[
                        const SizedBox(height: 15),
                        FeedbackIndicator(isCorrect: state.isCorrect!),
                      ],
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
            padding: const EdgeInsets.only(bottom: 15),
            child: BlocBuilder<QuizBloc, QuizState>(
              builder: (context, state) {
                bool isEnabled = false;

                if (state is QuestionLoaded && state.isCorrect != null) {
                  isEnabled = true;
                }

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
    );
  }
}
