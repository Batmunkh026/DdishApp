import 'package:ddish/src/models/movie.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

///Багцын төлөв
abstract class MovieTheatreState extends Equatable {}

class MovieListLoading extends MovieTheatreState {
  @override
  String toString() => 'movie list loading.';
}

class MovieListLoaded extends MovieTheatreState {
  final List<Movie> movies;

  MovieListLoaded({@required this.movies});

  @override
  String toString() => 'movie list loaded.';
}

class MovieDetailsOpened extends MovieTheatreState {
  final Movie movie;

  MovieDetailsOpened({@required this.movie});
  @override
  String toString() => 'movie details loaded.';
}

class MovieListInitial extends MovieTheatreState {
  MovieListInitial();
  @override
  String toString() => "movie list initial";
}

class MovieIdConfirmProcessing extends MovieTheatreState {
  MovieIdConfirmProcessing();
  @override
  String toString() => "movie list initial";
}

class MovieIdProcessingFinished extends MovieTheatreState {
  MovieIdProcessingFinished();
  @override
  String toString() => "movie list initial";
}