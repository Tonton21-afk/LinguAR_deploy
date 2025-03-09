import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingua_arv1/bloc/Otp/otp_bloc.dart';
import 'package:lingua_arv1/repositories/otp_repositories/otp_repository_impl.dart';
import 'package:lingua_arv1/screens/forgot_password/verification.dart';

class ForgotPasswordSheet extends StatefulWidget {
  @override
  State<ForgotPasswordSheet> createState() => _ForgotPasswordSheetState();
}

class _ForgotPasswordSheetState extends State<ForgotPasswordSheet> {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => OtpBloc(OtpRepositoryImpl()),
        child: Scaffold(
            body: BlocConsumer<OtpBloc, OtpState>(
          listener: (context, state) {
            if (state is OtpSentSuccess) {
              // Show success message when OTP is sent
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('OTP sent successfully!')),
              );
            } else if (state is OtpSentFailure) {
              // Show error message if OTP sending fails
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Failed to send OTP. Please try again.')),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Reset Password',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Enter your email to receive password reset instructions.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    ),
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () {
                        final email = emailController.text.trim();
                        if (email.isNotEmpty) {
                          // Trigger send OTP event
                          context
                              .read<OtpBloc>()
                              .add(SendOtpEvent(email: email));
                          // Open OTP verification modal
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) =>
                                OtpVerificationModal(email: email),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Please enter a valid email')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).brightness == Brightness.dark
                                ? Colors.white // White button in dark mode
                                : Color(0xFF191E20),
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text('Send',
                          style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Color(0xFF273236))),
                    ),
                  ),
                ],
              ),
            );
          },
        )));
  }
}
