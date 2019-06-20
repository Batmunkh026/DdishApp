import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class MovieLibraryEvent extends Equatable{
  MovieLibraryEvent([List props = const []]) : super(props);
}

class MovieLibraryStarted extends MovieLibraryEvent {
  MovieLibraryStarted();
  @override
  String toString() => "movie library started.";
}

class MovieRentClicked extends MovieLibraryEvent {
  final int movieId;

  MovieRentClicked({@required this.movieId});

  @override
  String toString() => "movie rent clicked. id: $movieId";
}