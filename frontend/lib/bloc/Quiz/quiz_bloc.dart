import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:lingua_arv1/repositories/Config.dart';
import 'package:lingua_arv1/model/Quiz_result.dart';
import 'quiz_event.dart';
import 'quiz_state.dart';

enum QuizPhase { teach, quiz }

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  final List<Map<String, String>> quizData;
  final String category;

  final Map<String, String> _gifCache = {};
  int currentIndex = 0;
  int correctCount = 0;
  int wrongCount = 0;
  bool isAnswered = false;

  
  QuizPhase _phase = QuizPhase.teach;

  QuizBloc({required this.quizData, required this.category})
      : super(QuizInitial()) {
    if (quizData.isEmpty) {
      emit(
          QuizError(message: "No quiz data available for category: $category"));
    } else {
      on<StartLesson>(_handleStartLesson);
      on<ProceedToQuiz>(_handleProceedToQuiz);
      on<NextQuestion>(_handleNextQuestion);
      on<CheckAnswer>(_handleCheckAnswer);
      on<FetchGif>(_handleFetchGif);

      add(StartLesson()); 
    }
  }

 

  Future<void> _handleStartLesson(
      StartLesson event, Emitter<QuizState> emit) async {
    _phase = QuizPhase.teach; // ⬅️ set phase
    isAnswered = false;

    final item = quizData[currentIndex];
    final id = item['gifPath'] ?? '';
    if (id.isEmpty) {
      emit(const QuizError(message: 'Missing GIF id'));
      return;
    }

    
    final cached = _gifCache[id];
    if (cached != null) {
      emit(TeachLoaded(gifUrl: cached, question: item));
      return;
    }

    emit(QuizLoading());
    add(FetchGif(phrase: item['phrase']!, publicId: id));
  }

  Future<void> _handleProceedToQuiz(
      ProceedToQuiz event, Emitter<QuizState> emit) async {
    _phase = QuizPhase.quiz; 

    final item = quizData[currentIndex];
    final id = item['gifPath'] ?? '';
    if (id.isEmpty) {
      emit(const QuizError(message: 'Missing GIF id'));
      return;
    }

    
    final cached = _gifCache[id];
    if (cached != null) {
      emit(QuestionLoaded(gifUrl: cached, question: item, isCorrect: null));
      return;
    }

    emit(QuizLoading());
    add(FetchGif(phrase: item['phrase']!, publicId: id));
  }

  void _handleNextQuestion(NextQuestion event, Emitter<QuizState> emit) {
    if (currentIndex < quizData.length - 1) {
      currentIndex++;
      isAnswered = false;
      add(StartLesson()); // back to Teach for the next item
    } else {
      emit(QuizCompleted(
        result: QuizResult(
          correctAnswers: correctCount,
          wrongAnswers: wrongCount,
          category: category,
        ),
      ));
    }
  }

  void _handleCheckAnswer(CheckAnswer event, Emitter<QuizState> emit) {
    if (isAnswered) return;
    isAnswered = true;

    final item = quizData[currentIndex];
    final bool isCorrect = event.selectedAnswer == item['correct'];

    if (isCorrect) {
      correctCount++;
    } else {
      wrongCount++;
    }

    if (state is QuestionLoaded) {
      emit(QuestionLoaded(
        gifUrl: (state as QuestionLoaded).gifUrl,
        question: item,
        isCorrect: isCorrect,
      ));
    }
  }

  

  Future<void> _handleFetchGif(FetchGif event, Emitter<QuizState> emit) async {
    final id = event.publicId;
    if (id.isEmpty) {
      emit(const QuizError(message: 'Missing GIF id'));
      return;
    }

    Future<void> _emitWith(String url) async {
      final item = quizData[currentIndex];
      
      if (_phase == QuizPhase.teach) {
        emit(TeachLoaded(gifUrl: url, question: item));
      } else {
        emit(QuestionLoaded(gifUrl: url, question: item, isCorrect: null));
      }
    }

   
    final cached = _gifCache[id];
    if (cached != null) {
      await _emitWith(cached);
      return;
    }

    // Fetch
    emit(QuizLoading());
    final url = "${Cloud_url.baseURL}?public_id=$id";
    try {
      final response = await http.get(Uri.parse(url)).timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw TimeoutException('Request timed out'),
          );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final String gifUrl = jsonResponse['gif_url'];

        _gifCache[id] = gifUrl;
        final nextIdx = currentIndex + 1;
        if (nextIdx < quizData.length) {
          final nextId = quizData[nextIdx]['gifPath']!;
          if (!_gifCache.containsKey(nextId)) {
          
            http
                .get(Uri.parse("${Cloud_url.baseURL}?public_id=$nextId"))
                .timeout(const Duration(seconds: 10))
                .then((r) {
              if (r.statusCode == 200) {
                final u = (jsonDecode(r.body)['gif_url'] as String?) ?? '';
                if (u.isNotEmpty) _gifCache[nextId] = u;
              }
            }).catchError((_) {});
          }
        }
        await _emitWith(gifUrl);

       
      } else {
        emit(const QuizError(message: 'Failed to fetch GIF from server.'));
      }
    } catch (error) {
      emit(QuizError(message: 'Error occurred: $error'));
    }
  }

  Future<void> _prefetch(String publicId) async {
    final url = "${Cloud_url.baseURL}?public_id=$publicId";
    try {
      final resp =
          await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
      if (resp.statusCode == 200) {
        final json = jsonDecode(resp.body);
        final gifUrl = json['gif_url'];
        if (gifUrl is String && gifUrl.isNotEmpty) {
          _gifCache[publicId] = gifUrl;
        }
      }
    } catch (_) {/* ignore prefetch errors */}
  }
}
