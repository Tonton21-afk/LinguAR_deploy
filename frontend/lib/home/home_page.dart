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
      final response =
          await http.get(Uri.parse('$basicurl/favorites/favorites/$userId'));
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
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Color(0xFF273236)
          // Dark mode color
          : Color(0xFFFEFFFE),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitle('Shortcuts', screenWidth,
                      context), // ✅ Pass context for theming
                  SizedBox(height: screenHeight * 0.015),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: ShortcutButton(
                            icon: Icons.fingerprint,
                            iconColor: Colors.white,
                            labelWidget: Text(
                              'Gesture Translator',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16, // Adjust size as needed
                                fontWeight: FontWeight.bold,
                                color:
                                    Colors.white, // ✅ White text in light mode
                              ),
                            ),
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
                            iconColor:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white // ✅ Dark icon in dark mode
                                    : Colors.white,
                            labelWidget: Text(
                              'LinguaVoice',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16, // Adjust size as needed
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white // ✅ Dark text in dark mode
                                    : Colors
                                        .white, // ✅ White text in light mode
                              ),
                            ),
                            backgroundColor:
                                Theme.of(context).brightness == Brightness.dark
                                    ? const Color.fromARGB(
                                        255, 29, 29, 29) // ✅ Darker gray
                                    // Dark mode color
                                    : Color(0xFF273236),
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
            _buildTitle('Favorites', screenWidth, context),
            SizedBox(height: screenHeight * 0.01),
            Expanded(
              child: FavoritesList(favorites: favorites),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(String text, double screenWidth, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
      child: Text(
        text,
        style: TextStyle(
            fontSize: screenWidth * 0.045,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white // White in dark mode
                : Color(0xFF273236)),
      ),
    );
  }
}

class ShortcutButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor; // ✅ Add iconColor property
  final Widget labelWidget; // ✅ Change from String to Widget
  final Color backgroundColor;
  final VoidCallback onTap;

  const ShortcutButton({
    required this.icon,
    required this.iconColor, // ✅ Add to constructor
    required this.labelWidget, // ✅ Use a Widget for dynamic styling
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
            Icon(icon, color: iconColor, size: screenWidth * 0.08),
            SizedBox(height: screenHeight * 0.01),
            labelWidget, // ✅ Use the widget for label
          ],
        ),
      ),
    );
  }
}
