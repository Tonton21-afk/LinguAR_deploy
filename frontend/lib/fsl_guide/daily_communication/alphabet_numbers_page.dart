import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async'; // For CancelToken

class AlphabetNumbersPage extends StatefulWidget {
  @override
  State<AlphabetNumbersPage> createState() => _AlphabetNumbersPageState();
}

class _AlphabetNumbersPageState extends State<AlphabetNumbersPage> {
  String _gifUrl = '';
  bool _isLoading = false;
  String _errorMessage = '';
  String _currentPhrase = ''; // New variable to store the current phrase
  http.Client? _httpClient; // To cancel ongoing requests

  final List<String> phrases = [
    "A",
    "B",
    "C",
    "D",
    "E",
    "F",
    "G",
    "H",
    "I",
    "J",
    "K",
    "L",
    "M",
    "N",
    "O",
    "P",
    "Q",
    "R",
    "S",
    "T",
    "U",
    "V",
    "W",
    "X",
    "Y",
    "Z",
    "Isa",
    "Dalawa",
    "Tatlo",
    "Apat",
    "Lima",
    "Anim",
    "Pito",
    "Walo",
    "Siyam",
    "Sampu",
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
      case "A":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739469945/LinguaAR/Dal/Alphabet%20and%20Numbers/A.gif";
        publicId = "LinguaAR/Dal/Alphabet and Numbers/A";
        break;
      case "B":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739469964/LinguaAR/Dal/Alphabet%20and%20Numbers/B.gif";
        publicId = "LinguaAR/Dal/Alphabet and Numbers/B";
        break;
      case "C":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739469950/LinguaAR/Dal/Alphabet%20and%20Numbers/C.gif";
        publicId = "LinguaAR/Dal/Alphabet and Numbers/C";
        break;
      case "D":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739469948/LinguaAR/Dal/Alphabet%20and%20Numbers/D.gif";
        publicId = "LinguaAR/Dal/Alphabet and Numbers/D";
        break;
      case "E":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739467903/LinguaAR/Anthony/Relasyon/Halik.gif";
        publicId = "LinguaAR/Dal/Alphabet and Numbers/E";
        break;
      case "F":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739467827/LinguaAR/Anthony/Relasyon/Nobyo.gif";
        publicId = "LinguaAR/Dal/Alphabet and Numbers/F";
        break;
      case "G":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739467925/LinguaAR/Anthony/Relasyon/Nobya.gif";
        publicId = "LinguaAR/Dal/Alphabet and Numbers/G";
        break;
      case "H":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739467940/LinguaAR/Anthony/Relasyon/Mahal-kita.gif";
        publicId = "LinguaAR/Dal/Alphabet and Numbers/H";
        break;
      case "I":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739467958/LinguaAR/Anthony/Relasyon/Mahal.gif";
        publicId = "LinguaAR/Dal/Alphabet and Numbers/I";
        break;
      case "J":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739467974/LinguaAR/Anthony/Relasyon/Gusto.gif";
        publicId = "LinguaAR/Dal/Alphabet and Numbers/J";
        break;
      case "K":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739467992/LinguaAR/Anthony/Relasyon/Yakap.gif";
        publicId = "LinguaAR/Dal/Alphabet and Numbers/K";
        break;
      case "L":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739468008/LinguaAR/Anthony/Relasyon/Paghanga.gif";
        publicId = "LinguaAR/Dal/Alphabet and Numbers/L";
        break;
      case "M":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739467863/LinguaAR/Anthony/Relasyon/Gwapo.gif";
        publicId = "LinguaAR/Dal/Alphabet and Numbers/M";
        break;
      case "N":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739468067/LinguaAR/Anthony/Relasyon/Maganda.gif";
        publicId = "LinguaAR/Dal/Alphabet and Numbers/N";
        break;
      case "O":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739468256/LinguaAR/Anthony/Relasyon/Naakit.gif";
        publicId = "LinguaAR/Dal/Alphabet and Numbers/O";
        break;
      case "P":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739468329/LinguaAR/Anthony/Relasyon/Lagi.gif";
        publicId = "LinguaAR/Dal/Alphabet and Numbers/P";
        break;
      case "Q":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739468348/LinguaAR/Anthony/Relasyon/Kasal.gif";
        publicId = "LinguaAR/Dal/Alphabet and Numbers/Q";
        break;
      case "R":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739468348/LinguaAR/Anthony/Relasyon/Kasal.gif";
        publicId = "LinguaAR/Dal/Alphabet and Numbers/R";
        break;
      case "S":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739468348/LinguaAR/Anthony/Relasyon/Kasal.gif";
        publicId = "LinguaAR/Dal/Alphabet and Numbers/S";
        break;
      case "T":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739468348/LinguaAR/Anthony/Relasyon/Kasal.gif";
        publicId = "LinguaAR/Dal/Alphabet and Numbers/T";
        break;
      case "U":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739468348/LinguaAR/Anthony/Relasyon/Kasal.gif";
        publicId = "LinguaAR/Dal/Alphabet and Numbers/U";
        break;
      case "V":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739468348/LinguaAR/Anthony/Relasyon/Kasal.gif";
        publicId = "LinguaAR/Dal/Alphabet and Numbers/V";
        break;
      case "W":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739468348/LinguaAR/Anthony/Relasyon/Kasal.gif";
        publicId = "LinguaAR/Dal/Alphabet and Numbers/W";
        break;
      case "X":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739468348/LinguaAR/Anthony/Relasyon/Kasal.gif";
        publicId = "LinguaAR/Dal/Alphabet and Numbers/X";
        break;
      case "Y":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739468348/LinguaAR/Anthony/Relasyon/Kasal.gif";
        publicId = "LinguaAR/Dal/Alphabet and Numbers/Y";
        break;
      case "Z":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739468348/LinguaAR/Anthony/Relasyon/Kasal.gif";
        publicId = "LinguaAR/Dal/Alphabet and Numbers/Z";
        break;
      case "Isa":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739468348/LinguaAR/Anthony/Relasyon/Kasal.gif";
        publicId = "LinguaAR/Dal/Alphabet and Numbers/Isa";
        break;
      case "Dalawa":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739468348/LinguaAR/Anthony/Relasyon/Kasal.gif";
        publicId = "LinguaAR/Dal/Alphabet and Numbers/Dalawa";
        break;
      case "Tatlo":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739468348/LinguaAR/Anthony/Relasyon/Kasal.gif";
        publicId = "LinguaAR/Dal/Alphabet and Numbers/Tatlo";
        break;
      case "Apat":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739468348/LinguaAR/Anthony/Relasyon/Kasal.gif";
        publicId = "LinguaAR/Dal/Alphabet and Numbers/Apat";
        break;
      case "Lima":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739468348/LinguaAR/Anthony/Relasyon/Kasal.gif";
        publicId = "LinguaAR/Dal/Alphabet and Numbers/Lima";
        break;
      case "Anim":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739468348/LinguaAR/Anthony/Relasyon/Kasal.gif";
        publicId = "LinguaAR/Dal/Alphabet and Numbers/Anim";
        break;
      case "Pito":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739468348/LinguaAR/Anthony/Relasyon/Kasal.gif";
        publicId = "LinguaAR/Dal/Alphabet and Numbers/Pito";
        break;
      case "Walo":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739468348/LinguaAR/Anthony/Relasyon/Kasal.gif";
        publicId = "LinguaAR/Dal/Alphabet and Numbers/Walo";
        break;
      case "Siyam":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739468348/LinguaAR/Anthony/Relasyon/Kasal.gif";
        publicId = "LinguaAR/Dal/Alphabet and Numbers/Siyam";
        break;
      case "Sampu":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739468348/LinguaAR/Anthony/Relasyon/Kasal.gif";
        publicId = "LinguaAR/Dal/Alphabet and Numbers/Sampu";
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
        title: Text('Alphabets and Numbers'),
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
