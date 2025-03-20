import 'package:flutter/material.dart';
import 'package:lingua_arv1/screens/login_signup/login_page.dart';
import 'package:lingua_arv1/validators/token.dart';

void showPrivacyPolicy(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Privacy Policy'),
        content: const SingleChildScrollView(
            child: Text('''Effective Date: [November 31, 2025]

Thank you for using LinguaAR. Your privacy is important to us. This Privacy Policy explains how we collect, use, and protect your information when you use our application.

1. Information We Collect

LinguaAR requires user account creation, and we collect the following types of information:

- Personal Information: We collect personal information that you voluntarily provide when creating your account, such as your name, email address, and password.
- Usage Data: We may collect anonymized data related to app usage, such as feature engagement, error logs, and general statistics to improve our services.
- Device Information: We may collect information about the device you use, including device type, operating system, and language preferences to optimize your experience.
- Speech & Gesture Data: Any speech or gesture inputs processed by the app remain on your device and are not stored or shared.

2. How We Use Your Information

The data we collect is used solely to enhance your experience with LinguaAR. Specifically, we use it to:

- Improve app functionality and performance.
- Troubleshoot technical issues.
- Understand how users interact with our features.

3. Data Sharing and Security

- We do not sell, rent, or share your personal information with third parties.
- All data processing occurs within your device, ensuring privacy and security.
- If third-party services (such as text-to-speech engines or gesture recognition APIs) are used, they may have their own privacy policies, which we recommend reviewing.

4. Third-Party Services

LinguaAR may integrate third-party tools such as:

- Google Text-to-Speech for voice output.
- Gesture Recognition APIs for sign language processing.

These services may process data according to their respective privacy policies.

5. Your Rights & Choices

- You can disable certain features (e.g., speech recognition) in the app settings.
- You may contact us to request data deletion if applicable.

6. Changes to This Policy

We may update this Privacy Policy from time to time. Any changes will be reflected in the app and updated with a new effective date.

7. Contact Us

If you have any questions or concerns regarding this Privacy Policy, please contact us at:

dacl.ramos.up@phinmaed.com

By using LinguaAR, you agree to this Privacy Policy.
              ''')),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text('Close'))
        ],
      );
    },
  );
}

void showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Color(0xFFFEFFFE),
        title: Text('Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel', style: TextStyle(color: Colors.blue)),
          ),
          TextButton(
            onPressed: () async {
              // ✅ Clear token and user ID before logging out
              await TokenService.logout();
              print("✅ User successfully logged out");

              // ✅ Navigate to LoginPage and remove previous screens from history
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
                (Route<dynamic> route) =>
                    false, // This clears all previous screens
              );
            },
            child: Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      );
    },
  );
}
