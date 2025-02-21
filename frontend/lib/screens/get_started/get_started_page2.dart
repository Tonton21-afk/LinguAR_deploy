import 'package:flutter/material.dart';
import 'package:lingua_arv1/screens/get_started/get_started_page3.dart';

class GetStartedPage2 extends StatefulWidget {
  @override
  _GetStartedPage2State createState() => _GetStartedPage2State();
}

class _GetStartedPage2State extends State<GetStartedPage2> {
  Set<int> selectedIndices = {};

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double textScale = MediaQuery.of(context).textScaleFactor;

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
                    fontSize: 24 * textScale,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                _buildOptionCard(
                  title: "I want to learn Filipino Sign Language",
                  index: 0,
                  color: Color(0xFF4A90E2),
                ),
                SizedBox(height: screenHeight * 0.015),
                _buildOptionCard(
                  title: "I need real-time translations",
                  index: 1,
                  color: Color(0xFF273236),
                ),
                SizedBox(height: screenHeight * 0.015),
                _buildOptionCard(
                  title: "I want to connect with others",
                  index: 2,
                  color: Color(0xFF4A90E2),
                ),
                SizedBox(height: screenHeight * 0.015),
                _buildOptionCard(
                  title: "Explore all features",
                  index: 3,
                  color: Color(0xFF273236),
                ),
                SizedBox(height: screenHeight * 0.05),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    onPressed: selectedIndices.isNotEmpty
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GetStartedPage3(),
                              ),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      backgroundColor: selectedIndices.isNotEmpty
                          ? Color(0xFF4A90E2)
                          : Colors.grey,
                      padding: EdgeInsets.all(screenWidth * 0.08),
                    ),
                    child: Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: screenWidth * 0.08,
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

  Widget _buildOptionCard({
    required String title,
    required int index,
    required Color color,
  }) {
    bool isSelected = selectedIndices.contains(index);
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
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
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        transform: isSelected
            ? (Matrix4.identity()
              ..scale(1.05)
              ..rotateZ(0.05))
            : Matrix4.identity(),
        width: double.infinity,
        height: screenHeight * 0.1,
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.8) : color,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: isSelected ? 12 : 6,
              spreadRadius: isSelected ? 5 : 2,
              offset: Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: isSelected ? color.withOpacity(0.9) : Colors.transparent,
            width: isSelected ? 6 : 0,
          ),
        ),
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: Duration(milliseconds: 300),
            style: TextStyle(
              fontSize: isSelected ? 16 * textScale : 14 * textScale,
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
