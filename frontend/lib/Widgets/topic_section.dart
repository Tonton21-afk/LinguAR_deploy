import 'package:flutter/material.dart';
import 'topic_card.dart';

class TopicSection extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  final List<Map<String, dynamic>> topics;

  const TopicSection({
    Key? key,
    required this.screenWidth,
    required this.screenHeight,
    required this.topics,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: screenWidth * 0.04),
          child: Text(
            'Topics',
            style: TextStyle(
              fontSize: screenWidth * 0.045,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white // Dark mode color
                  : Colors.black,
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.02),
        ...topics
            .map((topic) => TopicCard(
                topic: topic,
                screenWidth: screenWidth,
                screenHeight: screenHeight))
            .toList(),
      ],
    );
  }
}
