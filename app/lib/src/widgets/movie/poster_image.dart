import 'package:flutter/material.dart';

class PosterImage extends StatelessWidget {
  final String url;

  PosterImage({this.url});

  @override
  Widget build(BuildContext context) {
    return FadeInImage.assetNetwork(
      fit: BoxFit.contain,
      fadeInDuration: const Duration(milliseconds: 10),
      placeholder: 'assets/program/poster_placeholder.png',
      image: url,
    );
  }
}
