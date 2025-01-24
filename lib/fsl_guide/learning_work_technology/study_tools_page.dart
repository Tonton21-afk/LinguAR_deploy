import 'package:flutter/material.dart';

class StudyToolsPage extends StatelessWidget {
  final List<String> phrases = [
    "Aklatan",
    "Takdang-Aralin",
    "Eksaminasyon",
    "Pananaliksik",
    "Kuwaderno",
    "Libro",
    "Pag-aaral",
    "Kagamitan",
    "Martilyo",
    "Wrench (Paikot na Lagare)",
    "Turnilyo (Screwdriver)",
    "Panukat na Tape",
    "Gunting",
    "Ruler",
    "Calculator",
    "Pandikit",
    "Panghasa",
    "Brush (Pangguhit)",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Study Tools'),
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
      backgroundColor: Color(0xFFFEFFFE),
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
