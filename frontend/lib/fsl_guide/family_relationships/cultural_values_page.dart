import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CulturalValuesPage extends StatefulWidget {
  @override
  State<CulturalValuesPage> createState() => _CulturalValuesPageState();
}

class _CulturalValuesPageState extends State<CulturalValuesPage> {
  String _publicId = "";
  String _url = "";
  String _gifUrl = '';
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _fetchGif() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    String url = '';
    String publicId = _publicId.trim();
    String imageUrl = _url.trim();

    if (publicId.isNotEmpty) {
      url = 'http://127.0.0.1:5000/get_gif?public_id=$publicId';
    } else if (imageUrl.isNotEmpty) {
      url = 'http://127.0.0.1:5000/get_gif?url=$imageUrl';
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Please enter either a Public ID or a URL.';
      });
      return;
    }

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        setState(() {
          _gifUrl = jsonResponse['gif_url'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to fetch GIF from server.';
        });
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error occurred: $error';
      });
    }
  }

  final List<String> phrases = [
    "Pamilya",
    "Respeto",
    "Pananampalataya",
    "Aruga",
    "Utang",
    "Pakikisama",
    "Mabuhay",
    "Tiwala",
    "Bayanihan",
    "Katapan",
    "Relihiyoso",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFEFFFE),
      appBar: AppBar(
        title: Text('Cultural Values'),
      ),
      body: ListView.builder(
        itemCount: phrases.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(phrases[index]),
            onTap: () {
              switch (phrases[index]) {
                case "Pamilya":
                  setState(() {
                    _url = "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739431944/cld-sample-5.jpg";
                    _publicId = "cld-sample-5";
                  });
                  _fetchGif();
                  break;
                case "Respeto":
                  // Set the URL and Public ID for "Respeto"
                  setState(() {
                    _url = "https://example.com/respeto.jpg";
                    _publicId = "respeto-id";
                  });
                  _fetchGif();
                  break;
                case "Pananampalataya":
                  // Set the URL and Public ID for "Pananampalataya"
                  setState(() {
                    _url = "https://example.com/pananampalataya.jpg";
                    _publicId = "pananampalataya-id";
                  });
                  _fetchGif();
                  break;
                case "Aruga":
                  // Set the URL and Public ID for "Aruga"
                  setState(() {
                    _url = "https://example.com/aruga.jpg";
                    _publicId = "aruga-id";
                  });
                  _fetchGif();
                  break;
                // Add more cases for other phrases as needed
                default:
                  break;
              }

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
