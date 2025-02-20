import 'dart:math';
import 'package:lingua_arv1/api/basic_phrases.dart';
import 'package:lingua_arv1/api/valid_wrong_answers.dart';

List<Map<String, String>> generateQuizData() {
  final List<String> allPhrases = basicPhrasesMappings.keys.toList();
  final Random random = Random();

  final quizData = allPhrases.map((phrase) {
    // Get valid wrong answers for the current phrase
    final validWrongs = validWrongAnswers[phrase] ?? [];

    // Ensure there are valid wrong answers
    if (validWrongs.isEmpty) {
      throw Exception("No valid wrong answers found for phrase: $phrase");
    }

    // Randomly select a wrong answer from the valid list
    String wrongAnswer = validWrongs[random.nextInt(validWrongs.length)];

    // Ensure the correct answer is always included
    List<String> answers = [phrase, wrongAnswer];
    answers.shuffle(random);

    return {
      "phrase": phrase,
      "correct": phrase, // Correct answer
      "wrong": wrongAnswer, // Wrong answer
      "answer1": answers[0], // Randomized position
      "answer2": answers[1], // Randomized position
      "gifPath": basicPhrasesMappings[phrase] ?? "",
    };
  }).toList();

  quizData.shuffle(random); // Shuffle the quiz order

  // Debug: Print the generated quiz data
  print("Generated Quiz Data:");
  quizData.forEach((question) {
    print("Phrase: ${question["phrase"]}, GIF Path: ${question["gifPath"]}");
    print("Answer1: ${question["answer1"]}, Answer2: ${question["answer2"]}");
  });

  return quizData;
}