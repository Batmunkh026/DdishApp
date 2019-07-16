import 'package:flutter/material.dart';

class LoadPromoImage extends StatelessWidget {
  final String url;

  LoadPromoImage({this.url});

  @override
  Widget build(BuildContext context) {
    return FadeInImage.assetNetwork(
      fit: BoxFit.fill,
      fadeInDuration: const Duration(milliseconds: 10),
      placeholder: 'assets/program/poster_placeholder.png',
      image: url,
    );
  }
}
