import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class BasicPhrasesPage extends StatelessWidget {
  final List<Map<String, String>> phrases = [
    {"phrase": "Magandang Umaga", "video": "assets/videos/magandang_umaga.mp4"},
    {"phrase": "Magandang Hapon", "video": "assets/videos/magandang_hapon.mp4"},
    {"phrase": "Magandang Gabi", "video": "assets/videos/magandang_gabi.mp4"},
    {"phrase": "Kumusta", "video": "assets/videos/kumusta.mp4"},
    {"phrase": "Kumusta ka na?", "video": "assets/videos/kumusta_ka_na.mp4"},
    {"phrase": "Sundan mo ako", "video": "assets/videos/sundan_mo_ako.mp4"},
    {"phrase": "Miss na kita", "video": "assets/videos/sundan_mo_ako.mp4"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFEFFFE),
      appBar: AppBar(
        title: Text('Basic Phrases'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: phrases.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(phrases[index]['phrase']!),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PhraseDetailPage(
                    phrase: phrases[index]['phrase']!,
                    videoPath: phrases[index]['video']!,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class PhraseDetailPage extends StatefulWidget {
  final String phrase;
  final String videoPath;

  PhraseDetailPage({required this.phrase, required this.videoPath});

  @override
  _PhraseDetailPageState createState() => _PhraseDetailPageState();
}

class _PhraseDetailPageState extends State<PhraseDetailPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoPath)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.phrase),
      ),
      body: Center(
        child: _controller.value.isInitialized
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _controller.value.isPlaying
                            ? _controller.pause()
                            : _controller.play();
                      });
                    },
                    child: Text(
                      _controller.value.isPlaying ? 'Pause' : 'Play',
                    ),
                  ),
                ],
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
