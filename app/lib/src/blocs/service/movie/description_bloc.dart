import 'package:bloc/bloc.dart';
import 'package:ddish/src/abstract/abstract.dart';
import 'package:ddish/src/blocs/service/movie/description_event.dart';
import 'package:ddish/src/blocs/service/movie/description_state.dart';
import 'package:ddish/src/models/movie.dart';
import 'package:ddish/src/models/result.dart';
import 'package:ddish/src/repositiories/vod_repository.dart';

class ProgramDescriptionBloc
    extends AbstractBloc<DescriptionEvent, DescriptionState> {
  VodRepository _vodRepository;

  ProgramDescriptionBloc(pageState) : super(pageState);
  @override
  DescriptionState get initialState {
    _vodRepository = VodRepository(this);
    return ProgramDescriptionInitial();
  }

  @override
  Stream<DescriptionState> mapEventToState(DescriptionEvent event) async* {
    if (event is ProgramDescriptionStarted) {
      yield ProgramDetailsLoading();
      Movie contentDetails =
          await _vodRepository.fetchContentDetails(event.selectedProgram);
      yield ProgramDetailsLoaded(content: contentDetails);
    }
    if (event is RentTapped) {
      yield RentRequestProcessing();
      Result result = await _vodRepository.chargeProduct(event.rentProgram);
      yield RentRequestFinished(result: result);
    }
  }
}
