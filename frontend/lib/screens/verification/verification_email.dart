import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingua_arv1/bloc/Otp/otp_bloc.dart';
import 'package:lingua_arv1/repositories/otp_repositories/otp_repository_impl.dart';
import 'package:lingua_arv1/screens/authentication/login/login_page.dart';

class EmailVerificationModal extends StatefulWidget {
  final String email;
  final VoidCallback onVerified;

  const EmailVerificationModal({
    Key? key,
    required this.email,
    required this.onVerified,
  }) : super(key: key);

  @override
  _EmailVerificationModalState createState() => _EmailVerificationModalState();
}

class _EmailVerificationModalState extends State<EmailVerificationModal> {
  late String email;
  final TextEditingController otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    email = widget.email;
    // ✅ Access OtpBloc from the parent context
    context.read<OtpBloc>().add(SendOtpEvent(email: email));
  }

  void _showChangeEmailDialog() {
    TextEditingController newEmailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider(
          create: (context) =>
              OtpBloc(OtpRepositoryImpl()), // ✅ Provide new OtpBloc instance
          child: Builder(
            builder: (context) {
              return AlertDialog(
                title: Text('Change Email'),
                content: TextField(
                  controller: newEmailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'New Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final newEmail = newEmailController.text.trim();
                      if (newEmail.isNotEmpty && newEmail.contains('@')) {
                        setState(() {
                          email = newEmail;
                        });
                        context
                            .read<OtpBloc>()
                            .add(SendOtpEvent(email: email)); // ✅ Resend OTP
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text('Email updated. OTP sent to $newEmail')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Enter a valid email address')),
                        );
                      }
                    },
                    child: Text('Confirm'),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          OtpBloc(OtpRepositoryImpl()), // ✅ Provide OtpBloc for the modal
      child: BlocConsumer<OtpBloc, OtpState>(
        listener: (context, state) {
          if (state is OtpSentSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('OTP sent successfully! Check your email.')),
            );
          } else if (state is OtpSentFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to send OTP. Try again.')),
            );
          } else if (state is OtpVerifiedSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Email verified successfully!')),
            );
            widget.onVerified();
            Navigator.pop(context);
          } else if (state is OtpVerifiedFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Invalid OTP. Please try again.')),
            );
          }
        },
        builder: (context, state) {
          return AlertDialog(
            title: Text('Verify Your Email'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Enter the OTP sent to $email'),
                SizedBox(height: 10),
                TextField(
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'OTP',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    final otp = otpController.text.trim();
                    if (otp.isNotEmpty) {
                      context
                          .read<OtpBloc>()
                          .add(VerifyOtpEvent(email: email, otp: otp));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please enter the OTP.')),
                      );
                    }
                  },
                  child: state is OtpLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Verify'),
                ),
                TextButton(
                  onPressed: _showChangeEmailDialog,
                  child: Text('Change Email'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
