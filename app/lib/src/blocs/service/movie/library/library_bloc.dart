import 'package:bloc/bloc.dart';
import 'package:ddish/src/blocs/service/movie/library/library_event.dart';
import 'package:ddish/src/blocs/service/movie/library/library_state.dart';

class MovieLibraryBloc extends Bloc<MovieLibraryEvent, MovieLibraryState> {
  @override
  MovieLibraryState get initialState => MovieListLoading();

  @override
  Stream<MovieLibraryState> mapEventToState(MovieLibraryEvent event) async* {
    if (event is MovieListLoading) {
      yield MovieListLoading();
      // TODO fetch movies
      yield MovieListLoaded();
    }
    if (event is MovieSelected) {
      yield MovieDetailsOpened(movie: event.selectedMovie);
    }
    if (event is MovieRentClicked) {
      yield MovieIdConfirmProcessing();
      // TODO movieID confirm request
      yield MovieIdProcessingFinished();
    }
  }
}
