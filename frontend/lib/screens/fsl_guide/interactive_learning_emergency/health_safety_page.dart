import 'package:flutter/material.dart';

class HealthSafetyPage extends StatelessWidget {
  final List<String> phrases = [
    "Kaligtasan",
    "Unang Tulong",
    "Pahinga",
    "Ligtas",
    "Maghugas ng kamay",
    "Bawal mag-ingay",
    "May sakit",
    "Gamot",
    "Bakuna",
    "Panganib sa kalusugan",
    "Tamang nutrisyon",
    "Iwasan ang aksidente",
    "Mag-ingat sa kalsada",
    "Magsuot ng maskara",
    "Magtawag ng doktor",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFEFFFE),
      appBar: AppBar(
        title: Text('Health and Safety'),
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
