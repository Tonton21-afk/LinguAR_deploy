import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingua_arv1/bloc/Gif/gif_bloc.dart';
import 'package:lingua_arv1/bloc/Gif/gif_event.dart';
import 'package:lingua_arv1/bloc/Gif/gif_state.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:lingua_arv1/repositories/Config.dart';
import 'package:lingua_arv1/validators/token.dart';

class FavoritesList extends StatefulWidget {
  final List<Map<String, dynamic>> favorites;

  const FavoritesList({Key? key, required this.favorites}) : super(key: key);

  @override
  State<FavoritesList> createState() => _FavoritesListState();
}

class _FavoritesListState extends State<FavoritesList> {
  String? userId;
  String basicurl = BasicUrl.baseURL;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  /// Load the User ID
  Future<void> _loadUserId() async {
    userId = await TokenService.getUserId();
  }

  /// Show a pop-up confirmation before deleting a favorite
  void _showDeleteConfirmation(BuildContext context, String phrase) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Remove Favorite"),
          content: Text(
              "Are you sure you want to remove \"$phrase\" from your favorites?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                _removeFavorite(phrase);
                Navigator.of(context).pop();
              },
              child: Text("OK", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  /// Remove a favorite from the database
  Future<void> _removeFavorite(String phrase) async {
    if (userId == null) return;

    try {
      final response = await http.delete(
        Uri.parse(
            '$basicurl/favorites/favorites/$userId/${Uri.encodeComponent(phrase)}'),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        setState(() {
          widget.favorites.removeWhere((fav) => fav['item'] == phrase);
        });
        print("✅ Removed from favorites: $phrase");
      } else {
        print("❌ Error removing favorite: ${response.body}");
      }
    } catch (e) {
      print("❌ Exception removing favorite: $e");
    }
  }

  /// Show a GIF popup
  void _showGifPopup(BuildContext context, String phrase, String gifUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(phrase,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
    if (widget.favorites.isEmpty) {
      return Center(
        child: Text(
          "No favorites added yet.",
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return BlocProvider(
      create: (context) => GifBloc(),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.favorites.length,
              itemBuilder: (context, index) {
                final favorite = widget.favorites[index];
                final phrase = favorite['item'] ?? 'Unknown';
                final mappedValue = favorite['mapped_value'] ?? 'Unknown Path';

                return Dismissible(
                    key: Key(phrase),
                    direction:
                        DismissDirection.endToStart, // Swipe from right to left
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                    confirmDismiss: (direction) async {
                      _showDeleteConfirmation(context, phrase);
                      return false; // Prevent immediate deletion until confirmed
                    },
                    child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          title: Text(phrase,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          trailing: Icon(Icons.star,
                              color: Colors.yellow), // Star on the right side

                          onTap: () {
                            context.read<GifBloc>().add(FetchGif(
                                phrase: phrase, publicId: mappedValue));
                          },
                        )));
              },
            ),
          ),
          BlocBuilder<GifBloc, GifState>(
            builder: (context, state) {
              if (state is GifLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is GifLoaded) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _showGifPopup(context, state.phrase, state.gifUrl);
                });
              } else if (state is GifError) {
                return Center(
                  child:
                      Text(state.message, style: TextStyle(color: Colors.red)),
                );
              }
              return SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
