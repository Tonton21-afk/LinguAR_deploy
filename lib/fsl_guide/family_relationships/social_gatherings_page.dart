import 'package:flutter/material.dart';

class SocialGatheringsPage extends StatelessWidget {
  final List<String> phrases = [
    "Kumusta ka?",
    "Maligayang Pagbati",
    "Maraming Salamat/ Salamat",
    "Walang Anuman",
    "Ayos lang ako/ Mabuti naman ako",
    "Okey",
    "Kumusta",
    "Ipinagmamalaki",
    "Pagasa",
    "Ipagdiwang",
    "Handaan",
    "Harana",
    "Harapang Pagbati",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFEFFFE),
      appBar: AppBar(
        title: Text('Social Gatherings'),
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
