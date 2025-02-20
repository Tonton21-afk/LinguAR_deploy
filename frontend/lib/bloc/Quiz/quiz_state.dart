import 'package:equatable/equatable.dart';

// Base class for quiz states
abstract class QuizState extends Equatable {
  const QuizState();

  @override
  List<Object?> get props => [];
}

// Initial state before the quiz starts
class QuizInitial extends QuizState {}

// State when loading (e.g., GIF fetch)
class QuizLoading extends QuizState {}

// State when a new question is displayed
class QuestionLoaded extends QuizState {
  final String gifUrl;
  final Map<String, String> question;
  final bool? isCorrect; // Nullable to track answer correctness

  const QuestionLoaded({required this.gifUrl, required this.question, this.isCorrect});

  @override
  List<Object?> get props => [gifUrl, question, isCorrect];
}

// State for handling errors
class QuizError extends QuizState {
  final String message;

  const QuizError({required this.message});

  @override
  List<Object?> get props => [message];
}
