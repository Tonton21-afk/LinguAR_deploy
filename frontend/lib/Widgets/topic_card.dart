import 'package:flutter/material.dart';

class TopicCard extends StatelessWidget {
  final Map<String, dynamic> topic;
  final double screenWidth;
  final double screenHeight;

  const TopicCard({
    Key? key,
    required this.topic,
    required this.screenWidth,
    required this.screenHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => topic['page'],
          ),
        );
      },
      splashColor: Colors.transparent,  
      highlightColor: Colors.transparent,
      borderRadius: BorderRadius.circular(15),
      child: Padding(
        padding: EdgeInsets.only(bottom: screenHeight * 0.015),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Card(
            color: Colors.white,
            elevation: 5,
            child: Container(
              width: screenWidth * 0.9,
              height: screenHeight * 0.13,
              padding: EdgeInsets.all(screenWidth * 0.03),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          topic['title'],
                          style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF4A90E2),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.005),
                        Text(
                          topic['description'],
                          style: TextStyle(
                            fontSize: screenWidth * 0.035,
                            color: const Color(0xFF000000),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.04),
                  Icon(
                    Icons.arrow_forward,
                    size: screenWidth * 0.06,
                    color: const Color(0xff191E20),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
