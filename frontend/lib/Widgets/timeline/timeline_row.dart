import 'package:flutter/material.dart';
import 'package:lingua_arv1/Widgets/lesson_status.dart';
import 'dotted_rail.dart';
import 'node_indicator.dart';
import 'lesson_card.dart';

class TimelineRow extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final bool locked;
  final LessonStatus status;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final int number;
  final String unitLabel;

  const TimelineRow({
    super.key,
    required this.isFirst,
    required this.isLast,
    required this.locked,
    required this.status,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.number,    
    required this.unitLabel,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const green = Color(0xFF2ECC71);

    final bool dim = status == LessonStatus.upcoming;
    final double opacity = dim ? 0.35 : 1.0;

    return Opacity(
      opacity: opacity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 64,
            height: 118,
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Positioned.fill(
                  left: 31,
                  right: null,
                  child: DottedRail(
                    hideTop: isFirst,
                    hideBottom: isLast,
                    color: isDark
                        ? Colors.white.withOpacity(0.18)
                        : Colors.black.withOpacity(0.12),
                  ),
                ),
                // node (ring + badge)
                const Positioned(
                  top: 36,
                  left: 13,
                  child: SizedBox(), 
                ),
                Positioned(
                  top: 36,
                  left: 13,
                  child: NodeIndicator(status: status),
                ),
            
                if (status == LessonStatus.completed && !isLast)
                  Positioned(
                    top: 36 + 38,
                    left: 32 - 1,
                    child: Container(width: 2, height: 14, color: green),
                  ),
              ],
            ),
          ),
          Expanded(
            child: LessonCard(
              status: status,
              title: title,
              subtitle: subtitle,
              locked: locked,
              onTap: onTap,
              number: number,          
              unitLabel: unitLabel,
            ),
          ),
        ],
      ),
    );
  }
}
