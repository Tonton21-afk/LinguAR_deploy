import 'package:flutter/material.dart';
import 'package:lingua_arv1/fsl_guide/daily_communication/alphabet_numbers_page.dart';
import 'package:lingua_arv1/fsl_guide/daily_communication/pronouns_page.dart';
import 'package:lingua_arv1/fsl_guide/daily_communication/common_expressions_page.dart';
import 'package:lingua_arv1/fsl_guide/daily_communication/basic_phrases_page.dart';
import 'package:lingua_arv1/fsl_guide/family_relationships/family_friends_page.dart';
import 'package:lingua_arv1/fsl_guide/family_relationships/relationships_page.dart';
import 'package:lingua_arv1/fsl_guide/learning_work_technology/education_page.dart';
import 'package:lingua_arv1/fsl_guide/learning_work_technology/technology_page.dart';
import 'package:lingua_arv1/fsl_guide/learning_work_technology/work_profession_page.dart';
import 'package:lingua_arv1/fsl_guide/travel_food_environment/food_drinks_page.dart';
import 'package:lingua_arv1/fsl_guide/travel_food_environment/nature_environment_page.dart';
import 'package:lingua_arv1/fsl_guide/travel_food_environment/transportation_page.dart';
import 'package:lingua_arv1/fsl_guide/interactive_learning_emergency/shape_colors_page.dart';

class FSLGuidePage extends StatefulWidget {
  @override
  _FSLGuidePageState createState() => _FSLGuidePageState();
}

class _FSLGuidePageState extends State<FSLGuidePage> {
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
    final screenWidth = MediaQuery.of(context).size.width;

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
                  'Filipino Sign Language Guides',
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
        body: Padding(
          padding: EdgeInsets.all(screenWidth * 0.02),
          child: ListView(
            children: [
              _buildSectionTitle(
                  'Family, Relationships & Social Life', screenWidth),
              _buildGridView(context, [
                _buildCard(context, Icons.family_restroom, 'Family & Friends',
                    FamilyFriendsPage(), Color(0xFFACCFFB)),
                _buildCard(context, Icons.favorite, 'Relationships',
                    RelationshipsPage(), Color(0xFFFEE6DF)),
              ]),
              _buildSectionTitle('Learning & Work', screenWidth),
              _buildGridView(context, [
                _buildCard(context, Icons.school, 'Education', EducationPage(),
                    Color(0xFFFEE6DF)),
                _buildCard(context, Icons.work, 'Work & Profession',
                    WorkProfessionPage(), Color(0xFFC3CDD1)),
              ]),
              _buildSectionTitle('Food & Environment', screenWidth),
              _buildGridView(context, [
                _buildCard(context, Icons.local_dining, 'Food & Drinks',
                    FoodDrinksPage(), Color(0xFFACCFFB)),
                _buildCard(context, Icons.park, 'Emergency and Nature',
                    NatureEnvironmentPage(), Color(0xFFF4ABAA)),
              ]),
              _buildSectionTitle('Transportation & Technology', screenWidth),
              _buildGridView(context, [
                _buildCard(context, Icons.directions_bus, 'Transportation',
                    TransportationPage(), Color(0xFFFEE6DF)),
                _buildCard(context, Icons.computer, 'Technology',
                    TechnologyPage(), Color(0xFFC3CDD1)),
              ]),
              _buildSectionTitle('Daily Communication', screenWidth),
              _buildGridView(context, [
                _buildCard(context, Icons.language, 'Pronouns', PronounsPage(),
                    Color(0xFFC3CDD1)),
                _buildCard(context, Icons.chat, 'Basic Phrases',
                    BasicPhrasesPage(), Color(0xFFACCFFB)),
              ]),
              _buildSectionTitle(
                  'Interactive Learning & Emergency', screenWidth),
              _buildGridView(context, [
                _buildCard(context, Icons.palette, 'Shape & Colors',
                    ShapeColorsPage(), Color(0xFFF4ABAA)),
                _buildCard(context, Icons.numbers, 'Alphabet & Numbers',
                    AlphabetNumbersPage(), Color(0xFFFEE6DF)),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, double screenWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenWidth * 0.03),
      child: Text(
        title,
        style: TextStyle(
          fontSize: screenWidth * 0.04,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildGridView(BuildContext context, List<Widget> cards) {
    final screenWidth = MediaQuery.of(context).size.width;
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: screenWidth < 600 ? 2 : 3,
      crossAxisSpacing: screenWidth * 0.02,
      mainAxisSpacing: screenWidth * 0.02,
      childAspectRatio: 1,
      children: cards,
    );
  }

  Widget _buildCard(BuildContext context, IconData icon, String text,
      Widget nextPage, Color iconColor) {
    final screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => nextPage),
        );
      },
      child: Card(
        color: iconColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.06),
        ),
        elevation: 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: screenWidth * 0.06,
              child: Icon(icon, size: screenWidth * 0.06, color: iconColor),
              backgroundColor: Colors.white,
            ),
            SizedBox(height: screenWidth * 0.02),
            Text(text,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: screenWidth * 0.03, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
