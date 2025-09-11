import 'package:equatable/equatable.dart';
import 'package:lingua_arv1/model/Quiz_result.dart';


abstract class QuizState extends Equatable {
  const QuizState();

  @override
  List<Object?> get props => [];
}


class QuizInitial extends QuizState {}


class QuizLoading extends QuizState {}


class QuestionLoaded extends QuizState {
  final String gifUrl;
  final Map<String, String> question;
  final bool? isCorrect; 

  const QuestionLoaded({required this.gifUrl, required this.question, this.isCorrect});

  @override
  List<Object?> get props => [gifUrl, question, isCorrect];
}


class QuizError extends QuizState {
  final String message;

  const QuizError({required this.message});

  @override
  List<Object?> get props => [message];
}

class QuizCompleted extends QuizState {
  final QuizResult result;

  const QuizCompleted({required this.result});

  @override
  List<Object> get props => [result];
}

//keep this _--------------------------------------------------
class TeachLoaded extends QuizState {
  final String gifUrl;
  final Map<String, String> question; // same item the quiz will ask
  const TeachLoaded({required this.gifUrl, required this.question});
  @override
  List<Object?> get props => [gifUrl, question];
}