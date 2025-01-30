import 'package:flutter/material.dart';
import 'package:lingua_arv1/screens/login_signup/login_page.dart'; // Import the login page

class GetStartedPage1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.white,
              child: Center(
                child: Image.asset(
                  'assets/illustrations/welcome.png',
                  width: 300,
                  height: 300,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              color: Color(0xFF273236),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Text "Welcome to LinguaAR"
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      children: [
                        TextSpan(text: "Welcome to "),
                        TextSpan(
                          text: "Lingua",
                          style: TextStyle(color: Colors.white),
                        ),
                        TextSpan(
                          text: "AR",
                          style: TextStyle(color: Color(0xFF4A90E2)),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),

                  // Text "Bridging Communities, Empowering Communication"
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                      children: [
                        TextSpan(
                          text: "Bridging Communities",
                          style: TextStyle(
                            color: Color(0xFF4A90E2),
                          ),
                        ),
                        TextSpan(
                          text: ", Empowering Communication",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () {
                      // Navigate to the login page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              LoginPage(), // Use the LoginPage
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
