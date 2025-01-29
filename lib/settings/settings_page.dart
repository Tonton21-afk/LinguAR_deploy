import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Map<String, String> settings = {
    'Theme': 'Auto',
    'Language': 'Change',
    'Preferred Hand': 'Right',
    'Translation Speed': 'Normal',
    'Voice Selection': 'Male',
    'Speech Speed': 'Normal',
    'Pitch Control': 'Normal',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text('Settings', style: TextStyle(color: Colors.black))),
        backgroundColor: Color(0xFFFEFFFE),
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: Container(
        color: Color(0xFFFEFFFE),
        child: ListView(
          children: [
            _buildSectionHeader('GENERAL'),
            _buildListTile(
              context,
              'Theme',
              settings['Theme']!,
              Icons.brightness_6,
              ['Auto', 'Light', 'Dark'],
            ),
            _buildListTile(
              context,
              'Language',
              settings['Language']!,
              Icons.language,
              ['English', 'Spanish', 'French', 'Filipino'],
            ),
            _buildSectionHeader('AR and FSL'),
            _buildListTile(
              context,
              'Preferred Hand',
              settings['Preferred Hand']!,
              Icons.pan_tool,
              ['Right', 'Left'],
            ),
            _buildListTile(
              context,
              'Translation Speed',
              settings['Translation Speed']!,
              Icons.speed,
              ['Slow', 'Normal', 'Fast'],
            ),
            _buildSectionHeader('Text to Speech'),
            _buildListTile(
              context,
              'Voice Selection',
              settings['Voice Selection']!,
              Icons.record_voice_over,
              ['Male', 'Female'],
            ),
            _buildListTile(
              context,
              'Speech Speed',
              settings['Speech Speed']!,
              Icons.slow_motion_video,
              ['Slow', 'Normal', 'Fast'],
            ),
            _buildListTile(
              context,
              'Pitch Control',
              settings['Pitch Control']!,
              Icons.tune,
              ['Low', 'Normal', 'High'],
            ),
            _buildSectionHeader('About and Support'),
            _buildListTile(context, 'App Version', '', Icons.info, []),
            _buildListTile(
                context, 'Privacy Policy', '', Icons.privacy_tip, []),
            _buildListTile(
                context, 'Feedback and Support', '', Icons.support, []),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildListTile(BuildContext context, String title, String trailing,
      IconData icon, List<String> options) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.grey),
          title: Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          trailing: trailing.isNotEmpty
              ? Text(
                  trailing,
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                )
              : null,
          onTap: title == 'Privacy Policy'
              ? () => _showPrivacyPolicy(context)
              : options.isNotEmpty
                  ? () => _showOptionsDialog(context, title, options)
                  : null,
        ),
        Divider(
            height: 1,
            thickness: 0.5,
            indent: 16,
            endIndent: 16,
            color: Colors.grey[300]),
      ],
    );
  }

  void _showOptionsDialog(
      BuildContext context, String title, List<String> options) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFFFEFFFE),
          title: Text('Select $title'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: options.map((option) {
              return ListTile(
                title: Text(option),
                onTap: () {
                  setState(() {
                    settings[title] = option;
                  });
                  Navigator.of(context).pop();
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFFFEFFFE),
          title: Text('Privacy Policy for LinguaAR'),
          content: SingleChildScrollView(
            child: Text(
              'Effective Date: [Insert Date]\n\nThank you for using LinguaAR. Your privacy is important to us. This Privacy Policy explains how we collect, use, and protect your information when you use our application.\n\n1. Information We Collect\n\nLinguaAR does not require user account creation, but we may collect the following types of information:\n\nPersonal Information: None, unless voluntarily provided through feedback or support requests.\n\nUsage Data: We may collect anonymized data related to app usage, such as feature engagement and error logs, to improve our services.\n\nDevice Information: We may collect device type, operating system, and language preferences for optimizing user experience.\n\nSpeech & Gesture Data: Any speech or gesture inputs processed by the app remain on your device and are not stored or shared.\n\n2. How We Use Your Information\n\nThe data we collect is used solely to enhance your experience with LinguaAR. Specifically, we use it to:\n\nImprove app functionality and performance.\n\nTroubleshoot technical issues.\n\nUnderstand how users interact with our features.\n\n3. Data Sharing and Security\n\nWe do not sell, rent, or share your personal information with third parties.\n\nAll data processing occurs within your device, ensuring privacy and security.\n\nIf third-party services (such as text-to-speech engines) are used, they may have their own privacy policies, which we recommend reviewing.\n\n4. Third-Party Services\n\nLinguaAR may integrate third-party tools such as:\n\nGoogle Text-to-Speech for voice output.\n\nGesture Recognition APIs for sign language processing.\n\nThese services may process data according to their respective privacy policies.\n\n5. Your Rights & Choices\n\nYou can disable certain features (e.g., speech recognition) in the app settings.\n\nYou may contact us to request data deletion if applicable.\n\n6. Changes to This Policy\n\nWe may update this Privacy Policy from time to time. Any changes will be reflected in the app and updated with a new effective date.\n\n7. Contact Us\n\nIf you have any questions or concerns regarding this Privacy Policy, please contact us at:\n\ndacl.ramos.up@phinmaed.com\n\nBy using LinguaAR, you agree to this Privacy Policy.',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close', style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }
}
