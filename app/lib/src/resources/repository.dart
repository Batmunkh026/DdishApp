import 'dart:async';
import 'movie_api_provider.dart';
import '../models/movie.dart';

class Repository {
  final movieApiProvider = MovieApiProvider();

  Future<List<Movie>> fetchMovies() => movieApiProvider.fetchMovies();
}
