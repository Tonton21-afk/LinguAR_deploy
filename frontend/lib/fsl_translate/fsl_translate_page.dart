import 'package:flutter/material.dart';
import 'package:lingua_arv1/screens/fsl_Quiz/signLearningScreen.dart';
import 'cards/sample_page.dart';
import 'cards/card_page1.dart';
import 'cards/card_page2.dart';
import 'cards/card_page3.dart';
import 'cards/card_page4.dart';
import 'cards/card_page5.dart';

class FSLTranslatePage extends StatefulWidget {
  @override
  _FSLTranslatePageState createState() => _FSLTranslatePageState();
}

class _FSLTranslatePageState extends State<FSLTranslatePage> {
  late ScrollController _scrollController;
  Color appBarColor = Color(0xFFFEFFFE);

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      setState(() {
        appBarColor = _scrollController.offset > 50
            ? Color(0xFF4A90E2)
            : Color(0xFFFEFFFE);
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFFFEFFFE),
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
                    color: appBarColor == Color(0xFFFEFFFE)
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
              ),
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                                      backgroundColor: Color(0xff191E20),
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
                  Container(
                    margin: EdgeInsets.only(left: screenWidth * 0.04),
                    child: Text(
                      'Topic',
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  for (int i = 0; i < 5; i++) ...[
                    SizedBox(height: screenHeight * 0.015),
                    ClipRRect(
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
                                        fontSize: screenWidth * 0.04,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF4A90E2),
                                      ),
                                    ),
                                    SizedBox(height: screenHeight * 0.005),
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
                                        fontSize: screenWidth * 0.035,
                                        color: Color(0xFF000000),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: screenWidth * 0.04),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        switch (i) {
                                          case 0:
                                            return  SignLearningScreen();
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
                                splashColor: Color(0xFF4A90E2),
                                highlightColor:
                                    Color(0xFF4A90E2).withOpacity(0.2),
                                child: Icon(
                                  Icons.arrow_forward,
                                  size: screenWidth * 0.06,
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
      ),
    );
  }
}
