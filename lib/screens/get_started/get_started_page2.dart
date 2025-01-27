import 'package:flutter/material.dart';
import 'package:lingua_arv1/screens/get_started/get_started_page3.dart'; // Assuming this is the next page

class GetStartedPage2 extends StatelessWidget {
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

                // Option 1: "I want to learn Filipino Sign Language"
                GestureDetector(
                  onTap: () {
                    print("I want to learn Filipino Sign Language clicked");
                  },
                  child: SizedBox(
                    width: double.infinity,
                    height: 80,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      color: Color(0xFF4A90E2),
                      child: Center(
                        child: Text(
                          "I want to learn Filipino Sign Language",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 12),

                // Option 2: "I need real-time translations"
                GestureDetector(
                  onTap: () {
                    print("I need real-time translations clicked");
                  },
                  child: SizedBox(
                    width: double.infinity,
                    height: 80,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      color: Color(0xFF273236),
                      child: Center(
                        child: Text(
                          "I need real-time translations",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 12),

                // Option 3: "I want to connect with others"
                GestureDetector(
                  onTap: () {
                    print("I want to connect with others clicked");
                  },
                  child: SizedBox(
                    width: double.infinity,
                    height: 80,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      color: Color(0xFF4A90E2),
                      child: Center(
                        child: Text(
                          "I want to connect with others",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 12),

                // Option 4: "Explore all features"
                GestureDetector(
                  onTap: () {
                    print("Explore all features clicked");
                  },
                  child: SizedBox(
                    width: double.infinity,
                    height: 80,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      color: Color(0xFF273236),
                      child: Center(
                        child: Text(
                          "Explore all features",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 30),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GetStartedPage3(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      backgroundColor: Color(0xFF4A90E2),
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
}
