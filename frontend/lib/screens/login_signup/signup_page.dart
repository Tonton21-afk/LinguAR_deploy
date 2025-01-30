import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingua_arv1/bloc/Register/register_bloc.dart';
import 'package:lingua_arv1/repositories/register_repositories/register_repository_impl.dart';
import 'login_page.dart';

class SignUpPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocProvider(
        create: (context) => RegisterBloc(RegisterRepositoryImpl()),
        child: BlocConsumer<RegisterBloc, RegisterState>(
          listener: (context, state) {
            if (state is RegisterSuccess) {
              print("Registration successful: ${state.authentication.email}");
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Registration Successful! Please log in.')),
              );
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
                (route) => false, // Prevents going back to SignUpPage
              );
            } else if (state is RegisterFailure) {
              print("Registration failed: ${state.errorMessage}");
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage)),
              );
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create an Account',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF273236),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Please fill in the details below',
                    style: TextStyle(fontSize: 16, color: Color(0xFF4A90E2)),
                  ),
                  SizedBox(height: 32),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    ),
                  ),
                  SizedBox(height: 30),

                  // Register Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final email = emailController.text.trim();
                        final password = passwordController.text.trim();
                        final confirmPassword = confirmPasswordController.text.trim();

                        if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('All fields are required')),
                          );
                          return;
                        }

                        if (password != confirmPassword) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Passwords do not match')),
                          );
                          return;
                        }

                        print("🔄 Attempting to register with email: $email");

                        // Dispatch Bloc Event
                        context.read<RegisterBloc>().add(
                          RegisterButtonPressed(email: email, password: password),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF191E20),
                        padding: EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: state is RegisterLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text('Sign Up', style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ),
                  SizedBox(height: 24),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account? ",
                            style: TextStyle(fontSize: 16, color: Color(0xFF273236))),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => LoginPage()),
                            );
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF4A90E2),
                                fontWeight: FontWeight.bold),
                          ),
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
    );
  }
}