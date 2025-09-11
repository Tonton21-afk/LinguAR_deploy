import 'package:flutter/material.dart';

class DottedRail extends StatelessWidget {
  final bool hideTop;
  final bool hideBottom;
  final Color color;

  const DottedRail({
    super.key,
    required this.color,
    this.hideTop = false,
    this.hideBottom = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, c) {
        final total = c.maxHeight;
        const dash = 6.0;
        const gap = 6.0;
        final count = (total / (dash + gap)).floor();
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(count, (i) {
            final isTop = i == 0, isBottom = i == count - 1;
            final hidden = (hideTop && isTop) || (hideBottom && isBottom);
            return SizedBox(
              height: dash,
              width: 2,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: hidden ? Colors.transparent : color,
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
