import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingua_arv1/api/pronouns.dart';
import 'package:lingua_arv1/bloc/Gif/gif_bloc.dart';
import 'package:lingua_arv1/bloc/Gif/gif_event.dart';
import 'package:lingua_arv1/bloc/Gif/gif_state.dart';

class PronounsPage extends StatelessWidget {
  final List<String> phrases = pronounsMappings.keys.toList();

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
                decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
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
        appBar: AppBar(
          title: Text('Pronouns'),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: ListView.builder(
          itemCount: phrases.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(phrases[index]),
              onTap: () {
                String phrase = phrases[index];
                String publicId = pronounsMappings[phrase] ?? '';

                if (publicId.isNotEmpty) {
                  context.read<GifBloc>().add(FetchGif(phrase: phrase, publicId: publicId));
                }
              },
            );
          },
        ),
        bottomSheet: BlocBuilder<GifBloc, GifState>(
          builder: (context, state) {
            if (state is GifLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is GifLoaded) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _showGifPopup(context, state.phrase, state.gifUrl);
              });
            } else if (state is GifError) {
              return Center(child: Text(state.message, style: TextStyle(color: Colors.red)));
            }
            return SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
