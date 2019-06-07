import 'package:ddish/src/models/tab_models.dart';
import 'package:ddish/src/templates/menu/menu_page.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:ddish/src/models/movie.dart';

abstract class MovieLibraryEvent extends Equatable{
  MovieLibraryEvent([List props = const []]) : super(props);
}

class MovieSelected extends MovieLibraryEvent {
  MovieSelected();
  @override
  String toString() => "movie list loading";
}

class MovieRentClicked extends MovieLibraryEvent {
  final int movieId;

  MovieRentClicked({@required this.movieId});

  @override
  String toString() => "movie rent clicked. id: $movieId";
}