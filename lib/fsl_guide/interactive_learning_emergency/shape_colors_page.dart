import 'package:flutter/material.dart';

class ShapeColorsPage extends StatelessWidget {
  final List<String> phrases = [
    "Bilog",
    "Parisukat",
    "Tatsulok",
    "Rektanggulo",
    "Ovalo",
    "Pentagon",
    "Hexagon",
    "Bituin",
    "Hugis puso",
    "Arko",
    "Pula",
    "Bughaw",
    "Dilaw",
    "Berde",
    "Kahel",
    "Rosas",
    "Lila",
    "Itim",
    "Puti",
    "Kayumanggi",
    "Abo",
    "Ginto",
    "Pilak",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shape and Colors'),
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
