import 'package:flutter/material.dart';

class FamilyFriendsPage extends StatelessWidget {
  final List<String> phrases = [
    "Lola",
    "Lolo",
    "Mama",
    "Papa",
    "Pamilya",
    "Opo",
    "Kuya",
    "Ate",
    "Anak na lalaki (Son)",
    "Anak na babae (Daughter)",
    "Ninong",
    "Ninang",
    "Kaibigan",
    "Pinsan",
    "Malapit na Kaibigan",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Family and Friends'),
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
