import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async'; // For CancelToken

class RelationshipsPage extends StatefulWidget {
  @override
  State<RelationshipsPage> createState() => _RelationshipsPageState();
}

class _RelationshipsPageState extends State<RelationshipsPage> {
  String _gifUrl = '';
  bool _isLoading = false;
  String _errorMessage = '';
  String _currentPhrase = ''; // New variable to store the current phrase
  http.Client? _httpClient; // To cancel ongoing requests

  final List<String> phrases = [
    "Valentines book",
    "Valentines card",
    "Valentines day",
    "Bulaklak",
    "Halik",
    "Nobyo",
    "Nobya",
    "Mahal kita",
    "Mahal",
    "Gusto",
    "Yakap",
    "Paghanga",
    "Gwapo",
    "Maganda",
    "Naakit",
    "Lagi",
    "kasal"
  ];

  @override
  void dispose() {
    // Cancel any ongoing requests
    _httpClient?.close();
    super.dispose();
  }

  Future<void> _fetchGif(String phrase) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _gifUrl = ''; // Clear previous GIF
      _currentPhrase = phrase; // Set the current phrase
    });

    String url = '';
    String publicId = '';
    String imageUrl = '';

    switch (phrase) {
      case "Valentines book":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739467789/LinguaAR/Anthony/Relasyon/Valentines-book.gif";
        publicId = "LinguaAR/Anthony/Relasyon/Valentines-book";
        break;
      case "Valentines card":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739467811/LinguaAR/Anthony/Relasyon/Valentines-card.gif";
        publicId = "LinguaAR/Anthony/Relasyon/Valentines-card";
        break;
      case "Valentines day":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739467846/LinguaAR/Anthony/Relasyon/Valentines-day.gif";
        publicId = "LinguaAR/Anthony/Relasyon/Valentines-day";
        break;
      case "Bulaklak":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739467884/LinguaAR/Anthony/Relasyon/Bulaklak.gif";
        publicId = "LinguaAR/Anthony/Relasyon/Bulaklak";
        break;
      case "Halik":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739467903/LinguaAR/Anthony/Relasyon/Halik.gif";
        publicId = "LinguaAR/Anthony/Relasyon/Halik";
        break;
      case "Nobyo":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739467827/LinguaAR/Anthony/Relasyon/Nobyo.gif";
        publicId = "LinguaAR/Anthony/Pamilya/Opo";
        break;
      case "Nobya":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739467925/LinguaAR/Anthony/Relasyon/Nobya.gif";
        publicId = "LinguaAR/Anthony/Relasyon/Nobya";
        break;
      case "Mahal kita":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739467940/LinguaAR/Anthony/Relasyon/Mahal-kita.gif";
        publicId = "LinguaAR/Anthony/Relasyon/Mahal-kita";
        break;
      case "Mahal":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739467958/LinguaAR/Anthony/Relasyon/Mahal.gif";
        publicId = "LinguaAR/Anthony/Relasyon/Mahal";
        break;
      case "Gusto":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739467974/LinguaAR/Anthony/Relasyon/Gusto.gif";
        publicId = "LinguaAR/Anthony/Relasyon/Gusto";
        break;
      case "Yakap":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739467992/LinguaAR/Anthony/Relasyon/Yakap.gif";
        publicId = "LinguaAR/Anthony/Relasyon/Yakap";
        break;
      case "Paghanga":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739468008/LinguaAR/Anthony/Relasyon/Paghanga.gif";
        publicId = "LinguaAR/Anthony/Relasyon/Paghanga";
        break;
      case "Gwapo":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739467863/LinguaAR/Anthony/Relasyon/Gwapo.gif";
        publicId = "LinguaAR/Anthony/Relasyon/Gwapo";
        break;
      case "Maganda":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739468067/LinguaAR/Anthony/Relasyon/Maganda.gif";
        publicId = "LinguaAR/Anthony/Relasyon/Maganda";
        break;
      case "Naakit":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739468256/LinguaAR/Anthony/Relasyon/Naakit.gif";
        publicId = "LinguaAR/Anthony/Relasyon/Naakit";
        break;
      case "Lagi":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739468329/LinguaAR/Anthony/Relasyon/Lagi.gif";
        publicId = "LinguaAR/Anthony/Relasyon/Lagi";
        break;
      case "Kasal":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739468348/LinguaAR/Anthony/Relasyon/Kasal.gif";
        publicId = "LinguaAR/Anthony/Relasyon/Kasal";
        break;
      default:
        setState(() {
          _isLoading = false;
          _errorMessage = 'No GIF found for this phrase.';
        });
        return;
    }

    if (publicId.isNotEmpty) {
      url = 'http://192.168.157.7:5000/cloudinary/get_gif?public_id=$publicId';
    } else if (imageUrl.isNotEmpty) {
      url = 'http://192.168.157.7:5000/cloudinary/get_gif?url=$imageUrl';
    }

    _httpClient = http.Client(); // Initialize HTTP client

    try {
      final response = await _httpClient!.get(Uri.parse(url)).timeout(
        Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Request timed out');
        },
      );

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
      if (error is TimeoutException) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Request timed out. Please try again.';
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Error occurred: $error';
        });
      }
    } finally {
      _httpClient?.close(); // Close the HTTP client
    }
  }

  void _showGifPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min, // Use minimum space
            children: [
              // Text above the container
              Text(
                _currentPhrase,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10), // Add some spacing
              // Container for the GIF
              Container(
                width: 500, // Fixed width for the container
                height: 410, // Fixed height for the container
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (_gifUrl.isNotEmpty)
                      Image.network(
                        _gifUrl,
                        fit: BoxFit
                            .cover, // Ensure the GIF fits inside the container
                      ),
                    if (_isLoading)
                      CircularProgressIndicator(), // Show loading indicator
                    if (_errorMessage.isNotEmpty)
                      Center(
                        child: Text(
                          _errorMessage,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    if (_gifUrl.isEmpty && !_isLoading && _errorMessage.isEmpty)
                      Center(
                        child: Text(
                          'GIF will appear here',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the pop-up
              },
              child: Text('Back'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Relationships'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Cancel ongoing requests and pop the page
            _httpClient?.close();
            Navigator.of(context).pop();
          },
        ),
      ),
      body: ListView.builder(
        itemCount: phrases.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(phrases[index]),
            onTap: () async {
              await _fetchGif(phrases[index]); // Fetch the GIF
              _showGifPopup(context); // Show the pop-up
            },
          );
        },
      ),
    );
  }
}
