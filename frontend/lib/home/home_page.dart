import 'package:flutter/material.dart';
import 'package:lingua_arv1/home/favorites/FavoritesList.dart';
import 'feature/gesture_translator.dart';
import 'feature/text_to_speech.dart';
import 'package:lingua_arv1/validators/token.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:lingua_arv1/repositories/Config.dart';

void main() {
  runApp(MaterialApp(
    home: HomePage(),
    debugShowCheckedModeBanner: false,
  ));
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> favorites = [];
  String basicurl = BasicUrl.baseURL;
  String? userId;


  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  /// Load the user ID and fetch favorites
  Future<void> _loadUserId() async {
    userId = await TokenService.getUserId();
    if (userId != null) {
      print("✅ User ID Loaded: $userId");
      _fetchFavorites();
    } else {
      print("❌ Error: User ID is null");
    }
  }

  /// Fetch user's favorite phrases from API
  Future<void> _fetchFavorites() async {
    if (userId == null) return;
    try {
      final response = await http.get(Uri.parse('$basicurl/favorites/favorites/$userId'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          favorites = List<Map<String, dynamic>>.from(data);
        });
      } else {
        print("❌ Error fetching favorites: ${response.body}");
      }
    } catch (e) {
      print("❌ Exception fetching favorites: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFFEFFFE),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitle('Shortcuts', screenWidth),
                  SizedBox(height: screenHeight * 0.015),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: ShortcutButton(
                            icon: Icons.fingerprint,
                            label: 'Gesture Translator',
                            backgroundColor: const Color(0xFF4A90E2),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GestureTranslator(),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.04),
                      Expanded(
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: ShortcutButton(
                            icon: Icons.volume_up,
                            label: 'LinguaVoice',
                            backgroundColor: const Color(0xFF273236),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TextToSpeech(),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            _buildTitle('Favorites', screenWidth),
            SizedBox(height: screenHeight * 0.01),
            Expanded(
              child: FavoritesList(favorites: favorites),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(String text, double screenWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
      child: Text(
        text,
        style: TextStyle(
          fontSize: screenWidth * 0.045,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class ShortcutButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color backgroundColor;
  final VoidCallback onTap;

  const ShortcutButton({
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(screenWidth * 0.04),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(screenWidth * 0.06),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: screenWidth * 0.08),
            SizedBox(height: screenHeight * 0.01),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: screenWidth * 0.035,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
