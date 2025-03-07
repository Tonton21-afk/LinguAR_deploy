import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingua_arv1/bloc/Gif/gif_bloc.dart';
import 'package:lingua_arv1/bloc/Gif/gif_event.dart';
import 'package:lingua_arv1/bloc/Gif/gif_state.dart';

class FavoritesList extends StatelessWidget {
  final List<Map<String, dynamic>> favorites;

  const FavoritesList({Key? key, required this.favorites}) : super(key: key);

  /// Show a dialog with the mapped value
  void _showFavoriteDialog(
      BuildContext context, String phrase, String mappedValue) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(phrase, style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text("Mapped Value: $mappedValue"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Close"),
            ),
          ],
        );
      },
    );
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
    if (favorites.isEmpty) {
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
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final favorite = favorites[index];
                final phrase = favorite['item'] ?? 'Unknown';
                final mappedValue = favorite['mapped_value'] ?? 'Unknown Path';

                return Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: Icon(Icons.star, color: Colors.yellow),
                      title: Text(phrase,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      onTap: () {
                        context.read<GifBloc>().add(
                            FetchGif(phrase: phrase, publicId: mappedValue));
                      },
                    ));
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
