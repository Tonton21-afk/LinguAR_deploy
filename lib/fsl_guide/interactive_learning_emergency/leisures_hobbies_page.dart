import 'package:flutter/material.dart';

class LeisuresHobbiesPage extends StatelessWidget {
  final List<String> phrases = [
    "Pagbabasa",
    "Pagsusulat",
    "Pagsusulat",
    "Pagpipinta",
    "Pagkanta",
    "Pagsasayaw",
    "Pagluluto",
    "Paglalakbay",
    "Panonood ng pelikula",
    "Panood ng pelikula",
    "Paglalaro ng musika",
    "Pag-aalaga ng halaman",
    "Pagkuha ng litrato",
    "Pag-eensayo",
    "Pangigisda",
    "Paglalaro ng sports",
    "Pagtatahi",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leisures and Hobbies'),
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
