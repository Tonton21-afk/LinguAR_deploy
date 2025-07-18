import 'package:flutter/material.dart';

class LoginForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onTogglePasswordVisibility;
  final String? emailError;
  final String? passwordError;
  final VoidCallback onLoginPressed;
  final VoidCallback onForgotPasswordPressed;
  final VoidCallback onSignUpPressed;

  const LoginForm({
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onTogglePasswordVisibility,
    this.emailError,
    this.passwordError,
    required this.onLoginPressed,
    required this.onForgotPasswordPressed,
    required this.onSignUpPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome Back!',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Color(0xFF273236),
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Please log in to your account',
          style: TextStyle(fontSize: 16, color: Color(0xFF4A90E2)),
        ),
        SizedBox(height: 32),
        TextField(
          controller: emailController,
          decoration: InputDecoration(
            labelText: 'Username or Email',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          ),
        ),
        if (emailError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(emailError!, style: TextStyle(color: Colors.red, fontSize: 12)),
          ),
        SizedBox(height: 20),
        TextField(
          controller: passwordController,
          obscureText: obscurePassword,
          decoration: InputDecoration(
            labelText: 'Password',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            suffixIcon: IconButton(
              icon:
                  Icon(obscurePassword ? Icons.visibility_off : Icons.visibility),
              onPressed: onTogglePasswordVisibility,
            ),
          ),
        ),
        if (passwordError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(passwordError!, style: TextStyle(color: Colors.red, fontSize: 12)),
          ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: onForgotPasswordPressed,
            child: Text('Forgot password?', style: TextStyle(color: Color(0xFF4A90E2))),
          ),
        ),
        SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onLoginPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark ? Colors.white : Color(0xFF191E20),
              padding: EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              'Login',
              style: TextStyle(
                fontSize: 16,
                color: isDark ? Color(0xFF273236) : Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(height: 24),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don’t have an account? ",
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.white : Color(0xFF273236),
                ),
              ),
              TextButton(
                onPressed: onSignUpPressed,
                child: Text(
                  'Sign up',
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
    );
  }
}
