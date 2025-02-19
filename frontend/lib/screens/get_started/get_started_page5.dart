import 'package:flutter/material.dart';
import 'package:lingua_arv1/main.dart';

class GetStartedPage5 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/illustrations/all_set.png',
                  width: screenWidth * 0.6,
                  height: screenHeight * 0.3,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: screenHeight * 0.03),
                Text(
                  'You Are All Set!',
                  style: TextStyle(
                    fontSize: screenWidth * 0.07,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Text(
                  'Thank you for setting up LinguaAR.\nYou can now explore its features.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      backgroundColor: Color(0xFF4A90E2),
                      padding: EdgeInsets.all(screenWidth * 0.07),
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
}
