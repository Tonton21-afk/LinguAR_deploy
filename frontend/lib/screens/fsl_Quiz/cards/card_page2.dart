import 'package:flutter/material.dart';
import 'package:lingua_arv1/Widgets/guide_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingua_arv1/bloc/Gif/gif_bloc.dart';
import 'package:lingua_arv1/bloc/Gif/gif_event.dart';
import 'package:lingua_arv1/bloc/Gif/gif_state.dart';

class CardPage2 extends StatefulWidget {
  final String phrase;
  final String gifPath;
  final VoidCallback onNext;

  const CardPage2({
    super.key,
    required this.phrase,
    required this.gifPath,
    required this.onNext,
  });

  @override
  State<CardPage2> createState() => _CardPage2State();
}

class _CardPage2State extends State<CardPage2> {
  bool _showGuide = false;

  @override
  void initState() {
    super.initState();
    _checkFirstTimeUser();
  }

  Future<void> _checkFirstTimeUser() async {
    final prefs = await SharedPreferences.getInstance();
    if (!(prefs.getBool("hasSeenCardPageGuide") ?? false)) {
      if (!mounted) return; // ✅ avoid setState after dispose
      setState(() => _showGuide = true);
      await prefs.setBool("hasSeenCardPageGuide", true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      key: const ValueKey('cardpage2_gifbloc'),
      create: (_) => GifBloc()
        ..add(FetchGif(publicId: widget.gifPath, phrase: widget.phrase)),
      child: Scaffold(
        backgroundColor:
            isDark ? const Color(0xFF273236) : const Color(0xFFFCEEFF),
        appBar: AppBar(
          title: Text(
            "Family, Relationships, and Social Life",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF273236),
            ),
          ),
          centerTitle: true,
          backgroundColor: isDark ? const Color(0xFF1D1D1D) : Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
                color: isDark ? Colors.white : Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.help_outline,
                  color: isDark ? Colors.white : Colors.black),
              onPressed: () => setState(() => _showGuide = true),
            ),
          ],
        ),
        body: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  width: 500,
                  height: 470,
                  child: BlocBuilder<GifBloc, GifState>(
                    builder: (context, state) {
                      if (state is GifLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is GifLoaded) {
                        return Container(
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius:
                                BorderRadius.circular(12), // ✅ subtle polish
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Image.network(
                            state.gifUrl,
                            fit: BoxFit.cover,
                            // ✅ graceful fallback instead of blank on error
                            errorBuilder: (_, __, ___) => const Center(
                              child: Text('Failed to load GIF'),
                            ),
                            gaplessPlayback:
                                true, // ✅ prevents flashing on rebuilds
                          ),
                        );
                      } else if (state is GifError) {
                        return Center(
                          child: Text(
                            "Error: ${state.message}",
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                      }
                      return const Center(child: Text("No GIF available."));
                    },
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  constraints: const BoxConstraints(
                    minWidth: 150,
                    maxWidth: 300, // ✅ expands for longer text but stays neat
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isDark ? Colors.white : Colors.black,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    color: isDark ? const Color(0xFF273236) : Colors.white,
                  ),
                  child: Text(
                    widget.phrase,
                    textAlign: TextAlign.center,
                    softWrap: true, // ✅ allow multi-line
                    style: TextStyle(
                      fontSize: 22, // slightly smaller for long phrases
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: ElevatedButton(
                    onPressed: widget.onNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A90E2),
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 80),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    child: const Text("NEXT",
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                ),
              ],
            ),
            if (_showGuide)
              GuideOverlay(onClose: () => setState(() => _showGuide = false)),
          ],
        ),
      ),
    );
  }
}
