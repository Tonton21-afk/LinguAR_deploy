import 'package:flutter/material.dart';

class SettingListTile extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final List<String>? options;
  final Widget? navigateTo;
  final Function()? onTap;
  final Map<String, String>? settings;
  
  
  

  const SettingListTile({
    required this.title,
    required this.value,
    required this.icon,
    this.options,
    this.navigateTo,
    this.onTap,
    this.settings,
  });

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

      return Column(
      children: [
        ListTile(
          leading: Icon(
            icon,
            color: isDarkMode ? Colors.white : Colors.grey, // Icon color
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isDarkMode ? Colors.white : Colors.black, // Title color
            ),
          ),
          trailing: Text(
            title == 'Password' ? '********' : value,
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.grey, // Value color
              fontSize: 14,
            ),
          ),
          onTap: () {
            if (onTap != null) {
              onTap!();
            } else if (navigateTo != null) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => navigateTo!),
              );
            }
          },
        ),
        Divider(
          height: 1,
          thickness: 0.5,
          color: isDarkMode ? Colors.white : Colors.grey[300], // Divider color
        ),
      ],
    );
  }
}