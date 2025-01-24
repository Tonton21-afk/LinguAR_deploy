import 'package:flutter/material.dart';

class TechnologyPage extends StatelessWidget {
  final List<String> phrases = [
    "Teknolohiya",
    "Laptop",
    "Kompyuter",
    "Telepono",
    "Internet",
    "Wi-Fi",
    "Email",
    "Website",
    "App",
    "Programa",
    "Password",
    "Telebisyon",
    "Kamera",
    "Headphones",
    "Charger",
    "Download",
    "Upload",
    "Maghanap",
    "Video Call",
    "Paglalaro",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFEFFFE),
      appBar: AppBar(
        title: Text('Technology'),
      ),
      body: ListView.builder(
        itemCount: phrases.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(phrases[index]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PhraseDetailPage(phrase: phrases[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class PhraseDetailPage extends StatelessWidget {
  final String phrase;

  PhraseDetailPage({required this.phrase});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(phrase),
      ),
      body: Center(
        child: Text(
          'You selected: "$phrase"',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
