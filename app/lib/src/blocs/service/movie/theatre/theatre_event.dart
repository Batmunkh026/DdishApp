import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:ddish/src/models/movie.dart';

abstract class MovieTheatreEvent extends Equatable{
  MovieTheatreEvent([List props = const []]) : super(props);
}

class ChannelSelected extends MovieTheatreEvent {
  final Movie selectedMovie;
  ChannelSelected({this.selectedMovie});
  @override
  String toString() => "channel selected loading";
}


class MovieSelected extends MovieTheatreEvent {
  final Movie selectedMovie;
  MovieSelected({this.selectedMovie});
  @override
  String toString() => "movie list loading";
}

class MovieRentClicked extends MovieTheatreEvent {
  final int movieId;

  MovieRentClicked({@required this.movieId});

  @override
  String toString() => "movie rent clicked. id: $movieId";
}