import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lingua_arv1/api/family_friends.dart';
import 'package:lingua_arv1/screens/fsl_Quiz/answerFeedback.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingua_arv1/bloc/Gif/gif_bloc.dart';
import 'package:lingua_arv1/bloc/Gif/gif_event.dart';
import 'package:lingua_arv1/bloc/Gif/gif_state.dart';

class CardPage2 extends StatefulWidget {
  @override
  _CardPage2State createState() => _CardPage2State();
}

class _CardPage2State extends State<CardPage2> {
  final String currentPhrase = "Lola";
  bool _showGuide = false;

  @override
  void initState() {
    super.initState();
    _checkFirstTimeUser();
  }

  Future<void> _checkFirstTimeUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? hasSeenGuide = prefs.getBool("hasSeenCardPageGuide");
    if (hasSeenGuide == null || !hasSeenGuide) {
      setState(() {
        _showGuide = true;
      });
      await prefs.setBool("hasSeenCardPageGuide", true);
    }
  }

  void _showUserGuide() {
    setState(() {
      _showGuide = true;
    });
  }

  void _dismissGuide() {
    setState(() {
      _showGuide = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GifBloc()
        ..add(FetchGif(
            publicId: familyFriendsMappings[currentPhrase] ?? "",
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
              icon: Icon(Icons.help_outline,
                  color: Colors.black), // Changed to guide icon
              onPressed: _showUserGuide, // Show guide when clicked
            ),
          ],
        ),
        body: Stack(
          children: [
            Column(
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
                              category: "Family & Relationships"),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo[900],
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 80),
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
            if (_showGuide)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.7),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Welcome to Sign Learning!",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "- The image above shows the sign animation.\n- Below it, you'll see the phrase you're learning.\n- Click NEXT to proceed!",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: _dismissGuide,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text("Got it!",
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
