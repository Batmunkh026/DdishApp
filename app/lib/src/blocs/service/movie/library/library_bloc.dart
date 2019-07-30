import 'package:bloc/bloc.dart';
import 'package:ddish/src/abstract/abstract.dart';
import 'package:ddish/src/blocs/service/movie/library/library_event.dart';
import 'package:ddish/src/blocs/service/movie/library/library_state.dart';
import 'package:ddish/src/models/result.dart';
import 'package:ddish/src/repositiories/vod_repository.dart';

class MovieLibraryBloc extends AbstractBloc<MovieLibraryEvent, MovieLibraryState> {
  VodRepository _repository;

  MovieLibraryBloc(pageState):super(pageState){
    _repository = VodRepository(this);  
  }

  @override
  MovieLibraryState get initialState => ContentListLoading();

  @override
  Stream<MovieLibraryState> mapEventToState(MovieLibraryEvent event) async* {
    if (event is ContentLibraryStarted) {
      yield ContentListLoading();
      List<String> posterUrls = await _repository.fetchPushVod();
      yield ContentListLoaded(posterUrls: posterUrls);
    }
    if (event is ContentOrderClicked) {
      yield ContentOrderRequestProcessing();
      Result result = await _repository.rentContent(event.contentId);
      yield ContentOrderRequestFinished(result: result);
    }
  }
}
