import 'package:flutter/material.dart';
import 'package:lingua_arv1/Widgets/lesson_status.dart';
import 'package:lingua_arv1/Widgets/timeline/timeline_row.dart';

class ChapterTimelineList extends StatelessWidget {
  final List<Map<String, dynamic>> topics;
  final int currentIndex;
  final void Function(int index, Map<String, dynamic> topic) onOpen;

  const ChapterTimelineList({
    super.key,
    required this.topics,
    required this.currentIndex,
    required this.onOpen,
  });

  LessonStatus _statusFor(int i) {
    if (i < currentIndex) return LessonStatus.completed;
    if (i == currentIndex) return LessonStatus.current;
    return LessonStatus.upcoming; 
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: topics.length + 1,
      itemBuilder: (context, i) {
        if (i == topics.length) return const SizedBox(height: 24);
        final t = topics[i];
        final status = _statusFor(i);
        final locked = i > currentIndex;
        return TimelineRow(
          key: ValueKey(t['title']),
          isFirst: i == 0,
          isLast: i == topics.length - 1,
          status: status,
          locked: locked,
          title: t['title'] as String,
          subtitle: t['description'] as String,
          onTap: () => onOpen(i, t),
          number: i + 1,           
          unitLabel: 'Lesson',
        );
      },
    );
  }
}
