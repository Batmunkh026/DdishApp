import 'dart:io';

import 'package:ddish/src/models/movie.dart';
import 'package:flutter/material.dart';

class MovieThumbnail extends StatelessWidget {
  final Movie movie;
  var onTap;

  MovieThumbnail({Key key, this.movie, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.contain,
          child: Image.network(movie.coverMiniUrl),
        ),
      ),
    );
  }
}
