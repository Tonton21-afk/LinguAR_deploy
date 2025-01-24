import 'package:flutter/material.dart';
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
      home: SplashScreen(),
    );
  }
}

// Splash Screen
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to HomeScreen after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF27314A), // Background color: #27314A
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Main logo text
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 24, // Reduced font size
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: 'Lingua',
                    style: TextStyle(
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                  TextSpan(
                    text: 'AR',
                    style: TextStyle(
                      color: Color(0xFFFFA786),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
                children: [
                  TextSpan(
                    text: 'Bridging Communities',
                    style: TextStyle(
                      color: Color(0xFFFFA786),
                    ),
                  ),
                  TextSpan(
                    text: ', Empowering Communication',
                    style: TextStyle(
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
              title: Text(
                'LinguaAR',
                style: TextStyle(color: Colors.black, fontSize: 25),
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.menu,
                    color: Colors.black,
                    size: 35.0,
                  ),
                  onPressed: () {
                    // Handle menu button press
                  },
                ),
              ],
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
        selectedItemColor: Color(0xFFFFA786), // Color for selected item
        unselectedItemColor: Colors.grey, // Color for unselected items
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.translate),
            label: 'FSL Translate',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'FSL Guide',
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
