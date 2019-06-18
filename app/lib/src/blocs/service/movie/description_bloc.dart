import 'package:bloc/bloc.dart';
import 'package:ddish/src/blocs/service/movie/description_event.dart';
import 'package:ddish/src/blocs/service/movie/description_state.dart';
import 'package:ddish/src/models/movie.dart';
import 'package:ddish/src/models/result.dart';
import 'package:ddish/src/repositiories/vod_repository.dart';

class ProgramDescriptionBloc extends Bloc<DescriptionEvent, DescriptionState> {
  VodRepository vodRepository;

  ProgramDescriptionBloc({this.vodRepository});

  @override
  DescriptionState get initialState => ProgramDescriptionInitial();

  @override
  Stream<DescriptionState> mapEventToState(DescriptionEvent event) async* {
    if (event is ProgramDescriptionStarted) {
      yield ProgramDetailsLoading();
      Movie contentDetails =
          await vodRepository.fetchContentDetails(event.selectedProgram);
      yield ProgramDetailsLoaded(content: contentDetails);
    }
    if (event is RentTapped) {
      yield RentRequestProcessing();
      Result result =
          await vodRepository.chargeProduct(event.rentProgram);
      yield RentRequestFinished(result: result);
    }
  }
}
