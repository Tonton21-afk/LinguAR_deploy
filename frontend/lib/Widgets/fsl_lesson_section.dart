import 'package:flutter/material.dart';
import 'package:lingua_arv1/Widgets/ChapterTimelineList.dart';
import 'package:lingua_arv1/Widgets/unitHeader.dart';
import 'package:lingua_arv1/screens/fsl_Quiz/lesson_flow_page.dart';
import 'package:lingua_arv1/services/progress_store.dart';

class FslLessonsSection extends StatefulWidget {
  final String trackKey;
  final String headerTitle;
  final Color? progressColor;
  final List<Map<String, dynamic>> topics;

  const FslLessonsSection({
    super.key,
    required this.trackKey,
    required this.topics,
    this.headerTitle = ' Chapter: Filipino Sign Language Lessons',
    this.progressColor,
  });

  @override
  State<FslLessonsSection> createState() => _FslLessonsSectionState();
}

class _FslLessonsSectionState extends State<FslLessonsSection> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final idx = await ProgressStore.getCurrentIndex(widget.trackKey);
    if (!mounted) return;
    setState(() => _currentIndex = idx.clamp(0, widget.topics.length - 1));
  }

  void _showLockedSnack() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Finish the previous lesson to unlock this one.'),
        duration: Duration(milliseconds: 1400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UnitHeader(
          title: widget.headerTitle,
          currentIndex: _currentIndex,
          total: widget.topics.length,
          dense: true,

          progressColor: widget.progressColor ?? const Color(0xFF4A90E2),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ChapterTimelineList(
              topics: widget.topics,
              currentIndex: _currentIndex,
              onOpen: (index, topic) async {
                if (index > _currentIndex) {
                  _showLockedSnack();
                  return;
                }

                final bool? completed = await Navigator.of(context).push<bool>(
                  MaterialPageRoute(builder: (_) => topic['page'] as Widget),
                );

                if (completed == true) {
                  final next = (_currentIndex < widget.topics.length - 1)
                      ? _currentIndex + 1
                      : _currentIndex;
                  if (next != _currentIndex) {
                    await ProgressStore.setCurrentIndex(widget.trackKey, next);
                    await _loadProgress();
                  }
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
