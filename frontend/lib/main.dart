import 'package:flutter/material.dart';
import 'package:lingua_arv1/settings/theme/theme_provider.dart';
import 'package:lingua_arv1/validators/token.dart';
import 'package:lottie/lottie.dart';
import 'package:lingua_arv1/screens/get_started/get_started_page1.dart';
import 'package:provider/provider.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart'; // Import for cooler icons
import 'home/home_page.dart';
import 'fsl_translate/fsl_translate_page.dart';
import 'fsl_guide/fsl_guide_page.dart';
import 'settings/settings_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => ThemeProvider()), // ✅ Provides ThemeProvider
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(fontFamily: 'Jost', brightness: Brightness.light),
          darkTheme: ThemeData(fontFamily: 'Jost', brightness: Brightness.dark),
          themeMode: themeProvider.themeMode,
          home: SplashScreen(), // Always start with SplashScreen
        );
      },
    );
  }
}

class AppWrapper extends StatelessWidget {
  final bool isLoggedIn;

  const AppWrapper({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(fontFamily: 'Jost', brightness: Brightness.light),
          darkTheme: ThemeData(fontFamily: 'Jost', brightness: Brightness.dark),
          themeMode: themeProvider.themeMode, // ✅ Dynamic theme switching
          home: isLoggedIn ? HomeScreen() : GetStartedPage1(),
        );
      },
    );
  }
}

// Splash Screen with Circular Lottie Animation
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 3));
    _controller.forward();

    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(Duration(seconds: 3));

    bool isLoggedIn = await TokenService.isUserLoggedIn();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => isLoggedIn ? HomeScreen() : GetStartedPage1(),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF273236),
      body: Center(
        child: ClipOval(
          child: Container(
            color: Colors.white,
            width: 200,
            height: 200,
            child: Lottie.asset(
              'assets/animations/fslBlue.json',
              fit: BoxFit.cover,
              repeat: true,
              animate: true,
              controller: _controller,
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
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? const Color.fromARGB(255, 29, 29, 29) // ✅ Darker gray
                  : Colors.white,
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
                          style: TextStyle(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white // Dark mode color
                                  : Colors.black)),
                      TextSpan(
                          text: 'AR',
                          style: TextStyle(color: Color(0xFF4A90E2))),
                    ],
                  ),
                ),
              ),
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
            icon: Icon(AntDesign.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Feather.book),
            label: 'Lessons',
          ),
          BottomNavigationBarItem(
            icon: Icon(MaterialCommunityIcons.book_open),
            label: 'Guide',
          ),
          BottomNavigationBarItem(
            icon: Icon(Feather.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
