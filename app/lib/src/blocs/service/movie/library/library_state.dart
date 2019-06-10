import 'package:ddish/src/models/movie.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

///Багцын төлөв
abstract class MovieLibraryState extends Equatable {}

class MovieListLoading extends MovieLibraryState {
  @override
  String toString() => 'movie list loading.';
}

class MovieListLoaded extends MovieLibraryState {
  final List<Movie> movies;

  MovieListLoaded({@required this.movies});

  @override
  String toString() => 'movie list loaded.';
}

class MovieDetailsOpened extends MovieLibraryState {
  final Movie movie;

  MovieDetailsOpened({@required this.movie});
  @override
  String toString() => 'movie details loaded.';
}

class MovieListInitial extends MovieLibraryState {
  MovieListInitial();
  @override
  String toString() => "movie list initial";
}

class MovieIdConfirmProcessing extends MovieLibraryState {
  MovieIdConfirmProcessing();
  @override
  String toString() => "movie list initial";
}

class MovieIdProcessingFinished extends MovieLibraryState {
  MovieIdProcessingFinished();
  @override
  String toString() => "movie list initial";
}