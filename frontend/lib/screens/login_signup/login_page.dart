import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingua_arv1/bloc/Login/login_bloc.dart';
import 'package:lingua_arv1/bloc/Login/login_event.dart';
import 'package:lingua_arv1/bloc/Login/login_state.dart';
import 'package:lingua_arv1/screens/forgot_password/forgot_password_sheet.dart';
import 'package:lingua_arv1/repositories/login_repositories/login_repository_impl.dart';
import 'package:lingua_arv1/screens/get_started/get_started_page2.dart';
import 'package:lingua_arv1/screens/login_signup/signup_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;
  String? emailError;
  String? passwordError;

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black54, // Semi-transparent background
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0), // Rounded corners
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Fit content
              children: [
                Icon(
                  Icons.check_circle,
                  color: Color(0xFF4A90E2), // Success color
                  size: 60,
                ),
                SizedBox(height: 16),
                Text(
                  'Successful Login',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'You have successfully logged in.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );

    // Close the dialog after 2 seconds and navigate to the next screen
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pop(context); // Close the dialog
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => GetStartedPage2()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(LoginRepositoryImpl()),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: BlocConsumer<LoginBloc, LoginState>(
                    listener: (context, state) {
                      if (state is LoginLoading) {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) =>
                              Center(child: CircularProgressIndicator()),
                        );
                      } else if (state is LoginSuccess) {
                        Navigator.pop(context); // Close the loading dialog
                        _showSuccessDialog(context); // Show success dialog
                      } else if (state is LoginFailure) {
                        Navigator.pop(context); // Close the loading dialog
                        setState(() {
                          emailError = state.errorMessage.contains('email')
                              ? 'Invalid email or password'
                              : null;
                          passwordError =
                              state.errorMessage.contains('password')
                                  ? 'Invalid email or password'
                                  : null;
                        });
                      }
                    },
                    builder: (context, state) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome Back!',
                              style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF273236)),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Please log in to your account',
                              style: TextStyle(
                                  fontSize: 16, color: Color(0xFF4A90E2)),
                            ),
                            SizedBox(height: 32),
                            TextField(
                              controller: emailController,
                              decoration: InputDecoration(
                                labelText: 'Username or Email',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 16),
                              ),
                            ),
                            if (emailError != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  emailError!,
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 12),
                                ),
                              ),
                            SizedBox(height: 20),
                            TextField(
                              controller: passwordController,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 16),
                                suffixIcon: IconButton(
                                  icon: Icon(_obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),
                            ),
                            if (passwordError != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  passwordError!,
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 12),
                                ),
                              ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20)),
                                    ),
                                    builder: (context) => ForgotPasswordSheet(),
                                  );
                                },
                                child: Text('Forgot password?',
                                    style: TextStyle(color: Color(0xFF4A90E2))),
                              ),
                            ),
                            SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  final email = emailController.text.trim();
                                  final password =
                                      passwordController.text.trim();
                                  if (email.isEmpty || password.isEmpty) {
                                    setState(() {
                                      emailError = email.isEmpty
                                          ? 'Email is required'
                                          : null;
                                      passwordError = password.isEmpty
                                          ? 'Password is required'
                                          : null;
                                    });
                                    return;
                                  }
                                  BlocProvider.of<LoginBloc>(context).add(
                                    LoginButtonPressed(
                                        email: email, password: password),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF191E20),
                                  padding: EdgeInsets.symmetric(vertical: 18),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                                child: Text('Login',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white)),
                              ),
                            ),
                            SizedBox(height: 24),
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Don’t have an account? ",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Color(0xFF273236))),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => SignUpPage()),
                                      );
                                    },
                                    child: Text('Sign up',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Color(0xFF4A90E2),
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
