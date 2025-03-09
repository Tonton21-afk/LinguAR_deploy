import 'package:flutter/material.dart';
import 'package:lingua_arv1/screens/get_started/get_started_page3.dart';

class GetStartedPage2 extends StatefulWidget {
  @override
  _GetStartedPage2State createState() => _GetStartedPage2State();
}

class _GetStartedPage2State extends State<GetStartedPage2> {
  Set<int> selectedIndices = {};
  bool _buttonPressed = false; // State variable for button animation

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double textScale = MediaQuery.of(context).textScaleFactor;

    // Responsive font size and padding
    double baseFontSize = screenWidth > 600 ? 28 : 24;
    double cardHeight =
        screenWidth > 600 ? screenHeight * 0.08 : screenHeight * 0.1;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Goal Selection',
                  style: TextStyle(
                    fontSize: baseFontSize * textScale,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white // Dark mode color
                        : Color(0xFF273236),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                _buildOptionCard("I want to learn Filipino Sign Language", 0,
                    Color(0xFF4A90E2), cardHeight),
                SizedBox(height: screenHeight * 0.015),
                _buildOptionCard("I need real-time translations", 1,
                    Color(0xFF273236), cardHeight),
                SizedBox(height: screenHeight * 0.015),
                _buildOptionCard("I want to connect with others", 2,
                    Color(0xFF4A90E2), cardHeight),
                SizedBox(height: screenHeight * 0.015),
                _buildOptionCard(
                    "Explore all features", 3, Color(0xFF273236), cardHeight),
                SizedBox(height: screenHeight * 0.05),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    onTapDown: (_) {
                      if (selectedIndices.isNotEmpty) {
                        setState(() {
                          _buttonPressed = true;
                        });
                      }
                    },
                    onTapUp: (_) {
                      if (selectedIndices.isNotEmpty) {
                        setState(() {
                          _buttonPressed = false;
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GetStartedPage3()),
                        );
                      }
                    },
                    onTapCancel: () {
                      if (selectedIndices.isNotEmpty) {
                        setState(() {
                          _buttonPressed = false;
                        });
                      }
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 100),
                      transform: Matrix4.identity()
                        ..scale(_buttonPressed ? 0.95 : 1.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withOpacity(_buttonPressed ? 0.4 : 0.2),
                            blurRadius: _buttonPressed ? 10 : 6,
                            spreadRadius: _buttonPressed ? 2 : 1,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: selectedIndices.isNotEmpty
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => GetStartedPage3()),
                                );
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          backgroundColor: selectedIndices.isNotEmpty
                              ? Color(0xFF4A90E2)
                              : Colors.grey,
                          padding: EdgeInsets.all(screenWidth > 600
                              ? screenWidth * 0.05
                              : screenWidth * 0.08),
                        ),
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: screenWidth > 600
                              ? screenWidth * 0.05
                              : screenWidth * 0.08,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard(String title, int index, Color color, double height) {
    bool isSelected = selectedIndices.contains(index);
    final double screenWidth = MediaQuery.of(context).size.width;
    final double textScale = MediaQuery.of(context).textScaleFactor;

    return GestureDetector(
      onTap: () {
        setState(() {
          isSelected
              ? selectedIndices.remove(index)
              : selectedIndices.add(index);
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        transform: Matrix4.identity()..scale(isSelected ? 1.02 : 1.0),
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.8) : color,
          borderRadius: BorderRadius.circular(screenWidth > 600 ? 16.0 : 12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isSelected ? 0.3 : 0.2),
              blurRadius: isSelected ? 10 : 6,
              spreadRadius: isSelected ? 3 : 2,
              offset: Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: isSelected ? color.withOpacity(0.9) : Colors.transparent,
            width: isSelected ? (screenWidth > 600 ? 4 : 3) : 0,
          ),
        ),
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: Duration(milliseconds: 200),
            style: TextStyle(
              fontSize: isSelected
                  ? (screenWidth > 600 ? 18 : 16) * textScale
                  : (screenWidth > 600 ? 16 : 14) * textScale,
              color: Colors.white,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            ),
            child: Text(
              title,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
