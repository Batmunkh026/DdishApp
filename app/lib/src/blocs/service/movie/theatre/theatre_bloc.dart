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
      VodChannelList vodChannels = await vodRepository.fetchVodChannels();
      yield ChannelListLoaded(channelList: vodChannels.vodChannels);
    }
    if(event is ChannelSelected) {
      yield ProgramListLoading(channel: event.channel);
      ProgramList programList = await vodRepository.fetchProgramList(event.channel, date: event.date);
      yield ProgramListLoaded(programList: programList.programs);
    }
    if(event is DateChanged) {
      yield ProgramListLoading(channel: event.channel);
      ProgramList programList = await vodRepository.fetchProgramList(event.channel, date: event.date);
      yield ProgramListLoaded(programList: programList.programs);
    }

    if(event is ProgramTapped) {
      yield ProgramDetailsLoading();
      Movie contentDetails = await vodRepository.fetchContentDetails(event.selectedProgram);
      yield ProgramDetailsLoaded(content: contentDetails);
    }
  }
}
