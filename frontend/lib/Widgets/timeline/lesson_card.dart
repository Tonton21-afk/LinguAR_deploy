import 'package:flutter/material.dart';
import 'package:lingua_arv1/Widgets/lesson_status.dart';

class LessonCard extends StatelessWidget {
  final LessonStatus status;
  final String title;
  final String subtitle;
  final bool locked;
  final VoidCallback onTap;
  final int number;
  final String unitLabel;

  const LessonCard({
    super.key,
    required this.status,
    required this.title,
    required this.subtitle,
    required this.locked,
    required this.onTap,
    required this.number,       
    required this.unitLabel,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const blue = Color(0xFF4A90E2);

    final cardBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final shadow = isDark ? Colors.transparent : Colors.black.withOpacity(0.06);
    final highlighted = status == LessonStatus.current;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeOut,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: highlighted ? const Color(0xFFEFF5FF) : cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: shadow,
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
        border: highlighted ? Border.all(color: blue.withOpacity(0.6), width: 2) : null,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$unitLabel $number',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF4A90E2),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.white70 : const Color(0xFF4B5563),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                locked ? Icons.lock_outline_rounded : Icons.cloud_download_outlined,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
