import 'package:bloc/bloc.dart';
import 'package:ddish/src/blocs/service/movie/library/library_event.dart';
import 'package:ddish/src/blocs/service/movie/library/library_state.dart';
import 'package:ddish/src/repositiories/vod_repository.dart';

class MovieLibraryBloc extends Bloc<MovieLibraryEvent, MovieLibraryState> {
  final VodRepository repository;

  MovieLibraryBloc({this.repository});
  @override
  MovieLibraryState get initialState => MovieListLoading();

  @override
  Stream<MovieLibraryState> mapEventToState(MovieLibraryEvent event) async* {
    if (event is MovieLibraryStarted) {
      yield MovieListLoading();
      List<String> posterUrls = await repository.fetchPushVod();
      yield MovieListLoaded(posterUrls: posterUrls);
    }
    if (event is MovieRentClicked) {
      yield MovieIdConfirmProcessing();
      // TODO movieID confirm request
      yield MovieIdProcessingFinished();
    }
  }
}
