import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:lingua_arv1/home/home_page.dart';
import 'package:lingua_arv1/screens/fsl_guide/fsl_guide_page.dart';
import 'package:lingua_arv1/screens/gesture/gesture_translator.dart';
import 'package:lingua_arv1/screens/settings/settings_page.dart';
import 'package:lingua_arv1/screens/home/favoritesPage.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    GestureTranslator(),
    FSLGuidePage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final appBarBg = isDark ? const Color(0xFF1D1D1D) : Colors.white;
    final iconColor = isDark ? Colors.white : Colors.black;
    final dividerColor =
        isDark ? Colors.white.withOpacity(.08) : Colors.black.withOpacity(.06);

    return Scaffold(
      appBar: _currentIndex == 0
          ? AppBar(
              backgroundColor: appBarBg,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              centerTitle: false,
              automaticallyImplyLeading: false,
              toolbarHeight: 64,
              titleSpacing: 0,
              leadingWidth: 68, 
              leading: Padding(
                padding: const EdgeInsets.only(left: 14),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 40, 
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark
                          ? const Color(0xFF2A2A2A)
                          : const Color(0xFFF1F5FF), 
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withOpacity(.14)
                            : Colors.black.withOpacity(.06),
                        width: 1,
                      ),
                    ),
                   
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: Image.asset(
                        'assets/icons/fsl.png', 
                        fit: BoxFit.contain,
                        filterQuality: FilterQuality.medium,
                      ),
                    ),
                  ),
                ),
              ),
              title: const SizedBox.shrink(),
              actions: [
                IconButton(
                  tooltip: 'Favorites',
                  icon: Icon(Icons.star_border_rounded, color: iconColor),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const FavoritesPage()),
                    );
                  },
                ),
                const SizedBox(width: 6),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1),
                child: Container(height: 1, color: dividerColor),
              ),
            )
          : null,

      body: _pages[_currentIndex],

      // Rounded & slightly elevated bottom bar (looks softer, same items/logic)
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF9F6F9),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? .25 : .06),
              blurRadius: 14,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            selectedItemColor: const Color(0xFF4A90E2),
            unselectedItemColor: isDark ? Colors.white70 : Colors.grey,
            selectedLabelStyle:
                theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w700),
            unselectedLabelStyle: theme.textTheme.labelSmall,
            showUnselectedLabels: true,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(AntDesign.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(MaterialCommunityIcons.translate),
                label: 'Translate',
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
        ),
      ),
    );
  }
}
