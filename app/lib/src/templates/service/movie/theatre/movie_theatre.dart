import 'package:ddish/src/blocs/service/movie/theatre/theatre_bloc.dart';
import 'package:ddish/src/blocs/service/movie/theatre/theatre_event.dart';
import 'package:ddish/src/blocs/service/movie/theatre/theatre_state.dart';
import 'package:ddish/src/models/program.dart';
import 'package:ddish/src/models/vod_channel.dart';
import 'package:ddish/src/repositiories/vod_repository.dart';
import 'package:ddish/src/templates/service/movie/description/program_description.dart';
import 'package:ddish/src/templates/service/movie/program_search.dart';
import 'package:ddish/src/templates/service/movie/theatre/search.dart';
import 'package:ddish/src/widgets/movie/channel_thumbnail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'channel_header.dart';
import 'program_tile.dart';

class TheatreWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TheatreWidgetState();
}

class TheatreWidgetState extends State<TheatreWidget> {
  final _searchFieldController = TextEditingController();
  VodRepository vodRepository;
  MovieTheatreBloc _bloc;
  DateTime date = DateTime.now();

  VodChannel selectedChannel;
  Program selectedProgram;

  @override
  void initState() {
    vodRepository = VodRepository();
    _searchFieldController.addListener(onSearchTextChange());
    _bloc = MovieTheatreBloc(vodRepository: vodRepository);
    super.initState();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
//    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Column(
      children: <Widget>[
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: selectedChannel == null
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: ProgramSearchWidget(
                      searchById: false,
                      onSearchTap: onSearchTap,
                      controller: _searchFieldController,
                    ),
                  )
                : ChannelHeaderWidget(
                    selectedChannel: selectedChannel,
                    onReturnTap: onReturnTap,
                    onDateValueChanged: onDateChange,
                  )),
        Expanded(
          child: BlocBuilder<MovieTheatreEvent, MovieTheatreState>(
            bloc: _bloc,
            builder: (BuildContext context, MovieTheatreState state) {
              if (state is TheatreStateInitial) {
                _bloc.dispatch(MovieTheatreStarted());
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is ChannelListLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is ChannelListLoaded) {
                List<VodChannel> channels = state.channelList;
                return GridView.count(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  crossAxisSpacing: width * 0.1,
                  padding: EdgeInsets.symmetric(horizontal: width * 0.08),
                  crossAxisCount: 2,
                  children: List.generate(channels.length, (index) {
                    return ChannelThumbnail(
                        onPressed: () => onVodChannelTap(channels[index]),
                        channel: channels[index]);
                  }),
                );
              }
              if (state is ProgramListLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is ProgramListLoaded) {
                List<Program> programList = state.programList;
                return programList != null && programList.isNotEmpty
                    ? ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: programList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ProgramTile(
                            program: programList[index],
                            onTap: () => onProgramTap(programList[index]),
                          );
                        },
                      )
                    : Center(
                        child: Text('Үр дүн олдсонгүй.'),
                      );
              }
              if (state is ProgramDetailsLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is ProgramDetailsLoaded) {
                return ProgramDescription(
                  content: state.content,
                  selectedProgram: selectedProgram,
                  channel: selectedChannel,
                );
              }
              if (state is SearchResultOpened) {
                return SearchResult(value: _searchFieldController.text,);
              }
              return Container();
            },
          ),
        ),
      ],
    );
  }

  onDateChange(DateTime date) {
    this.date = date;
    if (selectedChannel != null)
      _bloc.dispatch(DateChanged(date: date, channel: selectedChannel));
  }

  onSearchTap() {
    _bloc.dispatch(SearchTapped(value: _searchFieldController.text));
  }

  onSearchTextChange() {
    if (_bloc != null && _searchFieldController.text.isEmpty)
      _bloc.dispatch(MovieTheatreStarted());
  }

  onProgramTap(Program program) {
    selectedProgram = program;
    _bloc.dispatch(ProgramTapped(selectedProgram: program));
  }

  onReturnTap() {
    if (selectedProgram != null) {
      setState(() => selectedProgram = null);
      _bloc.dispatch(ChannelSelected(channel: selectedChannel, date: date));
    } else if (selectedChannel != null) {
      setState(() => selectedChannel = null);
      _bloc.dispatch(MovieTheatreStarted());
    }
  }

  onVodChannelTap(VodChannel channel) {
    setState(() => selectedChannel = channel);

    _bloc.dispatch(ChannelSelected(channel: channel));
  }

  onRentAgree() {
//    _bloc.dispatch(RentTapped(channel: selectedChannel, rentProgram: selectedProgram));
  }
}
