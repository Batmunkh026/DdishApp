import 'package:bloc/bloc.dart';
import 'package:ddish/src/blocs/service/movie/theatre/theatre_event.dart';
import 'package:ddish/src/blocs/service/movie/theatre/theatre_state.dart';
import 'package:ddish/src/models/movie.dart';
import 'package:ddish/src/models/program.dart';
import 'package:ddish/src/models/vod_channel.dart';
import 'package:ddish/src/repositiories/vod_repository.dart';

class MovieTheatreBloc extends Bloc<MovieTheatreEvent, MovieTheatreState> {
  final VodRepository vodRepository;

  MovieTheatreBloc({this.vodRepository});

  @override
  MovieTheatreState get initialState => TheatreStateInitial();

  @override
  Stream<MovieTheatreState> mapEventToState(MovieTheatreEvent event) async* {
    if (event is MovieTheatreStarted) {
      yield ChannelListLoading();
      List<VodChannel> vodChannels = await vodRepository.fetchVodChannels();
      yield ChannelListLoaded(channelList: vodChannels);
    }
    if (event is ChannelSelected) {
      yield ProgramListLoading(channel: event.channel);
      List<Program> programList =
          await vodRepository.fetchProgramList(event.channel, date: event.date);
      yield ProgramListLoaded(programList: programList);
    }
    if (event is DateChanged) {
      yield ProgramListLoading(channel: event.channel);
      List<Program> programList =
          await vodRepository.fetchProgramList(event.channel, date: event.date);
      yield ProgramListLoaded(programList: programList);
    }

    if (event is ProgramTapped) {
      yield ProgramDetailsLoading();
      Movie contentDetails =
          await vodRepository.fetchContentDetails(event.selectedProgram);
      yield ProgramDetailsLoaded(content: contentDetails);
    }

    if (event is SearchTapped) {
      yield SearchStarted();
    }

    bool _hasReachedMax(MovieTheatreState state) =>
        state is SearchResultLoaded && state.hasReachedMax;

    if (event is ScrollReachedMax && !_hasReachedMax(currentState)) {
      if (currentState is SearchStarted) {
        final result = await vodRepository.searchProgram(event.value, 0);
        yield SearchResultLoaded(
            programList: result, hasReachedMax: result.length < 10);
        return;
      }
      if (currentState is SearchResultLoaded) {
        final result = await vodRepository.searchProgram(event.value,
            (currentState as SearchResultLoaded).programList.length);
        yield result.isEmpty || result.length < 10
            ? (currentState as SearchResultLoaded).copyWith(hasReachedMax: true)
            : SearchResultLoaded(
                programList:
                    (currentState as SearchResultLoaded).programList + result,
                hasReachedMax: false,
              );
      }
    }

    if (event is ReturnTapped) {
      if(event.search)
        yield SearchResultLoaded(hasReachedMax: false, programList: event.programList);
      else
        yield ProgramListLoaded();
    }
  }
}
