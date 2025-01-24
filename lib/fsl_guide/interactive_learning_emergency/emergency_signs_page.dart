import 'package:flutter/material.dart';

class EmergencySignsPage extends StatelessWidget {
  final List<String> phrases = [
    "Lumikas",
    "Bawal Pumasok",
    "Labasan",
    "Panganib",
    "Bawal Manigarilyo",
    "Bantay-sunog",
    "Bawal magtapon ng basura",
    "Daanan ng tao",
    "Huwag hawakan",
    "Pindutin sa oras ng sakuna",
    "Unang lunas",
    "Telepono ng sakuna",
    "Mabagal lang",
    "Lugar ng tagpuan",
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
