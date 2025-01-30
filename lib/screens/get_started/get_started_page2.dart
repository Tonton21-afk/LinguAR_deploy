import 'package:flutter/material.dart';
import 'package:lingua_arv1/screens/get_started/get_started_page3.dart';

class GetStartedPage2 extends StatefulWidget {
  @override
  _GetStartedPage2State createState() => _GetStartedPage2State();
}

class _GetStartedPage2State extends State<GetStartedPage2> {
  // Track selected indices
  Set<int> selectedIndices = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Goal Selection title
                Text(
                  'Goal Selection',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),

                // Options list
                _buildOptionCard(
                  title: "I want to learn Filipino Sign Language",
                  index: 0,
                  color: Color(0xFF4A90E2),
                ),
                SizedBox(height: 12),
                _buildOptionCard(
                  title: "I need real-time translations",
                  index: 1,
                  color: Color(0xFF273236),
                ),
                SizedBox(height: 12),
                _buildOptionCard(
                  title: "I want to connect with others",
                  index: 2,
                  color: Color(0xFF4A90E2),
                ),
                SizedBox(height: 12),
                _buildOptionCard(
                  title: "Explore all features",
                  index: 3,
                  color: Color(0xFF273236),
                ),
                SizedBox(height: 30),

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
                          ? Color(0xFF4A90E2) // Active color
                          : Colors.grey, // Disabled color
                      padding: EdgeInsets.all(20),
                    ),
                    child: Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 30,
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

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedIndices.remove(index); // Deselect if already selected
          } else {
            selectedIndices.add(index); // Select if not already selected
          }
        });
        print('$title clicked');
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: isSelected ? double.infinity * 1.02 : double.infinity,
        height: isSelected ? 90 : 80,
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
              fontSize: isSelected ? 16 : 14,
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
