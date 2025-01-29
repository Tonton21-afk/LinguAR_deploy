import 'package:flutter/material.dart';

class SituationalConvosPage extends StatelessWidget {
  final List<String> phrases = [
    "Nasaan ang banyo?",
    "Magkano po ito?",
    "Pwede bang tunulong",
    "Anong oras na?",
    "May tanong ako",
    "Saan ang sakayan?",
    "Anong pangalan mo?",
    "Pwede po bang magtanong",
    "Saan banda?",
    "Ano'ng nagyari?",
    "Anong ibig sabihin nito?",
    "May kilala ka bang doktor?",
    "Pwede ba akong makisabay?",
    "Nagugutom na ako",
    "Uhaw na ako",
    "Ako'y nalulumbay sa aking pagiisa",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFEFFFE),
      appBar: AppBar(
        title: Text('Situational Convos'),
        centerTitle: true,
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
