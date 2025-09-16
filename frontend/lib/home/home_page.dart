import 'package:flutter/material.dart';
import 'package:lingua_arv1/Widgets/fsl_lesson_section.dart';
import 'package:lingua_arv1/screens/fsl_Quiz/lesson_flow_page.dart';


void main() {
  runApp(MaterialApp(
    home: HomePage(),
    debugShowCheckedModeBanner: false,
  ));
}
class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const String _trackKey = 'fsl_translate_track';

  final List<Map<String, dynamic>> topics = const [
    {
      'title': 'Daily Communication',
      'description': 'Essential phrases for everyday conversations.',
      'page': LessonFlowPage(category: "Daily Communication & Basic Phrases"),
    },
    {
      'title': 'Family',
      'description': 'Connect with loved ones.',
      'page': LessonFlowPage(category: "Family"),
    },
    {
      'title': 'Relationships',
      'description': 'Express feelings.',
      'page': LessonFlowPage(category: "Relationships"),
    },
    {
      'title': 'Travel, Food, and Environment',
      'description': 'Essential phrases for Travel',
      'page': LessonFlowPage(category: "Travel, Food, and Environment"),
    },
    {
      'title': 'Learning, Work, and Technology',
      'description':
          'Communicate in academic, professional, and digital settings.',
      'page': LessonFlowPage(category: "Learning, Work & Technology"),
    },
    {
      'title': 'Colors, numbers & Alphabet',
      'description': 'Basics of FSL.',
      'page': LessonFlowPage(category: "Colors, numbers & Alphabet"),
    },
    {
      'title': 'Interactive Learning and Emergency',
      'description': 'Engage in learning activities and handle urgent situations.',
      'page': LessonFlowPage(category: "Emergency"),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF273236) : const Color(0xFFFEFFFE),
      body: SafeArea(
        child: FslLessonsSection(
          trackKey: _trackKey,
          topics: topics,
          progressColor: const Color(0xFF4A90E2),
        ),
      ),
    );
  }
}
