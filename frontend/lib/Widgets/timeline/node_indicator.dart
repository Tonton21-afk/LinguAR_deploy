import 'package:flutter/material.dart';
import 'package:lingua_arv1/Widgets/lesson_status.dart';

class NodeIndicator extends StatelessWidget {
  final LessonStatus status;
  final ImageProvider? image;

  const NodeIndicator({
    super.key,
    required this.status,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF4A90E2);
    const green = Color(0xFF2ECC71);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color ringColor;
    double ringWidth;
    switch (status) {
      case LessonStatus.completed:
        ringColor = green; ringWidth = 3; break;
      case LessonStatus.current:
        ringColor = blue;  ringWidth = 3; break;
      case LessonStatus.upcoming:
        ringColor = isDark ? const Color(0xFF2C2F33) : const Color(0xFFE5E7EB);
        ringWidth = 2;
        break;
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: ringColor, width: ringWidth),
          ),
          child: ClipOval(
            child: image != null
              ? Image(image: image!, fit: BoxFit.cover)
              : Container(
                  color: isDark ? const Color(0xFF2A2F33) : const Color(0xFFF3F4F6),
                ),
          ),
        ),
        if (status == LessonStatus.completed)
          const Positioned(
            bottom: -6,
            left: -2,
            child: _CheckBadge(),
          ),
      ],
    );
  }
}

class _CheckBadge extends StatelessWidget {
  const _CheckBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20, height: 20,
      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: const Icon(Icons.check_circle, size: 18, color: Color(0xFF2ECC71)),
    );
  }
}
