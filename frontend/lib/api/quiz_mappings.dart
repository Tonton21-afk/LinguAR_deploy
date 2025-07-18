import 'dart:math';
import 'package:lingua_arv1/api/basic_phrases.dart';
import 'package:lingua_arv1/api/pronouns.dart';
import 'package:lingua_arv1/api/valid_wrong_answers.dart';
import 'package:lingua_arv1/api/family_friends.dart';
import 'package:lingua_arv1/api/relationships.dart';
import 'package:lingua_arv1/api/education.dart';
import 'package:lingua_arv1/api/technology.dart';
import 'package:lingua_arv1/api/transportation.dart';
import 'package:lingua_arv1/api/food_drinks.dart';
import 'package:lingua_arv1/api/work_profession.dart';
import 'package:lingua_arv1/api/emergency.dart';
import 'package:lingua_arv1/api/shapes_colors.dart';



List<Map<String, String>> generateQuizData(String category) {
  final Random random = Random();
  final List<Map<String, String>> quizData = [];

  // Debug: Start quiz generation
  print("---- DEBUG: Quiz Generation Start ----");
  print("Selected Category: $category");

  // Choose the correct mapping based on category
  Map<String, String> selectedMappings = {};

  switch (category) {
    case "Daily Communication":
      selectedMappings = pronounsMappings;
      break;
    case "Family & Relationships":
      selectedMappings = {...familyFriendsMappings, ...relationshipMappings};
      break;
    case "Learning, Work, and Technology":
      selectedMappings = {...workProfessionMappings, ...technologyMappings, ...educationMappings};
      break;
    case "Travel, Food, and Environment":
      selectedMappings = {...fooddrinksMappings, ...transportationMappings};
      break;
    case "Emergency":
      selectedMappings = {...emergencyNatureMappings, ...shapeColorsMappings};
    default:
      throw Exception("Invalid category: $category");
  }

  // Debug: Print the selected mappings for the category
  print("DEBUG: Selected Phrases for $category -> ${selectedMappings.keys.toList()}");

  final List<String> allPhrases = selectedMappings.keys.toList();
  allPhrases.shuffle(random);
  final List<String> selectedPhrases = allPhrases.take(15).toList();

  for (final phrase in selectedPhrases) {
    final validWrongs = validWrongAnswers[phrase] ?? [];

    if (validWrongs.isEmpty) {
      throw Exception("No valid wrong answers found for phrase: $phrase");
    }

    final wrongAnswer = validWrongs[random.nextInt(validWrongs.length)];

    // Ensure correct answer is always included
    List<String> choices = [phrase, wrongAnswer]..shuffle(random);

    // Ensure correct GIF path assignment
    final String correctGifPath = selectedMappings[phrase] ?? "";

    if (correctGifPath.isEmpty) {
      throw Exception("Missing GIF path for phrase: $phrase");
    }

    // Debug: Print quiz item details
    print("---- DEBUG: Quiz Item ----");
    print("Phrase: $phrase");
    print("Correct Answer: $phrase");
    print("Wrong Answer: $wrongAnswer");
    print("Shuffled Choices: $choices");
    print("GIF Path: $correctGifPath");

    // Debug: Validate GIF Path Structure
    if (!correctGifPath.contains("LinguaAR/")) {
      print("WARNING: Unexpected GIF Path for $phrase -> $correctGifPath");
    }

    quizData.add({
      "phrase": phrase,
      "correct": phrase,
      "wrong": wrongAnswer,
      "answer1": choices[0],
      "answer2": choices[1],
      "gifPath": correctGifPath,
    });

    // Debug: Ensure correct data integrity
    assert(choices.contains(phrase), 'ERROR: Correct answer missing for phrase: $phrase');
    assert(correctGifPath.isNotEmpty, 'ERROR: Missing GIF path for phrase: $phrase');
  }

  // Debug: Quiz generation completed
  print("---- DEBUG: Quiz Generation Completed ----");
  print("Total Quiz Items Generated: ${quizData.length}");

  return quizData;
}
