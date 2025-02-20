import 'package:flutter/material.dart';

class GifDisplay extends StatelessWidget {
  final String gifUrl;

  const GifDisplay({Key? key, required this.gifUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 550,
      height: 450,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey),
      ),
      child: gifUrl.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(gifUrl, fit: BoxFit.cover),
            )
          : const Center(child: Text("No GIF available")),
    );
  }
}
