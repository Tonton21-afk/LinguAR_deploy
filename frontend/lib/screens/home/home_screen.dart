import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:lingua_arv1/home/home_page.dart';
import 'package:lingua_arv1/screens/fsl_guide/fsl_guide_page.dart';
import 'package:lingua_arv1/screens/fsl_translate/fsl_translate_page.dart';
import 'package:lingua_arv1/screens/settings/settings_page.dart';

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