import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async'; // For CancelToken

class BasicPhrasesPage extends StatefulWidget {
  @override
  State<BasicPhrasesPage> createState() => _BasicPhrasesPageState();
}

class _BasicPhrasesPageState extends State<BasicPhrasesPage> {
  String _gifUrl = '';
  bool _isLoading = false;
  String _errorMessage = '';
  String _currentPhrase = '';
  http.Client? _httpClient;
  // To cancel ongoing requests
  final List<String> phrases = [
    "Mga Ito",
    "Sila",
    "Ito",
    "Aking Sarili/Sarili ko",
    "Iyan",
    "Ikaw",
    "Akin",
    "Mga Iyan",
    "Siya (Lalaki)",
    "Atin",
    "Siya (Babae)",
    "Kanila",
    "Sa Kanila",
    "Kanya (Lalaki)",
    "Sa Kanya (Lalaki)",
    "Tayo",
    "Ako",
    "Sa Kanya (Babae)",
    "Sayo",
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
      case "Mga Ito":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739469945/LinguaAR/Dal/Alphabet%20and%20Numbers/A.gif";
        publicId = "LinguaAR/Dal/Basic Phrases/These";
        break;
      case "Sila":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739469964/LinguaAR/Dal/Alphabet%20and%20Numbers/B.gif";
        publicId = "LinguaAR/Dal/Basic Phrases/Sila";
        break;
      case "Ito":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739469950/LinguaAR/Dal/Alphabet%20and%20Numbers/C.gif";
        publicId = "LinguaAR/Dal/Basic Phrases/It";
        break;
      case "Aking Sarili/Sarili ko":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739469948/LinguaAR/Dal/Alphabet%20and%20Numbers/D.gif";
        publicId = "LinguaAR/Dal/Basic Phrases/Myself";
        break;
      case "Iyan":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739467903/LinguaAR/Anthony/Relasyon/Halik.gif";
        publicId = "LinguaAR/Dal/Basic Phrases/Iyan";
        break;
      case "Ikaw":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739467827/LinguaAR/Anthony/Relasyon/Nobyo.gif";
        publicId = "LinguaAR/Dal/Basic Phrases/Ikaw";
        break;
      case "Akin":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739467925/LinguaAR/Anthony/Relasyon/Nobya.gif";
        publicId = "LinguaAR/Dal/Basic Phrases/Akin";
        break;
      case "Mga Iyan":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739467940/LinguaAR/Anthony/Relasyon/Mahal-kita.gif";
        publicId = "LinguaAR/Dal/Basic Phrases/MgaIyan";
        break;
      case "Siya (Lalaki)":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739467958/LinguaAR/Anthony/Relasyon/Mahal.gif";
        publicId = "LinguaAR/Dal/Basic Phrases/He";
        break;
      case "Atin":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739467974/LinguaAR/Anthony/Relasyon/Gusto.gif";
        publicId = "LinguaAR/Dal/Basic Phrases/Atin";
        break;
      case "Siya (Babae)":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739467992/LinguaAR/Anthony/Relasyon/Yakap.gif";
        publicId = "LinguaAR/Dal/Basic Phrases/She";
        break;
      case " Sa Kanila":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739468008/LinguaAR/Anthony/Relasyon/Paghanga.gif";
        publicId = "LinguaAR/Dal/Basic Phrases/Them";
        break;
      case "Kanya (Lalaki)":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739467863/LinguaAR/Anthony/Relasyon/Gwapo.gif";
        publicId = "LinguaAR/Dal/Basic Phrases/Him";
        break;
      case "Sa Kanya (Lalaki)":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739467863/LinguaAR/Anthony/Relasyon/Gwapo.gif";
        publicId = "LinguaAR/Dal/Basic Phrases/Him";
        break;
      case "Tayo":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739468067/LinguaAR/Anthony/Relasyon/Maganda.gif";
        publicId = "LinguaAR/Dal/Basic Phrases/Tayo";
        break;
      case "Ako":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739468256/LinguaAR/Anthony/Relasyon/Naakit.gif";
        publicId = "LinguaAR/Dal/Basic Phrases/Ako";
        break;
      case "Sa Kanya (Babae)":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739468329/LinguaAR/Anthony/Relasyon/Lagi.gif";
        publicId = "LinguaAR/Dal/Basic Phrases/Her";
        break;
      case "Kanila":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739468348/LinguaAR/Anthony/Relasyon/Kasal.gif";
        publicId = "LinguaAR/Dal/Basic Phrases/Kanila";
        break;
      case "Sayo":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739468348/LinguaAR/Anthony/Relasyon/Kasal.gif";
        publicId = "LinguaAR/Dal/Basic Phrases/Sayo";
        break;
      default:
        setState(() {
          _isLoading = false;
          _errorMessage = 'No GIF found for this phrase.';
        });
        return;
    }

    if (publicId.isNotEmpty) {
      url =
          'http://192.168.157.7:5000/cloudinary/get_gif?public_id=$publicId';
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
        title: Text('Pronouns'),
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
