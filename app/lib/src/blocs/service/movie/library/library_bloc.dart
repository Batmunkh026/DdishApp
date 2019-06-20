import 'package:bloc/bloc.dart';
import 'package:ddish/src/blocs/service/movie/library/library_event.dart';
import 'package:ddish/src/blocs/service/movie/library/library_state.dart';
import 'package:ddish/src/models/result.dart';
import 'package:ddish/src/repositiories/vod_repository.dart';

class MovieLibraryBloc extends Bloc<MovieLibraryEvent, MovieLibraryState> {
  final VodRepository repository;

  MovieLibraryBloc({this.repository});

  @override
  MovieLibraryState get initialState => ContentListLoading();

  @override
  Stream<MovieLibraryState> mapEventToState(MovieLibraryEvent event) async* {
    if (event is ContentLibraryStarted) {
      yield ContentListLoading();
      List<String> posterUrls = await repository.fetchPushVod();
      yield ContentListLoaded(posterUrls: posterUrls);
    }
    if (event is ContentOrderClicked) {
      yield ContentOrderRequestProcessing();
      Result result = await repository.rentContent(event.contentId);
      yield ContentOrderRequestFinished(result: result);
    }
  }
}
