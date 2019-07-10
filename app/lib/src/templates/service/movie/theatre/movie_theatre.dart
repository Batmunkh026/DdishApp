import 'package:ddish/src/blocs/service/movie/theatre/theatre_bloc.dart';
import 'package:ddish/src/blocs/service/movie/theatre/theatre_event.dart';
import 'package:ddish/src/blocs/service/movie/theatre/theatre_state.dart';
import 'package:ddish/src/models/program.dart';
import 'package:ddish/src/models/vod_channel.dart';
import 'package:ddish/src/repositiories/vod_repository.dart';
import 'package:ddish/src/templates/service/movie/description/program_description.dart';
import 'package:ddish/src/templates/service/movie/program_search.dart';
import 'package:ddish/src/utils/date_util.dart';
import 'package:ddish/src/widgets/movie/channel_thumbnail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ddish/src/widgets/movie/poster_image.dart';

import 'channel_header.dart';
import 'style.dart' as style;

class TheatreWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TheatreWidgetState();
}

class TheatreWidgetState extends State<TheatreWidget> {
  VodRepository vodRepository;
  MovieTheatreBloc _bloc;
  DateTime date = DateTime.now();

  VodChannel selectedChannel;
  Program selectedProgram;
  TextEditingController textController = new TextEditingController();

  double _height = 0;
  double _width = 0;

  @override
  void initState() {
    vodRepository = VodRepository();
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
    initializeConfig(context);

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
                      fontSize: 12,
                      controller: textController,
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
                  crossAxisSpacing: _width * 0.1,
                  padding: EdgeInsets.symmetric(horizontal: _width * 0.08),
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
              if (state is ProgramListLoaded)
                return buildPrograms(state.programList);

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
    // кино хайх
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

  Widget buildPrograms(List<Program> programs) {
    if (programs.isEmpty) return Center(child: Text('Хөтөлбөр ороогүй байна'));

    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: programs.length,
      itemBuilder: (BuildContext context, int index) {
        Program program = programs[index];
        return Container(
          height: _height * 0.15,
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: GestureDetector(
            onTap: () => onProgramTap(programs[index]),
            child: ListTile(
              title: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: PosterImage(
                      url: program.posterUrl,
                    ),
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(program.contentNameMon,
                            overflow: TextOverflow.ellipsis,
                            style: style.programTitleStyle),
                        Visibility(
                          visible: program.contentGenres != null &&
                              program.contentGenres.isNotEmpty,
                          child: Text(program.contentGenres,
                              overflow: TextOverflow.ellipsis,
                              style: style.programGenresStyle),
                        ),
                        Text(DateUtil.formatTime(program.beginDate),
                            style: style.programStartTimeStyle),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void initializeConfig(BuildContext context) {
    if (_height == 0 || _width == 0) {
      Size size = MediaQuery.of(context).size;
      _height = size.height;
      _width = size.width;
    }
  }
}
