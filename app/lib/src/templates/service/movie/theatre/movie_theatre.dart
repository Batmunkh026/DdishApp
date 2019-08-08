import 'package:ddish/src/blocs/service/movie/theatre/theatre_bloc.dart';
import 'package:ddish/src/blocs/service/movie/theatre/theatre_event.dart';
import 'package:ddish/src/blocs/service/movie/theatre/theatre_state.dart';
import 'package:ddish/src/models/program.dart';
import 'package:ddish/src/models/vod_channel.dart';
import 'package:ddish/src/templates/service/movie/description/program_description.dart';
import 'package:ddish/src/templates/service/movie/program_search.dart';
import 'package:ddish/src/templates/service/movie/theatre/search_header.dart';
import 'package:ddish/src/utils/date_util.dart';
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
  final _scrollController = ScrollController();
  MovieTheatreBloc _bloc;
  DateTime date = DateTime.now();
  List<VodChannel> channelList;
  List<Program> content;

  VodChannel selectedChannel;
  Program selectedProgram;
  bool searchHeaderVisible = false;

  @override
  void initState() {
    _bloc = MovieTheatreBloc(this);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final fontSize = MediaQuery.of(context).size.height / 300 * 6;
    bool isTheatreChannelDetail = selectedChannel != null;
    var contentContainer = Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: !isTheatreChannelDetail
              ? Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: ProgramSearchWidget(
                    searchById: false,
                    onSearchTap: _onSearchTap,
                    controller: _searchFieldController,
                    onReturnTap: _onReturnTap,
                  ),
                )
              : Container(
                  child: ChannelHeaderWidget(
                    date: date,
                    selectedChannel: selectedChannel,
                    onReturnTap: _onReturnTap,
                    onDateValueChanged: _searchFieldController.text.isEmpty
                        ? _onDateChange
                        : null,
                  ),
                ),
        ),
        Visibility(
            visible: searchHeaderVisible,
            child: SearchHeader(
              onReturnTap: _onReturnTap,
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
                channelList = state.channelList;
                return Container(
                  padding: EdgeInsets.only(top: 30),
                  child: GridView.count(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    crossAxisSpacing: width * 0.05,
                    padding: EdgeInsets.symmetric(horizontal: width * 0.08),
                    childAspectRatio: 1.6,
                    crossAxisCount: 2,
                    children: List.generate(channelList.length, (index) {
                      return ChannelThumbnail(
                          onPressed: () => _onVodChannelTap(channelList[index]),
                          channel: channelList[index]);
                    }),
                  ),
                );
              }
              if (state is ProgramListLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is ProgramListLoaded) {
                content = state.programList ?? content;
                return content != null && content.isNotEmpty
                    ? ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: content.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ProgramTile(
                            program: content[index],
                            onTap: () => _onProgramTap(content[index]),
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
              if (state is SearchStarted) {
                if (!_scrollController.hasListeners)
                  _scrollController.addListener(_onSearchScroll);
                _bloc.dispatch(
                    ScrollReachedMax(value: _searchFieldController.text));
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is SearchResultLoaded) {
                content = state.programList ?? content;
                if (content == null || content.isEmpty) {
                  return Center(
                    child: Text('Үр дүн олдсонгүй'),
                  );
                }
                return ListView.builder(
                  itemCount: state.hasReachedMax != null &&
                          state.hasReachedMax &&
                          content.isNotEmpty
                      ? content.length
                      : content.length + 1,
                  controller: _scrollController,
                  itemBuilder: (BuildContext context, int index) {
                    return index >= content.length
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : ProgramTile(
                            program: content[index],
                            onTap: () => _onProgramTap(content[index]),
                          );
                  },
                );
              }
              return Container();
            },
          ),
        ),
      ],
    );

    return isTheatreChannelDetail
        ? GestureDetector(
            onHorizontalDragEnd: (details) {
              double _delta = details.velocity.pixelsPerSecond.dx;
              bool _isIncrement = _delta < 0;
              //date ыг өөрчлөх боломжтой эсэхийг шалгах, swipe range check
              //today <= nextDay <= Date.now() + 7days
              if ((!DateUtil.today(this.date) && !_isIncrement ||
                      DateUtil.isValidProgramDate(this.date) && _isIncrement) &&
                  _delta != 0.0) _onDateChange(date, _isIncrement);
            },
            child: contentContainer,
          )
        : contentContainer;
  }

  _onDateChange(DateTime date, bool isIncrement) {
    var duration = Duration(days: 1);
    date = isIncrement ? date.add(duration) : date.subtract(duration);

    this.date = date;

    if (selectedChannel != null)
      _bloc.dispatch(DateChanged(date: date, channel: selectedChannel));
    setState(() => this.date = date);
  }

  _onSearchTap() {
    content = List();
    setState(() => searchHeaderVisible = true);
    FocusScope.of(context).nextFocus();
    _bloc.dispatch(SearchTapped(value: _searchFieldController.text));
  }

  _onProgramTap(Program program) {
    selectedProgram = program;
    if (_searchFieldController.text.isNotEmpty) {
      setState(() {
        selectedChannel = channelList.firstWhere(
            (channel) => channel.productId == selectedProgram.productId);
        searchHeaderVisible = false;
      });
      date = program.beginDate;
    }
    _bloc.dispatch(ProgramTapped(selectedProgram: program));
  }

  _onReturnTap() {
    date = DateTime.now();
    if (selectedProgram != null) {
      setState(() {
        selectedProgram = null;
        if (_searchFieldController.text.isNotEmpty) selectedChannel = null;
        searchHeaderVisible = _searchFieldController.text.isNotEmpty;
      });
      _bloc.dispatch(ReturnTapped(
          search: _searchFieldController.text.isNotEmpty,
          programList: content));
//      _bloc.dispatch(ChannelSelected(channel: selectedChannel, date: date));
    } else {
      _searchFieldController.clear();
      setState(() {
        selectedChannel = null;
        searchHeaderVisible = false;
      });
      _bloc.dispatch(MovieTheatreStarted());
    }
  }

  _onVodChannelTap(VodChannel channel) {
    _searchFieldController.clear();
    setState(() => selectedChannel = channel);

    _bloc.dispatch(ChannelSelected(channel: channel));
  }

  _onSearchScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _bloc.dispatch(ScrollReachedMax(value: _searchFieldController.text));
    }
  }
}
