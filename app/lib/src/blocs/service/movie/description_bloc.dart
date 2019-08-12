import 'dart:async';
import 'package:ddish/src/abstract/abstract.dart';
import 'package:ddish/src/blocs/service/movie/description_event.dart';
import 'package:ddish/src/blocs/service/movie/description_state.dart';
import 'package:ddish/src/models/movie.dart';
import 'package:ddish/src/models/result.dart';
import 'package:ddish/src/repositiories/vod_repository.dart';
import 'package:ddish/src/repositiories/globals.dart' as globals;

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

  Timer updateSession() {
    return Timer.periodic(Duration(seconds: 30), (timer) {
      new Timer(Duration(seconds: 1), (){
        if (globals.client.credentials.canRefresh)
          globals.client.refreshCredentials().then((newClient) {
            globals.client = newClient;
            print("NEW EXPIRE DATE >> ${newClient.credentials.expiration}");
          });
      });
    });
  }

  cancelSessionUpdateTask(Timer sessionUpdateTask) {
    sessionUpdateTask.cancel();
  }
}
