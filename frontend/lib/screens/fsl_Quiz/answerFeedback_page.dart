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

class AnswerFeedbackPage extends StatefulWidget {
  const AnswerFeedbackPage({super.key});

  @override
  State<AnswerFeedbackPage> createState() => _AnswerFeedbackPageState();
}

class _AnswerFeedbackPageState extends State<AnswerFeedbackPage> {
  // 🔒 Prevent double navigation to results
  bool _navigatingToResult = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MultiBlocListener(
      listeners: [
        // ✅ Result navigation — fire only on the FIRST transition to QuizCompleted
        BlocListener<QuizBloc, QuizState>(
          listenWhen: (prev, curr) => prev is! QuizCompleted && curr is QuizCompleted,
          listener: (context, state) async {
            if (_navigatingToResult) return;
            _navigatingToResult = true;

            final s = state as QuizCompleted;
            print('DEBUG[Feedback]: push -> QuizResultScreen '
                '(correct=${s.result.correctAnswers}, wrong=${s.result.wrongAnswers})');

            // Same navigator is fine in your app (root/local are identical per your logs)
            final bool? completed = await Navigator.of(context).push<bool>(
              MaterialPageRoute(builder: (_) => QuizResultScreen(result: s.result)),
            );

            print('DEBUG[Feedback]: pop <- QuizResultScreen completed=$completed');

            if (!mounted) return;
            _navigatingToResult = false;

            if (completed == true) {
              print('DEBUG[Feedback]: forwarding true to LessonFlowPage');
              Navigator.pop(context, true); // bubble up to LessonFlowPage
            }
          },
        ),

        // ✅ One-time feedback pop when user answers
        BlocListener<QuizBloc, QuizState>(
          listenWhen: (prev, curr) =>
              prev is QuestionLoaded &&
              curr is QuestionLoaded &&
              prev.isCorrect == null &&
              curr.isCorrect != null,
          listener: (context, state) {
            final s = state as QuestionLoaded;
            _showFeedbackDialog(context, s.isCorrect!);
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xFF273236) : const Color(0xFFFCEEFF),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: isDark ? const Color(0xFF1D1D1D) : Colors.white,
          elevation: 0,
        ),
        body: Column(
          children: [
            // ------- Top content with animated phase swap -------
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 1),
                child: BlocBuilder<QuizBloc, QuizState>(
                  builder: (context, state) {
                    if (state is QuizLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    Widget buildTeach(TeachLoaded s) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _phaseGif(stateType: 'teach', url: s.gifUrl),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: isDark ? Colors.white : Colors.black),
                            ),
                            child: Text(
                              s.question['phrase']!,
                              style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ],
                      );
                    }

                    Widget buildQuiz(QuestionLoaded s) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _phaseGif(stateType: 'quiz', url: s.gifUrl),
                          const SizedBox(height: 5),
                          Column(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: CorrectButton(
                                  text: s.question["answer1"]!,
                                  isCorrect: s.isCorrect != null
                                      ? s.question["answer1"] == s.question["correct"]
                                      : null,
                                  isDisabled: s.isCorrect != null,
                                  onPressed: () => context
                                      .read<QuizBloc>()
                                      .add(CheckAnswer(s.question["answer1"]!)),
                                ),
                              ),
                              const SizedBox(height: 5),
                              SizedBox(
                                width: double.infinity,
                                child: CorrectButton(
                                  text: s.question["answer2"]!,
                                  isCorrect: s.isCorrect != null
                                      ? s.question["answer2"] == s.question["correct"]
                                      : null,
                                  isDisabled: s.isCorrect != null,
                                  onPressed: () => context
                                      .read<QuizBloc>()
                                      .add(CheckAnswer(s.question["answer2"]!)),
                                ),
                              ),
                              const SizedBox(height: 5),
                            ],
                          ),
                        ],
                      );
                    }

                    if (state is TeachLoaded || state is QuestionLoaded) {
                      final showFirst = state is TeachLoaded;
                      return AnimatedCrossFade(
                        duration: const Duration(milliseconds: 220),
                        crossFadeState: showFirst
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                        firstChild:
                            state is TeachLoaded ? buildTeach(state) : const SizedBox.shrink(),
                        secondChild:
                            state is QuestionLoaded ? buildQuiz(state) : const SizedBox.shrink(),
                      );
                    }

                    return const Center(child: Text("Loading..."));
                  },
                ),
              ),
            ),

            // ------- Bottom actions -------
            Padding(
              padding: const EdgeInsets.only(bottom: 55),
              child: BlocBuilder<QuizBloc, QuizState>(
                builder: (context, state) {
                  if (state is TeachLoaded) {
                    return NextButton(
                      isEnabled: true,
                      onPressed: () {
                        _microOverlay(context);
                        context.read<QuizBloc>().add(ProceedToQuiz());
                      },
                    );
                  }

                  final isEnabled = state is QuestionLoaded && state.isCorrect != null;
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

  /// GIF that restarts on phase change using a phase-aware key
  Widget _phaseGif({required String stateType, required String url}) {
    final key = ValueKey('$stateType-$url'); // key changes Teach<->Quiz
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      transitionBuilder: (child, anim) => FadeTransition(opacity: anim, child: child),
      child: Container(key: key, child: GifDisplay(gifUrl: url)),
    );
  }

  /// Very short overlay to make Teach->Quiz feel deliberate
  void _microOverlay(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.05),
      transitionDuration: const Duration(milliseconds: 160),
      pageBuilder: (_, __, ___) => const SizedBox.shrink(),
    );
    Future.delayed(const Duration(milliseconds: 160), () {
      if (Navigator.of(context, rootNavigator: true).canPop()) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    });
  }

  void _showFeedbackDialog(BuildContext context, bool isCorrect) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        Future.delayed(const Duration(seconds: 1), () {
          final root = Navigator.of(dialogContext, rootNavigator: true);
          if (root.canPop()) root.pop();
        });
        return Dialog(
          backgroundColor: Colors.transparent,
          child: SizedBox.expand(
            child: Center(child: FeedbackIndicator(isCorrect: isCorrect)),
          ),
        );
      },
    );
  }
}
