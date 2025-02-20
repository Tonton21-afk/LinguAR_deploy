import 'package:flutter/material.dart';
import 'cards/sample_page.dart';
import 'cards/card_page1.dart';
import 'cards/card_page2.dart';
import 'cards/card_page3.dart';
import 'cards/card_page4.dart';
import 'cards/card_page5.dart';
import 'package:lingua_arv1/screens/fsl_Quiz/signLearningScreen.dart';

class FSLTranslatePage extends StatelessWidget {
  final List<Map<String, dynamic>> topics = [
    {
      'title': 'Daily Communication',
      'description': 'Essential phrases for everyday conversations.',
      'page': SignLearningScreen(),
    },
    {
      'title': 'Family, Relationships, and Social Life',
      'description': 'Express feelings and connect with loved ones.',
      'page': CardPage2(),
    },
    {
      'title': 'Learning, Work, and Technology',
      'description':
          'Communicate in academic, professional, and digital settings.',
      'page': CardPage3(),
    },
    {
      'title': 'Travel, Food, and Environment',
      'description': 'Navigate new places, order food, and discuss nature.',
      'page': CardPage4(),
    },
    {
      'title': 'Interactive Learning and Emergency',
      'description':
          'Engage in learning activities and handle urgent situations.',
      'page': CardPage5(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFFEFFFE),
        title: Center(
          child: Text(
            'Filipino Sign Language Lessons',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
      backgroundColor: Color(0xFFFEFFFE),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildIntroCard(context),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    'Topic',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 16),
                ...topics
                    .map((topic) => _buildTopicCard(context, topic))
                    .toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIntroCard(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Card(
        color: Colors.white,
        elevation: 5,
        child: Container(
          width: 350,
          height: 170,
          margin: EdgeInsets.symmetric(horizontal: 16),
          padding: EdgeInsets.all(8),
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
                      'Especially For You',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Learn Filipino Sign Language from scratch.',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignLearningScreen()),
                        );
                      },
                      child: Text('Click Here'),
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                        backgroundColor: Color(0xff191E20),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16),
              Image.asset(
                'assets/illustrations/especial.png',
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopicCard(BuildContext context, Map<String, dynamic> topic) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Card(
          color: Colors.white,
          elevation: 5,
          child: Container(
            width: 350,
            height: 100,
            margin: EdgeInsets.symmetric(horizontal: 16),
            padding: EdgeInsets.all(8),
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
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4A90E2),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        topic['description'],
                        style:
                            TextStyle(fontSize: 12, color: Color(0xFF000000)),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => topic['page']),
                    );
                  },
                  splashColor: Color(0xFF4A90E2),
                  highlightColor: Color(0xFF4A90E2).withOpacity(0.2),
                  child: Icon(
                    Icons.arrow_forward,
                    size: 24,
                    color: Color(0xff191E20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
