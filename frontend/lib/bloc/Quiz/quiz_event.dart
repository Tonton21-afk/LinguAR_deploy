import 'package:equatable/equatable.dart';

abstract class QuizEvent extends Equatable {
  const QuizEvent();

  @override
  List<Object> get props => [];
}

class StartLesson extends QuizEvent {}
class ProceedToQuiz extends QuizEvent {}

// Moves to the next question
class NextQuestion extends QuizEvent {}

// Checks if the selected answer is correct
class CheckAnswer extends QuizEvent {
  final String selectedAnswer;

  const CheckAnswer(this.selectedAnswer);

  @override
  List<Object> get props => [selectedAnswer];
}

// Fetches a GIF based on the current phrase
class FetchGif extends QuizEvent {
  final String phrase;
  final String publicId;

  const FetchGif({required this.phrase, required this.publicId});

  @override
  List<Object> get props => [phrase, publicId];
}
