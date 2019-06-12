import 'package:bloc/bloc.dart';
import 'package:ddish/src/blocs/service/movie/theatre/theatre_event.dart';
import 'package:ddish/src/blocs/service/movie/theatre/theatre_state.dart';

class MovieTheatreBloc extends Bloc<MovieTheatreEvent, MovieTheatreState> {
  @override
  MovieTheatreState get initialState => MovieListLoading();

  @override
  Stream<MovieTheatreState> mapEventToState(MovieTheatreEvent event) async* {
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
