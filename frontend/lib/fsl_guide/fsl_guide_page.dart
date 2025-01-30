import 'package:flutter/material.dart';
import 'package:lingua_arv1/fsl_guide/daily_communication/alphabet_numbers_page.dart';
import 'package:lingua_arv1/fsl_guide/daily_communication/basic_phrases_page.dart';
import 'package:lingua_arv1/fsl_guide/daily_communication/common_expressions_page.dart';
import 'package:lingua_arv1/fsl_guide/daily_communication/situational_convos_page.dart';
import 'package:lingua_arv1/fsl_guide/family_relationships/cultural_values_page.dart';
import 'package:lingua_arv1/fsl_guide/family_relationships/family_friends_page.dart';
import 'package:lingua_arv1/fsl_guide/family_relationships/relationships_page.dart';
import 'package:lingua_arv1/fsl_guide/family_relationships/social_gatherings_page.dart';
import 'package:lingua_arv1/fsl_guide/interactive_learning_emergency/emergency_signs_page.dart';
import 'package:lingua_arv1/fsl_guide/interactive_learning_emergency/health_safety_page.dart';
import 'package:lingua_arv1/fsl_guide/interactive_learning_emergency/leisures_hobbies_page.dart';
import 'package:lingua_arv1/fsl_guide/interactive_learning_emergency/shape_colors_page.dart';
import 'package:lingua_arv1/fsl_guide/learning_work_technology/education_page.dart';
import 'package:lingua_arv1/fsl_guide/learning_work_technology/study_tools_page.dart';
import 'package:lingua_arv1/fsl_guide/learning_work_technology/technology_page.dart';
import 'package:lingua_arv1/fsl_guide/learning_work_technology/work_profession_page.dart';
import 'package:lingua_arv1/fsl_guide/travel_food_environment/food_drinks_page.dart';
import 'package:lingua_arv1/fsl_guide/travel_food_environment/nature_environment_page.dart';
import 'package:lingua_arv1/fsl_guide/travel_food_environment/transportation_page.dart';
import 'package:lingua_arv1/fsl_guide/travel_food_environment/travel_essentials_page.dart';

class FSLGuidePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFEFFFE),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFFEFFFE),
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'FSL Guide',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Handle search action here
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Daily Communication'),
              _buildGridView(context, [
                _buildCard(context, Icons.language, 'Basic Phrases',
                    BasicPhrasesPage(), Color(0xFFC3CDD1)),
                _buildCard(context, Icons.numbers, 'Alphabet & Numbers',
                    AlphabetNumbersPage(), Color(0xFFFEE6DF)),
                _buildCard(context, Icons.chat, 'Situational Convos',
                    SituationalConvosPage(), Color(0xFFACCFFB)),
                _buildCard(
                    context,
                    Icons.sentiment_satisfied,
                    'Common Expressions',
                    CommonExpressionsPage(),
                    Color(0xFFF4ABAA)),
              ]),
              _buildSectionTitle('Family, Relationships & Social Life'),
              _buildGridView(context, [
                _buildCard(context, Icons.family_restroom, 'Family & Friends',
                    FamilyFriendsPage(), Color(0xFFACCFFB)),
                _buildCard(context, Icons.group, 'Social Gatherings',
                    SocialGatheringsPage(), Color(0xFFC3CDD1)),
                _buildCard(context, Icons.comment, 'Cultural Values',
                    CulturalValuesPage(), Color(0xFFF4ABAA)),
                _buildCard(context, Icons.favorite, 'Relationships',
                    RelationshipsPage(), Color(0xFFFEE6DF)),
              ]),
              _buildSectionTitle('Learning, Work & Technology'),
              _buildGridView(context, [
                _buildCard(context, Icons.school, 'Education', EducationPage(),
                    Color(0xFFFEE6DF)),
                _buildCard(context, Icons.work, 'Work & Profession',
                    WorkProfessionPage(), Color(0xFFC3CDD1)),
                _buildCard(context, Icons.computer, 'Technology',
                    TechnologyPage(), Color(0xFFACCFFB)),
                _buildCard(context, Icons.menu_book, 'Study & Tools',
                    StudyToolsPage(), Color(0xFFF4ABAA)),
              ]),
              _buildSectionTitle('Travel, Food & Environment'),
              _buildGridView(context, [
                _buildCard(context, Icons.directions_bus, 'Transportation',
                    TransportationPage(), Color(0xFFC3CDD1)),
                _buildCard(context, Icons.local_dining, 'Food & Drinks',
                    FoodDrinksPage(), Color(0xFFACCFFB)),
                _buildCard(context, Icons.park, 'Nature & Environment',
                    NatureEnvironmentPage(), Color(0xFFF4ABAA)),
                _buildCard(context, Icons.travel_explore, 'Travel Essentials',
                    TravelEssentialsPage(), Color(0xFFFEE6DF)),
              ]),
              _buildSectionTitle('Interactive Learning & Emergency'),
              _buildGridView(context, [
                _buildCard(context, Icons.palette, 'Shape & Colors',
                    ShapeColorsPage(), Color(0xFFF4ABAA)),
                _buildCard(context, Icons.health_and_safety, 'Health & Safety',
                    HealthSafetyPage(), Color(0xFFC3CDD1)),
                _buildCard(context, Icons.sports_esports, 'Leisures & Hobbies',
                    LeisuresHobbiesPage(), Color(0xFFFEE6DF)),
                _buildCard(context, Icons.warning, 'Emergency Signs',
                    EmergencySignsPage(), Color(0xFFACCFFB)),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildGridView(BuildContext context, List<Widget> cards) {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 1,
      children: cards,
    );
  }

  Widget _buildCard(BuildContext context, IconData icon, String text,
      Widget nextPage, Color iconColor) {
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
          borderRadius: BorderRadius.circular(25), // updated radius here
        ),
        elevation: 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 20,
              child: Icon(
                icon,
                size: 20,
                color: iconColor,
              ),
              backgroundColor: Colors.white,
            ),
            SizedBox(height: 6),
            Text(
              text,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
