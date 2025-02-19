import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingua_arv1/bloc/Change_password/change_password_bloc.dart';
import 'package:lingua_arv1/repositories/change_password_repositories/reset_password_repository_impl.dart';
import 'package:lingua_arv1/screens/login_signup/login_page.dart';
import 'package:lingua_arv1/validators/password_validator.dart'; // Import the utility class

class ChangePasswordModal extends StatefulWidget {
  final String email;
  final String otp;

  ChangePasswordModal({required this.email, required this.otp});

  @override
  State<ChangePasswordModal> createState() => _ChangePasswordModalState();
}

class _ChangePasswordModalState extends State<ChangePasswordModal> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  String? newPasswordError;
  String? confirmPasswordError;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChangePasswordBloc(PasswordRepositoryImpl()),
      child: Scaffold(
        body: BlocConsumer<ChangePasswordBloc, ChangePasswordState>(
          listener: (context, state) {
            if (state is ChangePasswordSuccess) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Password changed successfully!')),
              );
            } else if (state is ChangePasswordFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content:
                        Text('Failed to change password. Please try again.')),
              );
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Change Password',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Enter your new password',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: newPasswordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
                      errorText:
                          newPasswordError, // Display error under the text field
                    ),
                
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
                      errorText:
                          confirmPasswordError, // Display error under the text field
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final newPassword = newPasswordController.text.trim();
                        final confirmPassword =
                            confirmPasswordController.text.trim();

                        // Reset errors
                        setState(() {
                          newPasswordError = null;
                          confirmPasswordError = null;
                        });
                        // If no errors, proceed with password change
                        if (newPasswordError == null &&
                            confirmPasswordError == null) {
                          context.read<ChangePasswordBloc>().add(
                                ResetPasswordEvent(
                                  email: widget.email,
                                  otp: widget.otp,
                                  newPassword: newPassword,
                                ),
                              );
                        }
                        // Validate new password
                        if (newPassword.isEmpty) {
                          setState(() {
                            newPasswordError = 'Please enter a new password.';
                          });
                        } else if (!PasswordValidator.isPasswordValid(
                            newPassword)) {
                          setState(() {
                            newPasswordError =
                                'Password must contain at least 1 uppercase letter,\n1 number, 1 special character, and be 8-12 characters long.';
                          });
                        }

                        // Validate confirm password
                        if (confirmPassword.isEmpty) {
                          setState(() {
                            confirmPasswordError =
                                'Please confirm your password.';
                          });
                        } else if (newPassword != confirmPassword) {
                          setState(() {
                            confirmPasswordError = 'Passwords do not match.';
                          });
                        }
                      }, // Call validation function

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF191E20),
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text('Change Password',
                          style: TextStyle(fontSize: 16, color: Colors.white)),
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
