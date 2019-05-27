import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';
import '../models/movie.dart';

class MovieBloc {
  final _repository = Repository();
  final _movieFetcher = PublishSubject<List<Movie>>();

  Observable<List<Movie>> get allMovies => _movieFetcher.stream;

  fetchMovies() async {
    List<Movie> movies = await _repository.fetchMovies();
    _movieFetcher.sink.add(movies);
  }

  dispose() {
    _movieFetcher.close();
  }
}
