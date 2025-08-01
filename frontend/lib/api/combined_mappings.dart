import 'package:flutter/material.dart';
import 'package:lingua_arv1/api/Education.dart';
import 'package:lingua_arv1/api/emergency.dart';
import 'package:lingua_arv1/api/basic_phrases.dart';
import 'package:lingua_arv1/api/alphabet_numbers_gif_mappings.dart';
import 'package:lingua_arv1/api/family_friends.dart';
import 'package:lingua_arv1/api/food_drinks.dart';
import 'package:lingua_arv1/api/pronouns.dart';
import 'package:lingua_arv1/api/relationships.dart';
import 'package:lingua_arv1/api/shapes_colors.dart';
import 'package:lingua_arv1/api/technology.dart';
import 'package:lingua_arv1/api/transportation.dart';
import 'package:lingua_arv1/api/work_profession.dart';

final Map<String, String> combinedMappings = {
  ...basicPhrasesMappings,
  ...alphabetNumbersMappings,
  ...educationMappings,
  ...emergencyNatureMappings,
  ...familyFriendsMappings,
  ...fooddrinksMappings,
  ...pronounsMappings,
  ...relationshipMappings,
  ...shapeColorsMappings,
  ...technologyMappings,
  ...transportationMappings,
  ...workProfessionMappings

  
};
