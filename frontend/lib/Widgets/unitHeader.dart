import 'package:flutter/material.dart';

class UnitHeader extends StatelessWidget {
  final String title;
  final int currentIndex;
  final int total;


  final bool dense;
  final TextStyle? titleStyle;
  final Color? progressColor;


  final EdgeInsets padding;

  const UnitHeader({
    super.key,
    required this.title,
    required this.currentIndex,
    required this.total,
    this.dense = false,
    this.titleStyle,
    this.progressColor,
    this.padding = const EdgeInsets.fromLTRB(16, 8, 16, 10), 
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final completed = currentIndex.clamp(0, total);
    final pct = total == 0 ? 0.0 : completed / total;

    final smallTitle = theme.textTheme.titleSmall?.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w700,
    );
    final bigTitle = theme.textTheme.titleLarge?.copyWith(
      fontWeight: FontWeight.w800,
    );
    final effectiveTitleStyle = titleStyle ?? (dense ? smallTitle : bigTitle);
    final gapAfterTitle = dense ? 4.0 : 6.0;
    final barHeight = dense ? 6.0 : 8.0;

    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty) ...[
            Text(title,
              style: effectiveTitleStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: gapAfterTitle),
          ],
          Text('$completed/$total lessons completed',
              style: theme.textTheme.bodyMedium),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: barHeight,
              color: progressColor,
            ),
          ),
        ],
      ),
    );
  }
}
