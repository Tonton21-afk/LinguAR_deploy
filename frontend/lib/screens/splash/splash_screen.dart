import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:lingua_arv1/validators/token.dart';
import 'package:lingua_arv1/screens/home/home_screen.dart';
import 'package:lingua_arv1/screens/get_started/get_started_page1.dart';

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
