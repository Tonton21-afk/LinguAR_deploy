import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingua_arv1/bloc/Otp/otp_bloc.dart';
import 'package:lingua_arv1/repositories/otp_repositories/otp_repository_impl.dart';
import 'package:lingua_arv1/screens/forgot_password/change_password.dart';

class OtpVerificationModal extends StatefulWidget {
  final String email;

  OtpVerificationModal({required this.email});

  @override
  State<OtpVerificationModal> createState() => _OtpVerificationModalState();
}

class _OtpVerificationModalState extends State<OtpVerificationModal> {
  final TextEditingController otpController = TextEditingController();

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
                  Text(
                    'Verify OTP',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Enter the OTP sent to ${widget.email}',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: otpController,
                    decoration: InputDecoration(
                      labelText: 'OTP',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final otp = otpController.text.trim();
                        if (otp.isNotEmpty) {
                          // Trigger OTP verification event
                          context.read<OtpBloc>().add(
                                VerifyOtpEvent(email: widget.email, otp: otp),
                              );
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) => ChangePasswordModal(
                                email: widget.email, otp: otp),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Please enter the OTP')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF191E20),
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text('Verify OTP',
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            );
          },
        )));
  }
}
