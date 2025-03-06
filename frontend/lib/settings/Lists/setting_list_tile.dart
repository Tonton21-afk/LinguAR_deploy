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
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.grey),
          title: Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          trailing: Text(
            title == 'Password' ? '********' : value,
            style: TextStyle(color: Colors.grey, fontSize: 14),
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
        Divider(height: 1, thickness: 0.5, color: Colors.grey[300]),
      ],
    );
  }
}
