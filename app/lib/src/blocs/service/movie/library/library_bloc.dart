import 'package:bloc/bloc.dart';
import 'package:ddish/src/blocs/menu/menu_state.dart';
import 'package:ddish/src/blocs/service/movie/library/library_event.dart';
import 'package:ddish/src/blocs/service/movie/library/library_state.dart';

class MovieLibraryBloc extends Bloc<MovieLibraryEvent, MovieLibraryState> {

  @override
  MovieLibraryState get initialState => MovieListInitial();

  @override
  Stream<MovieLibraryState> mapEventToState(MovieLibraryEvent event) async* {
    if(event is MovieListInitial) {
      yield MovieListLoading();
      // TODO fetch movies
      yield MovieListLoaded();
    }
    if(event is MovieSelected) {
      yield MovieDetailsLoading();
      // TODO fetch movie details
      yield MovieDetailsLoaded();
    }
    if(event is MovieRentClicked) {
      yield MovieIdConfirmProcessing();
      // TODO movieID confirm request
      yield MovieIdProcessingFinished();
    }
  }
}
