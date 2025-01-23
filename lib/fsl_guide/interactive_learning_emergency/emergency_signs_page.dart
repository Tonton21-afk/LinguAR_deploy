import 'package:flutter/material.dart';

class EmergencySignsPage extends StatelessWidget {
  final List<String> phrases = [
    "Good Morning",
    "Good Afternoon",
    "Good Evening",
    "Good Night",
    "Good Noon",
    "Hello",
    "Hi",
    "How are you?",
    "Follow Me",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emergency Signs'),
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
