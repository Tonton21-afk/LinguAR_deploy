import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingua_arv1/bloc/Change_password/change_password_bloc.dart';
import 'package:lingua_arv1/bloc/Otp/otp_bloc.dart';
import 'package:lingua_arv1/validators/password_validator.dart';
import 'package:lingua_arv1/validators/token.dart';

class UpdatePasswordModal extends StatefulWidget {
  @override
  _UpdatePasswordModalState createState() => _UpdatePasswordModalState();
}

class _UpdatePasswordModalState extends State<UpdatePasswordModal> {
  int currentStep = 0;
  String userEmail = "Loading...";

  final TextEditingController codeController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  String? newPasswordError;
  String? confirmPasswordError;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  Future<void> _loadUserEmail() async {
    String? fetchedEmail = await TokenService.getEmail();
    if (mounted) {
      setState(() {
        userEmail = fetchedEmail ?? "No Email Found";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
  }

  void nextStep() {
    setState(() {
      if (currentStep < 2) {
        currentStep++;
      } else {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double modalHeight = MediaQuery.of(context).size.height * 0.375;

    return BlocListener<OtpBloc, OtpState>(
      listener: (context, otpState) {
        if (otpState is OtpSentSuccess) {
          nextStep();
        } else if (otpState is OtpVerifiedSuccess) {
          nextStep();
        }
      },
      child: BlocListener<ChangePasswordBloc, ChangePasswordState>(
        listener: (context, changeState) {
          if (changeState is ChangePasswordSuccess) {
            Navigator.pop(context);
          }
        },
        child: MouseRegion(
          child: Container(
            width: double.infinity,
            height: modalHeight,
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Color(0xFF273236)
                  : Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  currentStep == 0
                      ? 'Update Password'
                      : currentStep == 1
                          ? 'Enter Verification Code'
                          : 'Enter New Password',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                if (currentStep == 0) ...[
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).brightness == Brightness.dark
                                  ? const Color.fromARGB(255, 29, 29, 29)
                                  : Color(0xFF4A90E2)),
                      onPressed: () {
                        context
                            .read<OtpBloc>()
                            .add(SendOtpEvent(email: userEmail));
                      },
                      child: Text('Send Code',
                          style: TextStyle(
                            color: Colors.white,
                          )),
                    ),
                  ),
                ],
                if (currentStep == 1) ...[
                  TextField(
                    controller: codeController,
                    decoration: InputDecoration(
                        labelText: 'Enter Code', border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).brightness == Brightness.dark
                                  ? const Color.fromARGB(255, 29, 29, 29)
                                  : Color(0xFF4A90E2)),
                      onPressed: () {
                        context.read<OtpBloc>().add(VerifyOtpEvent(
                            email: userEmail, otp: codeController.text));
                      },
                      child: Text(
                        'Verify Code',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
                if (currentStep == 2) ...[
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
                  SizedBox(height: 16),
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
                  SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).brightness == Brightness.dark
                                  ? const Color.fromARGB(255, 29, 29, 29)
                                  : Color(0xFF4A90E2)),
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
                                  email: userEmail,
                                  otp: codeController.text,
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
                      child: Text(
                        'Change Password',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
