import 'package:flutter/material.dart';

class WorkProfessionPage extends StatelessWidget {
  final List<String> phrases = [
    "Trabaho",
    "Opisina",
    "Hanap Buhay",
    "Suweldo",
    "Pagpupulong",
    "Iskedyul",
    "Gawain",
    "Overtime",
    "Guro",
    "Doctor",
    "Nars",
    "Inhinyero",
    "Chef",
    "Pulis",
    "Magsasaka",
    "Drayber",
    "Artista",
    "Abogado",
    "Studyante",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Work and Profession'),
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
