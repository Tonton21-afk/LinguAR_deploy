import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingua_arv1/api/transportation.dart';
import 'package:lingua_arv1/bloc/Gif/gif_bloc.dart';
import 'package:lingua_arv1/bloc/Gif/gif_event.dart';
import 'package:lingua_arv1/bloc/Gif/gif_state.dart';
import 'package:lingua_arv1/screens/fsl_Quiz/answerFeedback.dart';

class CardPage4 extends StatelessWidget {
  final String currentPhrase = "Eroplano";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GifBloc()
        ..add(FetchGif(
            publicId: transportationMappings[currentPhrase] ?? "",
            phrase: currentPhrase)),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Learn a new sign!"),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.menu, color: Colors.black),
              onPressed: () {
                // Add your menu button functionality here
              },
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 500,
              height: 470,
              child: BlocBuilder<GifBloc, GifState>(
                builder: (context, state) {
                  if (state is GifLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is GifLoaded) {
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Image.network(
                        state.gifUrl,
                        fit: BoxFit.cover,
                      ),
                    );
                  } else if (state is GifError) {
                    return Center(
                      child: Text("Error: ${state.message}",
                          style: TextStyle(color: Colors.red)),
                    );
                  } else {
                    return Center(child: Text("No GIF available."));
                  }
                },
              ),
            ),
            SizedBox(height: 30),
            Container(
              width: 150,
              height: 60,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Text(
                currentPhrase,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.only(bottom: 30),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AnswerFeedback(
                          category: "Travel, Food, and Environment"),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo[900],
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 80),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  "NEXT",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
