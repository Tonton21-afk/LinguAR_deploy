import 'package:flutter/material.dart';
import 'cards/sample_page.dart';
import 'cards/card_page1.dart';
import 'cards/card_page2.dart';
import 'cards/card_page3.dart';
import 'cards/card_page4.dart';
import 'cards/card_page5.dart';

class FSLTranslatePage extends StatelessWidget {
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
        // Add scroll view to handle overflow
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // First card (with the original content and illustration)
                ClipRRect(
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
                          // Text column (on the left)
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Especially For You',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
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
                                          builder: (context) =>
                                              SamplePage()), // Navigate to SamplePage
                                    );
                                  },
                                  child: Text('Click Here'),
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 8),
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
                ),
                SizedBox(height: 16),
                // Add left margin to the "Topic" text
                Container(
                  margin: EdgeInsets.only(left: 16.0),
                  child: Text(
                    'Topic',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                // Add 5 more cards with updated text
                for (int i = 0; i < 5; i++) ...[
                  SizedBox(height: 16),
                  ClipRRect(
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
                                    i == 0
                                        ? 'Daily Communication'
                                        : i == 1
                                            ? 'Family, Relationships, and Social Life'
                                            : i == 2
                                                ? 'Learning, Work, and Technology'
                                                : i == 3
                                                    ? 'Travel, Food, and Environment'
                                                    : 'Interactive Learning and Emergency',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF4A90E2),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    i == 0
                                        ? 'Essential phrases for everyday conversations.'
                                        : i == 1
                                            ? 'Express feelings and connect with loved ones.'
                                            : i == 2
                                                ? 'Communicate in academic, professional, and digital settings.'
                                                : i == 3
                                                    ? 'Navigate new places, order food, and discuss nature.'
                                                    : 'Engage in learning activities and handle urgent situations.',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF000000),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 16),
                            InkWell(
                              onTap: () {
                                // Navigate to respective card page when arrow is tapped
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      switch (i) {
                                        case 0:
                                          return CardPage1();
                                        case 1:
                                          return CardPage2();
                                        case 2:
                                          return CardPage3();
                                        case 3:
                                          return CardPage4();
                                        case 4:
                                          return CardPage5();
                                        default:
                                          return CardPage1();
                                      }
                                    },
                                  ),
                                );
                              },
                              splashColor: Color(
                                  0xFF4A90E2), // Color of the ripple effect
                              highlightColor: Color(0xFF4A90E2).withOpacity(
                                  0.2), // Highlight color when pressed
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
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
