import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingua_arv1/bloc/Change_email/change_email_bloc.dart';
import 'package:lingua_arv1/bloc/Otp/otp_bloc.dart';


import 'package:lingua_arv1/validators/token.dart';
import 'package:provider/provider.dart';



class UpdateEmailModal extends StatefulWidget {
  @override
  _UpdateEmailModalState createState() => _UpdateEmailModalState();
}

class _UpdateEmailModalState extends State<UpdateEmailModal> {
  int currentStep = 0;
  String userEmail = "Loading...";
  final TextEditingController codeController = TextEditingController();
  final TextEditingController newEmailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
  }

  Future<void> _loadUserEmail() async {
    String? fetchedEmail = await TokenService.getEmail();
    if (mounted) {
      setState(() {
        userEmail = fetchedEmail ?? "No Email Found";
      });
    }
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
      child: BlocListener<ResetEmailBloc, ResetEmailState>(
        listener: (context, resetState) {
          if (resetState is ResetEmailSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(resetState.message)),
            );
            Navigator.pop(context);
          }
        },
        child: MouseRegion(
          // ✅ Fixes mouse tracker issue
          child: Container(
            width: double.infinity,
            height: modalHeight,
            decoration: BoxDecoration(
              color: Colors.white,
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
                      ? 'Update Email'
                      : currentStep == 1
                          ? 'Enter Verification Code'
                          : 'Enter New Email',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                if (currentStep == 0) ...[
                  Text("Current Email:",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text(userEmail,
                      style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                  SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<OtpBloc>().add(SendOtpEvent(email:userEmail));
                      },
                      child: Text('Send Code'),
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
                      onPressed: () {
                        context.read<OtpBloc>().add(
                            VerifyOtpEvent(email:userEmail, otp:codeController.text));
                      },
                      child: Text('Verify Code'),
                    ),
                  ),
                ],
                if (currentStep == 2) ...[
                  TextField(
                    controller: newEmailController,
                    decoration: InputDecoration(
                        labelText: 'New Email', border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<ResetEmailBloc>().add(
                              SubmitResetEmail(
                                email: userEmail,
                                otp: codeController.text,
                                newEmail: newEmailController.text,
                              ),
                            );
                      },
                      child: Text('Change Email'),
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
