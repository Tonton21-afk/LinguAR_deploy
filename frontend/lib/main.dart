import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lingua_arv1/screens/get_started/get_started_page1.dart';
import 'home/home_page.dart';
import 'fsl_translate/fsl_translate_page.dart';
import 'fsl_guide/fsl_guide_page.dart';
import 'settings/settings_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Jost',
      ),
      home: SplashScreen(),
    );
  }
}

// Splash Screen with SVG Icon in a Circle
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to GetStartedPage1 after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => GetStartedPage1()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF273236),
      body: Center(
        child: ClipOval(
          child: Container(
            color: Colors.white, // Background color of the circular shape
            width: 150, // Width of the circle
            height:
                150, // Height of the circle (same as width to keep it circular)
            child: SvgPicture.asset(
              'assets/icons/fsl.svg', // SVG file as the splash screen logo
              fit: BoxFit.contain, // Ensure the SVG fits within the circle
            ),
          ),
        ),
      ),
    );
  }
}

// Home Screen
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    FSLTranslatePage(),
    FSLGuidePage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _currentIndex == 0
          ? AppBar(
              backgroundColor: Color(0xFFFEFFFE),
              elevation: 0,
              title: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Jost'),
                    children: [
                      TextSpan(
                        text: 'Lingua',
                        style: TextStyle(color: Color(0xFF000000)),
                      ),
                      TextSpan(
                        text: 'AR',
                        style: TextStyle(color: Color(0xFF4A90E2)),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: IconButton(
                    icon: Icon(
                      Icons.menu,
                      color: Colors.black,
                      size: 35.0,
                    ),
                    onPressed: () {
                      // Handle menu button press (if needed)
                    },
                  ),
                ),
              ],
              automaticallyImplyLeading: false,
            )
          : null,
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Color(0xFF4A90E2),
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Lessons',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'FSL',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
