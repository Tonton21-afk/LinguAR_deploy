import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingua_arv1/api/shapes_colors.dart';
import 'package:lingua_arv1/bloc/Gif/gif_bloc.dart';
import 'package:lingua_arv1/bloc/Gif/gif_event.dart';
import 'package:lingua_arv1/bloc/Gif/gif_state.dart';
import 'package:http/http.dart' as http;
import 'package:lingua_arv1/repositories/Config.dart';
import 'package:lingua_arv1/validators/token.dart';


class ShapeColorsPage extends StatefulWidget {
  @override
  State<ShapeColorsPage> createState() => _ShapeColorsPageState();
}

class _ShapeColorsPageState extends State<ShapeColorsPage> {
  final List<String> phrases = shapeColorsMappings.keys.toList();
  String? userId;
  Map<String, bool> favorites = {}; // To track favorite phrases
  String basicurl = BasicUrl.baseURL;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  /// Load the user ID and fetch favorites
  Future<void> _loadUserId() async {
    userId = await TokenService.getUserId();
    if (userId != null) {
      print("User ID Loaded: $userId"); // Debugging
      _fetchFavorites();
    } else {
      print("Error: User ID is null");
    }
  }

  /// Fetch user's favorite phrases from API
  Future<void> _fetchFavorites() async {
    if (userId == null) return; // Ensure userId is not null
    try {
      final response =
          await http.get(Uri.parse('$basicurl/favorites/favorites/$userId'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          favorites = {for (var fav in data) fav['item']: true};
        });
      } else {
        print("Error fetching favorites: ${response.body}");
        setState(() {
          favorites = {};
        });
      }
    } catch (e) {
      print("Exception fetching favorites: $e");
    }
  }

  /// Toggle favorite status for a phrase
  Future<void> _toggleFavorite(String phrase) async {
    if (userId == null) {
      print("❌ Error: User ID is null, cannot toggle favorite.");
      return;
    }

    String mappedValue = shapeColorsMappings[phrase] ?? "";
    if (mappedValue.isEmpty) {
      print("❌ Error: No mapped value found for phrase: $phrase");
      return;
    }

    bool isFavorite = favorites[phrase] ?? false;
    String url = '$basicurl/favorites/favorites';
    Map<String, String> headers = {"Content-Type": "application/json"};
    Map<String, dynamic> body = {
      "user_id": userId,
      "item": phrase,
      "mapped_value": mappedValue
    };

    try {
      if (isFavorite) {
        // Remove from favorites
        final response = await http.delete(
          Uri.parse('$url/$userId/${Uri.encodeComponent(phrase)}'),
          headers: headers,
        );

        if (response.statusCode == 200) {
          setState(() {
            favorites[phrase] = false;
          });
          print("✅ Removed from favorites: $phrase ($mappedValue)");
        } else {
          print("❌ Error removing favorite: ${response.body}");
        }
      } else {
        // Add to favorites with mapped value
        final response = await http.post(
          Uri.parse(url),
          headers: headers,
          body: jsonEncode(body),
        );

        if (response.statusCode == 201) {
          setState(() {
            favorites[phrase] = true;
          });
          print("✅ Added to favorites: $phrase ($mappedValue)");
        } else {
          print("❌ Error adding favorite: ${response.body}");
        }
      }
    } catch (e) {
      print("❌ Exception in _toggleFavorite: $e");
    }
  }

  void _showGifPopup(BuildContext context, String phrase, String gifUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                phrase,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Container(
                width: 500,
                height: 410,
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.grey)),
                child: Image.network(gifUrl, fit: BoxFit.cover),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
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
    return BlocProvider(
      create: (context) => GifBloc(),
      child: Scaffold(
        appBar: AppBar(title: Text('Color & Shapes')),
        body: ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: phrases.length,
          itemBuilder: (context, index) {
            String phrase = phrases[index];
            bool isFavorite = favorites[phrase] ?? false;
            return Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                title:
                    Text(phrase, style: TextStyle(fontWeight: FontWeight.bold)),
                trailing: IconButton(
                  icon: Icon(
                    isFavorite ? Icons.star : Icons.star_border,
                    color: isFavorite ? Colors.yellow : Colors.grey,
                  ),
                  onPressed: () => _toggleFavorite(phrase),
                ),
                onTap: () {
                  String publicId = shapeColorsMappings[phrase] ?? '';
                  if (publicId.isNotEmpty) {
                    context
                        .read<GifBloc>()
                        .add(FetchGif(phrase: phrase, publicId: publicId));
                  }
                },
              ),
            );
          },
        ),
        bottomSheet: BlocBuilder<GifBloc, GifState>(
          builder: (context, state) {
            if (state is GifLoading)
              return Center(child: CircularProgressIndicator());
            if (state is GifLoaded) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _showGifPopup(context, state.phrase, state.gifUrl);
              });
            }
            if (state is GifError) {
              return Center(
                  child:
                      Text(state.message, style: TextStyle(color: Colors.red)));
            }
            return SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
