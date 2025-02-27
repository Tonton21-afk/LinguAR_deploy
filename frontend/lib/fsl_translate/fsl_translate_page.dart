import 'package:flutter/material.dart';
import 'package:lingua_arv1/screens/fsl_Quiz/signLearningScreen.dart';
import '../screens/fsl_Quiz/cards/sample_page.dart';
import '../screens/fsl_Quiz/cards/card_page2.dart';
import '../screens/fsl_Quiz/cards/card_page3.dart';
import '../screens/fsl_Quiz/cards/card_page4.dart';
import '../screens/fsl_Quiz/cards/card_page5.dart';
import 'package:lingua_arv1/Widgets/topic_section.dart';

class FSLTranslatePage extends StatefulWidget {
  @override
  _FSLTranslatePageState createState() => _FSLTranslatePageState();
}

class _FSLTranslatePageState extends State<FSLTranslatePage> {
  late ScrollController _scrollController;
  Color appBarColor = const Color(0xFFFEFFFE);

  final List<Map<String, dynamic>> topics = [
    {
      'title': 'Daily Communication',
      'description': 'Essential phrases for everyday conversations.',
      'page': SignLearningScreen()
    },
    {
      'title': 'Family, Relationships, and Social Life',
      'description': 'Express feelings and connect with loved ones.',
      'page': CardPage2()
    },
    {
      'title': 'Learning, Work, and Technology',
      'description':
          'Communicate in academic, professional, and digital settings.',
      'page': CardPage3()
    },
    {
      'title': 'Travel, Food, and Environment',
      'description': 'Navigate new places, order food, and discuss nature.',
      'page': CardPage4()
    },
    {
      'title': 'Interactive Learning and Emergency',
      'description':
          'Engage in learning activities and handle urgent situations.',
      'page': CardPage5()
    },
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    setState(() {
      appBarColor = _scrollController.offset > 50
          ? const Color(0xFF4A90E2)
          : const Color(0xFFFEFFFE);
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFFEFFFE),
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              automaticallyImplyLeading: false,
              backgroundColor: appBarColor,
              elevation: 4,
              expandedHeight: kToolbarHeight,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(
                  'Filipino Sign Language Lessons',
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    color: appBarColor == const Color(0xFFFEFFFE)
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
              ),
            ),
          ];
        },
        body: ListView(
          padding: EdgeInsets.all(screenWidth * 0.04),
          physics: ClampingScrollPhysics(), //  smooth scrolling
          children: [
            // "Especially for You"
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Card(
                color: Colors.white,
                elevation: 5,
                child: Container(
                  width: screenWidth * 0.9,
                  height: screenHeight * 0.22,
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
                              'Especially For You',
                              style: TextStyle(
                                fontSize: screenWidth * 0.05,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            Text(
                              'Learn Filipino Sign Language from scratch.',
                              style: TextStyle(
                                fontSize: screenWidth * 0.035,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SamplePage(),
                                  ),
                                );
                              },
                              child: Text('Click Here'),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.07,
                                  vertical: screenHeight * 0.01,
                                ),
                                backgroundColor: const Color(0xff191E20),
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.04),
                      Image.asset(
                        'assets/illustrations/especial.png',
                        width: screenWidth * 0.25,
                        height: screenWidth * 0.25,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),

            // Topics Section (From Widgets Folder)
            TopicSection(
              screenWidth: screenWidth,
              screenHeight: screenHeight,
              topics: topics,
            ),
          ],
        ),
      ),
    );
  }
}
