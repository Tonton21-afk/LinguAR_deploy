
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async'; // For CancelToken

class FamilyFriendsPage extends StatefulWidget {
  @override
  State<FamilyFriendsPage> createState() => _FamilyFriendsPageState();
}

class _FamilyFriendsPageState extends State<FamilyFriendsPage> {
  String _gifUrl = '';
  bool _isLoading = false;
  String _errorMessage = '';
  http.Client? _httpClient; // To cancel ongoing requests

  final List<String> phrases = [
    "Lola",
    "Lolo",
    "Mama",
    "Papa",
    "Pamilya",
    "Opo",
    "Kuya",
    "Ate",
    "Anak na lalaki (Son)",
    "Anak na babae (Daughter)",
    "Ninong",
    "Ninang",
    "Pinsan",
    "Bata",
    "Buntis",
    "Tinedyer",
    "Mga Bata",
    "Tita",
    "Tito"
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
    });

    String url = '';
    String publicId = '';
    String imageUrl = '';

    switch (phrase) {
      case "Lola":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739457481/LinguaAR/Anthony/Pamilya/Lola.gif";
        publicId = "LinguaAR/Anthony/Pamilya/Lola";
        break;
      case "Lolo":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739457473/LinguaAR/Anthony/Pamilya/Lolo.gif";
        publicId = "LinguaAR/Anthony/Pamilya/Lolo";
        break;
      case "Mama":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739457471/LinguaAR/Anthony/Pamilya/Mama.gif";
        publicId = "LinguaAR/Anthony/Pamilya/Mama";
        break;
      case "Papa":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739457466/LinguaAR/Anthony/Pamilya/Papa.gif";
        publicId = "LinguaAR/Anthony/Pamilya/Papa";
        break;
      case "Pamilya":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739457493/LinguaAR/Anthony/Pamilya/Pamilya.gif";
        publicId = "LinguaAR/Anthony/Pamilya/Pamilya";
        break;
      case "Opo":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739457413/LinguaAR/Anthony/Pamilya/Opo.gif";
        publicId = "LinguaAR/Anthony/Pamilya/Opo";
        break;
      case "Kuya":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739457397/LinguaAR/Anthony/Pamilya/Kuya.gif";
        publicId = "LinguaAR/Anthony/Pamilya/Kuya";
        break;
      case "Ate":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739457380/LinguaAR/Anthony/Pamilya/Ate.gif";
        publicId = "LinguaAR/Anthony/Pamilya/Ate";
        break;
      case "Anak na lalaki (Son)":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739457364/LinguaAR/Anthony/Pamilya/Anak-na-lalaki.gif";
        publicId = "LinguaAR/Anthony/Pamilya/Anak-na-lalaki";
        break;
      case "Anak na babae (Daughter)":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739457348/LinguaAR/Anthony/Pamilya/Anak-na-babae.gif";
        publicId = "LinguaAR/Anthony/Pamilya/Anak-na-babae";
        break;
      case "Ninong":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739457299/LinguaAR/Anthony/Pamilya/Ninong.gif";
        publicId = "LinguaAR/Anthony/Pamilya/Ninong";
        break;
      case "Ninang":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739457331/LinguaAR/Anthony/Pamilya/Ninang.gif";
        publicId = "LinguaAR/Anthony/Pamilya/Ninang";
        break;
      case "Pinsan":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739457316/LinguaAR/Anthony/Pamilya/Pinsan.gif";
        publicId = "LinguaAR/Anthony/Pamilya/Pinsan";
        break;
      case "Bata":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739457253/LinguaAR/Anthony/Pamilya/Bata.gif";
        publicId = "LinguaAR/Anthony/Pamilya/Bata";
        break;
      case "Buntis":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739456863/LinguaAR/Anthony/Pamilya/Buntis.gif";
        publicId = "LinguaAR/Anthony/Pamilya/Buntis";
        break;
      case "Tinedyer":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739456967/LinguaAR/Anthony/Pamilya/Tinedyer.gif";
        publicId = "LinguaAR/Anthony/Pamilya/Tinedyer";
        break;
      case "Mga Bata":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739457117/LinguaAR/Anthony/Pamilya/Mga-Bata.gif";
        publicId = "LinguaAR/Anthony/Pamilya/Mga-Bata";
        break;
      case "Tita":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739457267/LinguaAR/Anthony/Pamilya/Tita.gif";
        publicId = "LinguaAR/Anthony/Pamilya/Tita";
        break;
      case "Tito":
        imageUrl =
            "https://res.cloudinary.com/dqthtm7gt/image/upload/v1739457283/LinguaAR/Anthony/Pamilya/Tito.gif";
        publicId = "LinguaAR/Anthony/Pamilya/Tito";
        break;
      default:
        setState(() {
          _isLoading = false;
          _errorMessage = 'No GIF found for this phrase.';
        });
        return;
    }

    if (publicId.isNotEmpty) {
      url = 'http://192.168.100.53:5000/cloudinary/get_gif?public_id=$publicId';
    } else if (imageUrl.isNotEmpty) {
      url = 'http://192.168.100.53:5000/cloudinary/get_gif?url=$imageUrl';
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
          content: Container(
            width: 400, // Fixed width for the container
            height: 700, // Fixed height for the container
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (_gifUrl.isNotEmpty)
                  Image.network(
                    _gifUrl,
                    fit: BoxFit.cover, // Ensure the GIF fits inside the container
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
        title: Text('GIF Fetcher'),
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